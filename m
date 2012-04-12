Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933382Ab2DLRvc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 13:51:32 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:59909 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932136Ab2DLRvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 13:51:31 -0400
Date: Thu, 12 Apr 2012 10:51:10 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Will Deacon <will.deacon@arm.com>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Nicolas Pitre <nico@linaro.org>
Subject: Re: [PATCH] Revert "proc: clear_refs: do not clear reserved pages"
In-Reply-To: <1334250034-29866-1-git-send-email-will.deacon@arm.com>
Message-ID: <alpine.LSU.2.00.1204121049120.2288@eggly.anvils>
References: <1334250034-29866-1-git-send-email-will.deacon@arm.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Apr 2012, Will Deacon wrote:

> This reverts commit 85e72aa5384b1a614563ad63257ded0e91d1a620, which was
> a quick fix suitable for -stable until ARM had been moved over to the
> gate_vma mechanism:
> 
> https://lkml.org/lkml/2012/1/14/55
> 
> With commit f9d4861f ("ARM: 7294/1: vectors: use gate_vma for vectors user
> mapping"), ARM does now use the gate_vma, so the PageReserved check can
> be removed from the proc code.
> 
> Cc: Nicolas Pitre <nico@linaro.org>
> Signed-off-by: Will Deacon <will.deacon@arm.com>

Oh, great, I'm glad that worked out: thanks a lot for looking after it,
Will, and now cleaning up afterwards.

Acked-by: Hugh Dickins <hughd@google.com>

> ---
>  fs/proc/task_mmu.c |    3 ---
>  1 files changed, 0 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index 2b9a760..2d60492 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -597,9 +597,6 @@ static int clear_refs_pte_range(pmd_t *pmd, unsigned long addr,
>  		if (!page)
>  			continue;
>  
> -		if (PageReserved(page))
> -			continue;
> -
>  		/* Clear accessed and referenced bits. */
>  		ptep_test_and_clear_young(vma, addr, pte);
>  		ClearPageReferenced(page);
> -- 
> 1.7.4.1
> 
> 
