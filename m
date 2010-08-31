Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757593Ab0HaPc3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 11:32:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5525 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757583Ab0HaPc1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 11:32:27 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20100831151212.GB2421@linux.vnet.ibm.com>
References: <20100831151212.GB2421@linux.vnet.ibm.com> <20100830172631.GA11868@linux.vnet.ibm.com> <7899.1283259751@redhat.com>
To: paulmck@linux.vnet.ibm.com
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
        laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, dvhltc@us.ibm.com,
        niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, eric.dumazet@gmail.com,
        jslaby@suse.cz, jmorris@namei.org
Subject: Re: [PATCH RFC] pid: make setpgid() system call use RCU read-side critical section
Date: Tue, 31 Aug 2010 16:31:29 +0100
Message-ID: <10401.1283268689@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> It turns out that the setpgid() system call fails to enter an RCU
> read-side critical section before doing a PID-to-task_struct translation.
> This commit therefore does rcu_read_lock() before the translation, and
> also does rcu_read_unlock() after the last use of the returned pointer.
> 
> Reported-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Acked-by: David Howells <dhowells@redhat.com>
