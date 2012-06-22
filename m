Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761974Ab2FVJ7J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 05:59:09 -0400
Received: from merlin.infradead.org ([205.233.59.134]:35965 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761953Ab2FVJ7H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 05:59:07 -0400
Message-ID: <1340359115.18025.57.camel@twins>
Subject: Re: [PATCH -mm v2 01/11] mm: track free size between VMAs in VMA
 rbtree
From: Peter Zijlstra <peterz@infradead.org>
To: Rik van Riel <riel@surriel.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, aarcange@redhat.com,
        minchan@gmail.com, kosaki.motohiro@gmail.com, andi@firstfloor.org,
        hannes@cmpxchg.org, mel@csn.ul.ie, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>
Date: Fri, 22 Jun 2012 11:58:35 +0200
In-Reply-To: <1340315835-28571-2-git-send-email-riel@surriel.com>
References: <1340315835-28571-1-git-send-email-riel@surriel.com>
	 <1340315835-28571-2-git-send-email-riel@surriel.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-06-21 at 17:57 -0400, Rik van Riel wrote:
> @@ -1941,6 +2017,8 @@ detach_vmas_to_be_unmapped(struct mm_struct *mm, struct vm_area_struct *vma,
>         *insertion_point = vma;
>         if (vma)
>                 vma->vm_prev = prev;
> +       if (vma)
> +               rb_augment_erase_end(&vma->vm_rb, vma_rb_augment_cb, NULL); 

Shouldn't that be adjust_free_gap()? There is after all no actual erase
happening.
