Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756444Ab2CLViu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 17:38:50 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54487 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391Ab2CLVis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 17:38:48 -0400
Date: Mon, 12 Mar 2012 14:38:45 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Hillf Danton <dhillf@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] hugetlbfs: add err code in initializing module
In-Reply-To: <CAJd=RBBn35FU99qoXwmPx+FK6=Vt-DXsCje3bAXYB+GrvR9hPg@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1203121438300.28343@chino.kir.corp.google.com>
References: <CAJd=RBBK4tx91ZQu0WKzBGx8E-Na6oUwmpBUQVB0yPkR=ySPjg@mail.gmail.com> <CAJd=RBB3202WV4zJratpp8c8VjkipNEbB_p9bGjLKrxr7qL-RA@mail.gmail.com> <alpine.DEB.2.00.1203111322550.20299@chino.kir.corp.google.com>
 <CAJd=RBBn35FU99qoXwmPx+FK6=Vt-DXsCje3bAXYB+GrvR9hPg@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Mar 2012, Hillf Danton wrote:

> From: Hillf Danton <dhillf@gmail.com>
> Subject: [PATCH] hugetlbfs: add err code in initilizing module
> 
> Error code is added if fail to create inode kmem cache, and newly registered
> hugetlb FS is unregistered if fail to mount, both for unlikely corner cases.
> 
> Signed-off-by: Hillf Danton <dhillf@gmail.com>

Acked-by: David Rientjes <rientjes@google.com>

> ---
> 
> --- a/fs/hugetlbfs/inode.c	Sun Mar 11 12:46:38 2012
> +++ b/fs/hugetlbfs/inode.c	Mon Mar 12 19:52:16 2012
> @@ -997,6 +997,7 @@ static int __init init_hugetlbfs_fs(void
>  	if (error)
>  		return error;
> 
> +	error = -ENOMEM;
>  	hugetlbfs_inode_cachep = kmem_cache_create("hugetlbfs_inode_cache",
>  					sizeof(struct hugetlbfs_inode_info),
>  					0, 0, init_once);
> @@ -1015,6 +1016,7 @@ static int __init init_hugetlbfs_fs(void
>  	}
> 
>  	error = PTR_ERR(vfsmount);
> +	unregister_filesystem(&hugetlbfs_fs_type);
> 
>   out:
>  	if (error)
> --
> 
