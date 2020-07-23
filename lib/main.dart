import 'dart:core';
import 'dart:math';
import 'package:flutter/material.dart';
import 'components/chart.dart';
import 'components/transaction_form.dart';
import 'components/transaction_list.dart';
import 'models/transaction.dart';

main() => runApp(ExpensesApp());

class ExpensesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      theme: ThemeData(
        primarySwatch: Colors.purple,
        textTheme: ThemeData.light().textTheme.copyWith(
              button: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _showChart = false;
  final _transactions = [
    Transaction(
        id: 't1',
        title: 'new running sneaker',
        value: 299.99,
        date: DateTime.now()),
    Transaction(
      id: 't2',
      title: 'Internet bill',
      value: 29.99,
      date: DateTime.now().subtract(Duration(days: 5)),
    ),
  ];

  List<Transaction> get _recentTransactions {
    return _transactions
        .where((element) => element.date.isAfter(
              DateTime.now().subtract(
                Duration(days: 7),
              ),
            ))
        .toList();
  }

  _addTransaction(String title, double value, DateTime date) {
    final newTransaction = Transaction(
      id: Random().nextDouble().toString(),
      title: title,
      value: value,
      date: date,
    );

    setState(() {
      _transactions.add(newTransaction);
    });

    Navigator.of(context).pop();
  }

  _deleteTransaction(String id) {
    setState(() {
      _transactions.removeWhere((element) => element.id == id);
    });
  }

  _openFormModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return TransactionForm(this._addTransaction);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    final appBar = AppBar(
      title: Text('Personal expenses'),
      actions: <Widget>[
        IconButton(
            icon: Icon(Icons.add), onPressed: () => _openFormModal(context)),
      ],
    );

    final availableHeight = MediaQuery.of(context).size.height -
        appBar.preferredSize.height -
        MediaQuery.of(context).padding.top;

    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (isLandscape)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Show chart'),
                  Switch(
                    value: _showChart,
                    onChanged: (value) => setState(() {
                      _showChart = value;
                    }),
                  ),
                ],
              ),
            if (_showChart || !isLandscape)
              Container(
                child: Chart(_recentTransactions),
                height: availableHeight * (isLandscape ? 0.7 : 0.3),
              ),
            if (!_showChart || !isLandscape)
              Container(
                child: TransactionList(_recentTransactions, _deleteTransaction),
                height: availableHeight * 0.7,
              ),
          ],
        ),
      ),
    );
  }
}
