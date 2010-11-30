Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755923Ab0K3Lfx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 06:35:53 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:41163 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752144Ab0K3Lfw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 06:35:52 -0500
Date: Tue, 30 Nov 2010 12:35:40 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ben Gamari <bgamari.foss@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Nick Piggin <npiggin@kernel.dk>, Mel Gorman <mel@csn.ul.ie>,
        Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH v3 3/3] Prevent activation of page in madvise_dontneed
Message-ID: <20101130113540.GD15564@cmpxchg.org>
References: <cover.1291043273.git.minchan.kim@gmail.com>
 <a0f2905bb64ce33909d7dd74146bfea826fec21a.1291043274.git.minchan.kim@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a0f2905bb64ce33909d7dd74146bfea826fec21a.1291043274.git.minchan.kim@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 30, 2010 at 12:23:21AM +0900, Minchan Kim wrote:
> Now zap_pte_range alwayas activates pages which are pte_young &&
> !VM_SequentialReadHint(vma). But in case of calling MADV_DONTNEED,
> it's unnecessary since the page wouldn't use any more.
> 
> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
> Acked-by: Rik van Riel <riel@redhat.com>
> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Nick Piggin <npiggin@kernel.dk>
> Cc: Mel Gorman <mel@csn.ul.ie>
> Cc: Wu Fengguang <fengguang.wu@intel.com>
> 
> Changelog since v2:
>  - remove unnecessary description
> Changelog since v1: 
>  - change word from promote to activate
>  - add activate argument to zap_pte_range and family function
> 
> ---
>  include/linux/mm.h |    4 ++--
>  mm/madvise.c       |    4 ++--
>  mm/memory.c        |   38 +++++++++++++++++++++++---------------
>  mm/mmap.c          |    4 ++--
>  4 files changed, 29 insertions(+), 21 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index e097df6..6032881 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -779,11 +779,11 @@ struct page *vm_normal_page(struct vm_area_struct *vma, unsigned long addr,
>  int zap_vma_ptes(struct vm_area_struct *vma, unsigned long address,
>  		unsigned long size);
>  unsigned long zap_page_range(struct vm_area_struct *vma, unsigned long address,
> -		unsigned long size, struct zap_details *);
> +		unsigned long size, struct zap_details *, bool activate);

I would prefer naming the parameter 'ignore_references' or something
similar, so that it reflects the immediate effect on the zappers'
behaviour, not what mark_page_accessed() might end up doing.

Other than that, the patch looks good to me.

	Hannes
