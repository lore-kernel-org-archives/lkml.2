Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751508Ab1HKSTY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 14:19:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60277 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751041Ab1HKSTX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 14:19:23 -0400
Message-ID: <4E441D0E.6020602@redhat.com>
Date: Thu, 11 Aug 2011 14:18:54 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.1
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        XFS <xfs@oss.sgi.com>, Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Johannes Weiner <jweiner@redhat.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH 5/7] mm: vmscan: Do not writeback filesystem pages in
 kswapd except in high priority
References: <1312973240-32576-1-git-send-email-mgorman@suse.de> <1312973240-32576-6-git-send-email-mgorman@suse.de>
In-Reply-To: <1312973240-32576-6-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/10/2011 06:47 AM, Mel Gorman wrote:
> It is preferable that no dirty pages are dispatched for cleaning from
> the page reclaim path. At normal priorities, this patch prevents kswapd
> writing pages.
>
> However, page reclaim does have a requirement that pages be freed
> in a particular zone. If it is failing to make sufficient progress
> (reclaiming<  SWAP_CLUSTER_MAX at any priority priority), the priority
> is raised to scan more pages. A priority of DEF_PRIORITY - 3 is
> considered to be the point where kswapd is getting into trouble
> reclaiming pages. If this priority is reached, kswapd will dispatch
> pages for writing.
>
> Signed-off-by: Mel Gorman<mgorman@suse.de>
> Reviewed-by: Minchan Kim<minchan.kim@gmail.com>

My only worry with this patch is that maybe we'll burn too
much CPU time freeing pages from a zone.  However, chances
are we'll have freed pages from other zones when scanning
one zone multiple times (the page cache dirty limit is global,
the clean pages have to be _somewhere_).

Since the bulk of the allocators are not too picky about
which zone they get their pages from, I suspect this patch
will be an overall improvement pretty much all the time.

Acked-by: Rik van Riel <riel@redhat.com>
