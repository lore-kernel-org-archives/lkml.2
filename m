Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755053Ab0H3J4k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 05:56:40 -0400
Received: from gir.skynet.ie ([193.1.99.77]:55900 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754900Ab0H3J4i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 05:56:38 -0400
Date: Mon, 30 Aug 2010 10:56:23 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel List <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Wu Fengguang <fengguang.wu@intel.com>, Hugh Dickins <hughd@google.com>,
        Andi Kleen <andi@firstfloor.org>, Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH v2 2/2] compaction: fix COMPACTPAGEFAILED counting
Message-ID: <20100830095623.GH19556@csn.ul.ie>
References: <1282664620-4539-1-git-send-email-minchan.kim@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1282664620-4539-1-git-send-email-minchan.kim@gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 25, 2010 at 12:43:40AM +0900, Minchan Kim wrote:
> Now update_nr_listpages doesn't have a role. That's because
> lists passed is always empty just after calling migrate_pages.
> The migrate_pages cleans up page list which have failed to migrate
> before returning by aaa994b3.
> 
>  [PATCH] page migration: handle freeing of pages in migrate_pages()
> 
>  Do not leave pages on the lists passed to migrate_pages().  Seems that we will
>  not need any postprocessing of pages.  This will simplify the handling of
>  pages by the callers of migrate_pages().
> 
> At that time, we thought we don't need any postprocessing of pages.
> But the situation is changed. The compaction need to know the number of
> failed to migrate for COMPACTPAGEFAILED stat
> 
> This patch makes new rule for caller of migrate_pages to call putback_lru_pages.
> So caller need to clean up the lists so it has a chance to postprocess the pages.
> [suggested by Christoph Lameter]
> 
> Cc: Hugh Dickins <hughd@google.com>
> Cc: Andi Kleen <andi@firstfloor.org>
> Cc: Christoph Lameter <cl@linux.com>
> Cc: Mel Gorman <mel@csn.ul.ie>
> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>

Looks good and it passed basic testing.

Reviewed-by: Mel Gorman <mel@csn.ul.ie>

Thanks

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
