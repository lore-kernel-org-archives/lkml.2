Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330Ab0IPObN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 10:31:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18961 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752387Ab0IPObL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 10:31:11 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <E1OwEjQ-0006wS-MU@pomaz-ex.szeredi.hu>
References: <E1OwEjQ-0006wS-MU@pomaz-ex.szeredi.hu> <E1Ovt6F-0005CS-RU@pomaz-ex.szeredi.hu> <3777.1284638136@redhat.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: dhowells@redhat.com, paulmck@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: memory barrier question
Date: Thu, 16 Sep 2010 15:30:56 +0100
Message-ID: <6383.1284647456@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi <miklos@szeredi.hu> wrote:

> Is the rmb() really needed?
> 
> Take this code from fs/namei.c for example:
> 
> 		inode = next.dentry->d_inode;
> 		if (!inode)
> 			goto out_dput;
> 
> 		if (inode->i_op->follow_link) {
> 
> It happily dereferences dentry->d_inode without a barrier after
> checking it for non-null, while that d_inode might have just been
> initialized on another CPU with a freshly created inode.  There's
> absolutely no synchornization with that on this side.

Perhaps it's not necessary; once set, how likely is i_op to be changed once
I_NEW is cleared?

> Isn't the fact that we check the pointer for being non-null (together
> with locking/barrier on the other side) enough to ensure that it's
> safe to dereference it?

It's possible that since there's a dependency between the variables on the
reading CPU that the barrier is not required.

I think I have to refer that question to Paul.

David
