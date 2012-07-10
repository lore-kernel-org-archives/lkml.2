Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752902Ab2GJCBJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 22:01:09 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60656 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952Ab2GJCBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 22:01:07 -0400
Date: Mon, 9 Jul 2012 19:01:04 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Wanpeng Li <liwp.linux@gmail.com>
cc: Gavin Shan <shangw@linux.vnet.ibm.com>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        William Irwin <wli@holomorphy.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/hugetlb: fix error code in hugetlbfs_alloc_inode
In-Reply-To: <20120710011516.GA2457@kernel>
Message-ID: <alpine.DEB.2.00.1207091859280.25143@chino.kir.corp.google.com>
References: <1341882184-4549-1-git-send-email-liwp.linux@gmail.com> <20120710010910.GA7362@shangw> <20120710011516.GA2457@kernel>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jul 2012, Wanpeng Li wrote:

> >>diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
> >>index c4b85d0..79a0f33 100644
> >>--- a/fs/hugetlbfs/inode.c
> >>+++ b/fs/hugetlbfs/inode.c
> >>@@ -696,7 +696,7 @@ static struct inode *hugetlbfs_alloc_inode(struct super_block *sb)
> >> 	p = kmem_cache_alloc(hugetlbfs_inode_cachep, GFP_KERNEL);
> >> 	if (unlikely(!p)) {
> >> 		hugetlbfs_inc_free_inodes(sbinfo);
> >>-		return NULL;
> >>+		return -ENOMEM;
> >
> >The function is expecting "struct inode *", man.
> >
> >static struct inode *hugetlbfs_alloc_inode(struct super_block *sb)
> >
> Hmm, replace it by ERR_PTR(-ENOMEM). 
> 

Please listen to the feedback you're getting before you reply.

This function is called by alloc_inode().  It tests whether the return 
value is NULL or not, it doesn't check for PTR_ERR().  It's correct the 
way it's written and you would have broken it.

In the future, please demonstrate how you've tested your patches before 
proposing them.
