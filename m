Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932173Ab2I1Qef (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 12:34:35 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:58416 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758578Ab2I1Qee (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 12:34:34 -0400
Date: Fri, 28 Sep 2012 12:34:25 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Li Haifeng <omycle@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>,
        Minchan Kim <minchan.kim@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mm: Fixup abandoned PG_buddy for private in struct
 page
Message-ID: <20120928163425.GA29854@cmpxchg.org>
References: <CAFNq8R65BCuTn2BDAQ=5twA0epaeR9tdJ2HTRb1tEWM15j0hQA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFNq8R65BCuTn2BDAQ=5twA0epaeR9tdJ2HTRb1tEWM15j0hQA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 06, 2012 at 05:11:18PM +0800, Li Haifeng wrote:
> PG_buddy, an abandoned flag, indicates page(s) is/are free
> and in buddy allocator. And when page(s) in buddy allocator,
> the _mapcount will equal PAGE_BUDDY_MAPCOUNT_VALUE. So,
> here, "_mapcount equals PAGE_BUDDY_MAPCOUNT_VALUE" instead
> of "PG_buddy is set".
> 
> Signed-off-by: Haifeng Li <omycle@gmail.com>
> ---
>  include/linux/mm_types.h |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index 704a626..49d9247 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -126,7 +126,8 @@ struct page {
>                                                  * if PagePrivate set; used for
>                                                  * swp_entry_t if PageSwapCache;
>                                                  * indicates order in the buddy
> -                                                * system if PG_buddy is set.
> +                                                * system if _mapcount equals
> +                                                * PAGE_BUDDY_MAPCOUNT_VALUE.

How about simply "if PageBuddy", just like the previous sentence about
swap cache does?  No reason to expose the implementation of PageBuddy
at this point, I guess...
