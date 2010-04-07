Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932873Ab0DGRVv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 13:21:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3662 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758063Ab0DGRVu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 13:21:50 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20100407171342.GF2481@linux.vnet.ibm.com>
References: <20100407171342.GF2481@linux.vnet.ibm.com> <20100407162620.GA11543@linux.vnet.ibm.com> <27310.1270659627@redhat.com>
To: paulmck@linux.vnet.ibm.com
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
       rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, eric.dumazet@gmail.com
Subject: Re: [PATCH tip/urgent] rcu: add rcu_access_pointer and rcu_dereference_protected
Date: Wed, 07 Apr 2010 18:20:48 +0100
Message-ID: <27837.1270660848@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> In other cases, there will be a reference counter or a "not yet fully
> initialized" flag that can (and should) be tested.

Why would you be using rcu_access_pointer() there?  Why wouldn't you be using
rcu_dereference_protected()?


Also, one other thing:  Should the default versions of these functions make
some reference to 'c' to prevent compiler warnings?  Should:

	#define rcu_dereference_check(p, c)	rcu_dereference_raw(p)

for example, be:

	#define rcu_dereference_check(p, c)	\
	({					\
		if (1 || !(c))			\
			rcu_dereference_raw(p);	\
	})

I'm not sure it's necessary, but it's possible to envisage a situation where
someone calculates something specifically for use in 'c', which will cause an
warning from the compiler if c isn't then checked.

David
