Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754343Ab0DTKQ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 06:16:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17396 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754153Ab0DTKQ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 06:16:56 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1271355219-20714-10-git-send-email-paulmck@linux.vnet.ibm.com>
References: <1271355219-20714-10-git-send-email-paulmck@linux.vnet.ibm.com> <20100415181255.GA19588@linux.vnet.ibm.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
       rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, eric.dumazet@gmail.com
Subject: Re: [PATCH RFC tip/core/rcu 10/16] rcu: slim down rcutiny by removing rcu_scheduler_active and friends
Date: Tue, 20 Apr 2010 11:15:08 +0100
Message-ID: <31681.1271758508@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> +void rcu_scheduler_starting(void)
> +{
> +	WARN_ON(nr_context_switches() > 0);
> +	rcu_scheduler_active = 1;
> +}

Since rcu_scheduler_active is a global variable, does it make sense to make
this an inline function in the header file?

It looks decidedly odd in its own include file as you've done it.  Wouldn't
the right way to do this be to split it into its own .c file and conditionally
compile it in the Makefile?

David
