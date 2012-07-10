Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284Ab2GJBPZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 21:15:25 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60954 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365Ab2GJBPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 21:15:24 -0400
Date: Tue, 10 Jul 2012 09:15:16 +0800
From: Wanpeng Li <liwp.linux@gmail.com>
To: Gavin Shan <shangw@linux.vnet.ibm.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        William Irwin <wli@holomorphy.com>, linux-kernel@vger.kernel.org,
        Wanpeng Li <liwp.linux@gmail.com>
Subject: Re: [PATCH] mm/hugetlb: fix error code in hugetlbfs_alloc_inode
Message-ID: <20120710011516.GA2457@kernel>
Reply-To: Wanpeng Li <liwp.linux@gmail.com>
References: <1341882184-4549-1-git-send-email-liwp.linux@gmail.com>
 <20120710010910.GA7362@shangw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120710010910.GA7362@shangw>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 10, 2012 at 09:09:10AM +0800, Gavin Shan wrote:
>On Tue, Jul 10, 2012 at 09:03:04AM +0800, Wanpeng Li wrote:
>>From: Wanpeng Li <liwp@linux.vnet.ibm.com>
>>
>>When kmem_cache_alloc fails alloc slab object from
>>hugetlbfs_inode_cachep, return -ENOMEM in usual. But
>>hugetlbfs_alloc_inode implementation has inconsitency
>>with it and returns NULL. Fix it to return -ENOMEM.
>>
>>Signed-off-by: Wanpeng Li <liwp.linux@gmail.com>
>>---
>> fs/hugetlbfs/inode.c |    2 +-
>> 1 files changed, 1 insertions(+), 1 deletions(-)
>>
>>diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
>>index c4b85d0..79a0f33 100644
>>--- a/fs/hugetlbfs/inode.c
>>+++ b/fs/hugetlbfs/inode.c
>>@@ -696,7 +696,7 @@ static struct inode *hugetlbfs_alloc_inode(struct super_block *sb)
>> 	p = kmem_cache_alloc(hugetlbfs_inode_cachep, GFP_KERNEL);
>> 	if (unlikely(!p)) {
>> 		hugetlbfs_inc_free_inodes(sbinfo);
>>-		return NULL;
>>+		return -ENOMEM;
>
>The function is expecting "struct inode *", man.
>
>static struct inode *hugetlbfs_alloc_inode(struct super_block *sb)
>
Hmm, replace it by ERR_PTR(-ENOMEM). 

Regards,
Wanpeng Li

>Thanks,
>Gavin
>
>> 	}
>> 	return &p->vfs_inode;
>> }
>>-- 
>>1.7.5.4
>>
>>--
>>To unsubscribe, send a message with 'unsubscribe linux-mm' in
>>the body to majordomo@kvack.org.  For more info on Linux MM,
>>see: http://www.linux-mm.org/ .
>>Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>>
