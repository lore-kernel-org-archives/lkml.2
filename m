Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752033Ab1GSEoM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 00:44:12 -0400
Received: from gate.crashing.org ([63.228.1.57]:33897 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751091Ab1GSEoL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 00:44:11 -0400
Subject: Re: [PATCH 1/5] fs/hugetlbfs/inode.c: Fix pgoff alignment checking
 on 32-bit
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        david@gibson.dropbear.id.au, galak@kernel.crashing.org,
        Becky Bruce <beckyb@kernel.crashing.org>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <13092909493748-git-send-email-beckyb@kernel.crashing.org>
References: <1309290888309-git-send-email-beckyb@kernel.crashing.org>
	 <13092909493748-git-send-email-beckyb@kernel.crashing.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Jul 2011 14:43:49 +1000
Message-ID: <1311050629.25044.394.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew, Anybody ? Can I have an -mm ack for this ?

Cheers,
Ben.

On Tue, 2011-06-28 at 14:54 -0500, Becky Bruce wrote:
> From: Becky Bruce <beckyb@kernel.crashing.org>
> 
> This:
> 
> vma->vm_pgoff & ~(huge_page_mask(h) >> PAGE_SHIFT)
> 
> is incorrect on 32-bit.  It causes us to & the pgoff with
> something that looks like this (for a 4m hugepage): 0xfff003ff.
> The mask should be flipped and *then* shifted, to give you
> 0x0000_03fff.
> 
> Signed-off-by: Becky Bruce <beckyb@kernel.crashing.org>
> ---
>  fs/hugetlbfs/inode.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
> index 7aafeb8..537a209 100644
> --- a/fs/hugetlbfs/inode.c
> +++ b/fs/hugetlbfs/inode.c
> @@ -94,7 +94,7 @@ static int hugetlbfs_file_mmap(struct file *file, struct vm_area_struct *vma)
>  	vma->vm_flags |= VM_HUGETLB | VM_RESERVED;
>  	vma->vm_ops = &hugetlb_vm_ops;
>  
> -	if (vma->vm_pgoff & ~(huge_page_mask(h) >> PAGE_SHIFT))
> +	if (vma->vm_pgoff & (~huge_page_mask(h) >> PAGE_SHIFT))
>  		return -EINVAL;
>  
>  	vma_len = (loff_t)(vma->vm_end - vma->vm_start);


