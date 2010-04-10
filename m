Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751273Ab0DJIPr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Apr 2010 04:15:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32321 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751062Ab0DJIPl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Apr 2010 04:15:41 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1270852752-25278-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <1270852752-25278-1-git-send-email-paulmck@linux.vnet.ibm.com> <20100409223843.GA25133@linux.vnet.ibm.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
       rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, eric.dumazet@gmail.com
Subject: Re: [PATCH tip/core/urgent 1/3] rcu: add rcu_access_pointer and rcu_dereference_protected
Date: Sat, 10 Apr 2010 09:13:50 +0100
Message-ID: <9850.1270887230@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> This patch adds variants of rcu_dereference() that handle situations
> where the RCU-protected data structure cannot change, perhaps due to
> our holding the update-side lock, or where the RCU-protected pointer is
> only to be fetched, not dereferenced.  These are needed due to some
> performance concerns with using rcu_dereference() where it is not
> required, aside from the need for lockdep/sparse checking.
> 
> The new rcu_access_pointer() primitive is for the case where the pointer
> is be fetch and not dereferenced.  This primitive may be used without
> protection, RCU or otherwise, due to the fact that it uses ACCESS_ONCE().
> 
> The new rcu_dereference_protected() primitive is for the case where updates
> are prevented, for example, due to holding the update-side lock.  This
> primitive does neither ACCESS_ONCE() nor smp_read_barrier_depends(), so
> can only be used when updates are somehow prevented.
> 
> Suggested-by: David Howells <dhowells@redhat.com>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Acked-by: David Howells <dhowells@redhat.com>
