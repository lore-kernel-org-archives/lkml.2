Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932359Ab2HHHzd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 03:55:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46285 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932213Ab2HHHzb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 03:55:31 -0400
Date: Wed, 8 Aug 2012 08:55:26 +0100
From: Mel Gorman <mgorman@suse.de>
To: Minchan Kim <minchan@kernel.org>
Cc: Linux-MM <linux-mm@kvack.org>, Rik van Riel <riel@redhat.com>,
        Jim Schutt <jaschut@sandia.gov>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/6] mm: vmscan: Scale number of pages reclaimed by
 reclaim/compaction based on failures
Message-ID: <20120808075526.GI29814@suse.de>
References: <1344342677-5845-1-git-send-email-mgorman@suse.de>
 <1344342677-5845-3-git-send-email-mgorman@suse.de>
 <20120808014824.GB4247@bbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20120808014824.GB4247@bbox>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 08, 2012 at 10:48:24AM +0900, Minchan Kim wrote:
> Hi Mel,
> 
> Just out of curiosity.
> What's the problem did you see? (ie, What's the problem do this patch solve?)

Everythign in this series is related to the problem in the leader - high
order allocation success rates are lower. This patch increases the success
rates when allocating under load.

> AFAIUC, it seem to solve consecutive allocation success ratio through
> getting several free pageblocks all at once in a process/kswapd
> reclaim context. Right?

Only pageblocks if it is order-9 on x86, it reclaims an amount that depends
on an allocation size. This only happens during reclaim/compaction context
when we know that a high-order allocation has recently failed. The objective
is to reclaim enough order-0 pages so that compaction can succeed again.

-- 
Mel Gorman
SUSE Labs
