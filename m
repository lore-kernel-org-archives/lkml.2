Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757382Ab0DIJMm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 05:12:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32033 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755971Ab0DIJMl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 05:12:41 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1270792042-9358-2-git-send-email-paulmck@linux.vnet.ibm.com>
References: <1270792042-9358-2-git-send-email-paulmck@linux.vnet.ibm.com> <20100409054701.GA8833@linux.vnet.ibm.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
       rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, eric.dumazet@gmail.com
Subject: Re: [PATCH tip/core/urgent 2/4] RCU: Better explain the condition parameter of rcu_dereference_check()
Date: Fri, 09 Apr 2010 10:11:31 +0100
Message-ID: <23601.1270804291@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> + *	bar = rcu_dereference_check(foo->bar, rcu_read_lock_held() ||
> + *					      lockdep_is_held(&foo->lock),
> + *					      atomic_read(&foo->usage) == 0);

As pointed out by Yong Zhang, the comma after lockdep_is_held() should be a
||.

David
