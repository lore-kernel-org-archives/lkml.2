Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758964Ab0EEKPK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 06:15:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27964 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752120Ab0EEKPG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 06:15:06 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1273004398-19760-36-git-send-email-paulmck@linux.vnet.ibm.com>
References: <1273004398-19760-36-git-send-email-paulmck@linux.vnet.ibm.com> <20100504201934.GA19234@linux.vnet.ibm.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
       rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, eric.dumazet@gmail.com,
       Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH tip/core/rcu 36/48] nfs: __rcu annotations
Date: Wed, 05 May 2010 11:14:03 +0100
Message-ID: <23175.1273054443@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

>  struct nfs_delegation {
>  	struct list_head super_list;
> -	struct rpc_cred *cred;
> +	struct rpc_cred __rcu *cred;
>  	struct inode *inode;
>  	nfs4_stateid stateid;
>  	fmode_t type;

That's unnecessary.  I posted a patch that removed the usage of RCU on that
pointer:

	Date: Tue, 20 Apr 2010 11:26:13 +0100
	Subject: NFS: Fix RCU issues in the NFSv4 delegation code

Did Trond take it?

David
