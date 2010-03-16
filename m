Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966559Ab0CPRkd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 13:40:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8007 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933221Ab0CPRka (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 13:40:30 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1268760954.3098.17.camel@localhost.localdomain>
References: <1268760954.3098.17.camel@localhost.localdomain> <20100316115130.25642.17789.stgit@warthog.procyon.org.uk> <20100316171738.GN6709@linux.vnet.ibm.com>
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: dhowells@redhat.com, paulmck@linux.vnet.ibm.com, linux-nfs@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] NFS: Fix RCU warnings in nfs_inode_return_delegation_noreclaim()
Date: Tue, 16 Mar 2010 17:40:04 +0000
Message-ID: <19197.1268761204@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trond Myklebust <Trond.Myklebust@netapp.com> wrote:

> > The lock is probably held here, in which case something like the
> > following would work well without needing the artificial rcu_read_lock()
> > and rcu_read_unlock():
> 
> No. The lock is not held here. At this point, the delegation has been
> detached from the inode that pointed to it, and so we can free up its
> contents.
> 
> We still need the call_rcu() to free up the allocated memory in order to
> ensure that some process doing lockless traversal of the
> clp->cl_delegations list doesn't crash.

In that case, surely you can't detach the credentials pointer until the
callback is invoked?

David
