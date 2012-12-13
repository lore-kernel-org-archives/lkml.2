Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756Ab2LMLVE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 06:21:04 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50487 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753337Ab2LMLVC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 06:21:02 -0500
Date: Thu, 13 Dec 2012 11:20:58 +0000
From: Mel Gorman <mgorman@suse.de>
To: Laura Abbott <lauraa@codeaurora.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v3] mm: Use aligned zone start for pfn_to_bitidx
 calculation
Message-ID: <20121213112058.GA9887@suse.de>
References: <1354828301-27849-1-git-send-email-lauraa@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1354828301-27849-1-git-send-email-lauraa@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 06, 2012 at 01:11:41PM -0800, Laura Abbott wrote:
> The current calculation in pfn_to_bitidx assumes that
> (pfn - zone->zone_start_pfn) >> pageblock_order will return the
> same bit for all pfn in a pageblock. If zone_start_pfn is not
> aligned to pageblock_nr_pages, this may not always be correct.
> 
> Consider the following with pageblock order = 10, zone start 2MB:
> 
> pfn     | pfn - zone start | (pfn - zone start) >> page block order
> ----------------------------------------------------------------
> 0x26000 | 0x25e00	   |  0x97
> 0x26100 | 0x25f00	   |  0x97
> 0x26200 | 0x26000	   |  0x98
> 0x26300 | 0x26100	   |  0x98
> 
> This means that calling {get,set}_pageblock_migratetype on a single
> page will not set the migratetype for the full block. Fix this by
> rounding down zone_start_pfn when doing the bitidx calculation.
> 
> Signed-off-by: Laura Abbott <lauraa@codeaurora.org>

Acked-by: Mel Gorman <mgorman@suse.de>

It's merge window at the moment so it's in danger of getting lost. What
I suggest you do is do is resend to Andrew with the same people cc'd
post-merge window so it'll be picked up in mmotm for the next cycle.

Thanks.

-- 
Mel Gorman
SUSE Labs
