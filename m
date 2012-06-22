Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933054Ab2FVQD2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 12:03:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63730 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755588Ab2FVQDZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 12:03:25 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1340379312-6684-4-git-send-email-paulmck@linux.vnet.ibm.com>
References: <1340379312-6684-4-git-send-email-paulmck@linux.vnet.ibm.com> <20120622153501.GA6626@linux.vnet.ibm.com> <1340379312-6684-1-git-send-email-paulmck@linux.vnet.ibm.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
        laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org
Subject: Re: [PATCH tip/core/rcu 04/17] rcu: Add a gcc-style structure initializer for RCU pointers
Date: Fri, 22 Jun 2012 17:02:09 +0100
Message-ID: <29932.1340380929@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> RCU_INIT_POINTER() returns a value that is never used, and which should
> be abolished due to terminal ugliness:
> 
> 	q = RCU_INIT_POINTER(global_p, p);
> 
> However, there are two uses that cannot be handled by a do-while
> formulation because they do gcc-style initialization:
> 
> 	RCU_INIT_POINTER(.real_cred, &init_cred),
> 	RCU_INIT_POINTER(.cred, &init_cred),
> 
> This usage is clever, but not necessarily the nicest approach.
> This commit therefore creates an RCU_POINTER_INITIALIZER() macro that
> is specifically designed for gcc-style initialization.
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Acked-by: David Howells <dhowells@redhat.com>
