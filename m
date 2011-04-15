Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756190Ab1DOOj3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 10:39:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62876 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756162Ab1DOOj2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 10:39:28 -0400
Date: Fri, 15 Apr 2011 16:39:16 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Mel Gorman <mgorman@suse.de>
Cc: akpm@linux-foundation.org, raz ben yehuda <raziebe@gmail.com>,
        riel@redhat.com, kosaki.motohiro@jp.fujitsu.com,
        lkml <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        stable@kernel.org
Subject: Re: [PATCH] mm: Check if PTE is already allocated during page fault
Message-ID: <20110415143916.GN15707@random.random>
References: <20110415101248.GB22688@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110415101248.GB22688@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 15, 2011 at 11:12:48AM +0100, Mel Gorman wrote:
> diff --git a/mm/memory.c b/mm/memory.c
> index 5823698..1659574 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -3322,7 +3322,7 @@ int handle_mm_fault(struct mm_struct *mm, struct vm_area_struct *vma,
>  	 * run pte_offset_map on the pmd, if an huge pmd could
>  	 * materialize from under us from a different thread.
>  	 */
> -	if (unlikely(__pte_alloc(mm, vma, pmd, address)))
> +	if (unlikely(pmd_none(*pmd)) && __pte_alloc(mm, vma, pmd, address))
>  		return VM_FAULT_OOM;
>  	/* if an huge pmd materialized from under us just retry later */
>  	if (unlikely(pmd_trans_huge(*pmd)))

Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>

