Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754205Ab0C2WX6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 18:23:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39783 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752985Ab0C2WX4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 18:23:56 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20100329210520.GN2569@linux.vnet.ibm.com>
References: <20100329210520.GN2569@linux.vnet.ibm.com> <20100329192159.GM2569@linux.vnet.ibm.com> <20100319022527.GC2894@linux.vnet.ibm.com> <20100318133302.29754.1584.stgit@warthog.procyon.org.uk> <19192.1269889348@redhat.com> <23274.1269893706@redhat.com>
To: paulmck@linux.vnet.ibm.com, Eric Dumazet <eric.dumazet@gmail.com>
Cc: dhowells@redhat.com, Trond.Myklebust@netapp.com, linux-nfs@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] NFS: Fix RCU warnings in nfs_inode_return_delegation_noreclaim() [ver #2]
Date: Mon, 29 Mar 2010 23:22:30 +0100
Message-ID: <25276.1269901350@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> And rcu_dereference_raw() is the same as the old rcu_dereference().

Exactly.  That's the other half of the issue - that interpolates a redundant
memory barrier.

David
