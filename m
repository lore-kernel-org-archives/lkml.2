Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109Ab0DTIsk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 04:48:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34536 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754047Ab0DTIsj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 04:48:39 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1271698361.13653.79.camel@localhost.localdomain>
References: <1271698361.13653.79.camel@localhost.localdomain> <14317.1271691185@redhat.com>
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: dhowells@redhat.com, paulmck@linux.vnet.ibm.com, linux-nfs@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: RCU-isms in fs/nfs/delegation.c
Date: Tue, 20 Apr 2010 09:48:34 +0100
Message-ID: <32174.1271753314@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trond Myklebust <Trond.Myklebust@netapp.com> wrote:

> +		nfs_inode_set_delegation(inode, cred, res);
> +	}
> +out:
> +	rcu_read_unlock();
>  }

I think this is wrong.  nfs_inode_set_delegation() may sleep as it calls
kmalloc() with GFP_KERNEL - but you still have the RCU read lock held.  I
think you need to drop the RCU read lock before calling it.

David
