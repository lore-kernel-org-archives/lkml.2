Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752053Ab2CKUZa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 16:25:30 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:43830 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394Ab2CKUZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 16:25:23 -0400
Date: Sun, 11 Mar 2012 13:25:20 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Hillf Danton <dhillf@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] hugetlbfs: add err code in initializing module
In-Reply-To: <CAJd=RBB3202WV4zJratpp8c8VjkipNEbB_p9bGjLKrxr7qL-RA@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1203111322550.20299@chino.kir.corp.google.com>
References: <CAJd=RBBK4tx91ZQu0WKzBGx8E-Na6oUwmpBUQVB0yPkR=ySPjg@mail.gmail.com> <CAJd=RBB3202WV4zJratpp8c8VjkipNEbB_p9bGjLKrxr7qL-RA@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 Mar 2012, Hillf Danton wrote:

> --- a/fs/hugetlbfs/inode.c	Sun Mar 11 12:46:38 2012
> +++ b/fs/hugetlbfs/inode.c	Sun Mar 11 12:49:28 2012
> @@ -1000,6 +1000,7 @@ static int __init init_hugetlbfs_fs(void
>  	hugetlbfs_inode_cachep = kmem_cache_create("hugetlbfs_inode_cache",
>  					sizeof(struct hugetlbfs_inode_info),
>  					0, 0, init_once);
> +	error = -ENOMEM;
>  	if (hugetlbfs_inode_cachep == NULL)
>  		goto out2;
> 

The patch looks good, however, we typically do things like

	error = -ENOMEM;
	hugetlbfs_inode_cachep = kmem_cache_create(...);
	if (!hugetlbfs_inode_cachep)
		...

instead.  Sometimes people grep to see if a call a function that can fail, 
such as kmem_cache_create(), is followed up by a check for NULL and this 
would otherwise fail.
