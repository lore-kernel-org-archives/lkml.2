Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755411Ab2GJCCn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 22:02:43 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51931 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952Ab2GJCCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 22:02:41 -0400
Date: Mon, 9 Jul 2012 19:02:39 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Wanpeng Li <liwp.linux@gmail.com>
cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        William Irwin <wli@holomorphy.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/hugetlb: fix error code in hugetlbfs_alloc_inode
In-Reply-To: <1341882774-4772-1-git-send-email-liwp.linux@gmail.com>
Message-ID: <alpine.DEB.2.00.1207091901210.25143@chino.kir.corp.google.com>
References: <1341882774-4772-1-git-send-email-liwp.linux@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jul 2012, Wanpeng Li wrote:

> diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
> index c4b85d0..79a0f33 100644
> --- a/fs/hugetlbfs/inode.c
> +++ b/fs/hugetlbfs/inode.c
> @@ -696,7 +696,7 @@ static struct inode *hugetlbfs_alloc_inode(struct super_block *sb)
>  	p = kmem_cache_alloc(hugetlbfs_inode_cachep, GFP_KERNEL);
>  	if (unlikely(!p)) {
>  		hugetlbfs_inc_free_inodes(sbinfo);
> -		return NULL;
> +		return ERR_PTR(-ENOMEM);
>  	}
>  	return &p->vfs_inode;
>  }

So now you've removed Gavin Shan who already told you that it was correct 
as written and propose yet another bogus patch which will break.  This 
isn't professional.

alloc_inode() tests for a NULL return value, not for PTR_ERR(), so you 
would be introducing a bug if this patch were merged.  It's completely 
correct the way it's written.
