Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751850Ab1GaPSJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 11:18:09 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:56355 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772Ab1GaPR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 11:17:59 -0400
Date: Mon, 1 Aug 2011 00:17:49 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        XFS <xfs@oss.sgi.com>, Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Johannes Weiner <jweiner@redhat.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 6/8] mm: vmscan: Throttle reclaim if encountering too
 many dirty pages under writeback
Message-ID: <20110731151749.GD1735@barrios-desktop>
References: <1311265730-5324-1-git-send-email-mgorman@suse.de>
 <1311265730-5324-7-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311265730-5324-7-git-send-email-mgorman@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 21, 2011 at 05:28:48PM +0100, Mel Gorman wrote:
> Workloads that are allocating frequently and writing files place a
> large number of dirty pages on the LRU. With use-once logic, it is
> possible for them to reach the end of the LRU quickly requiring the
> reclaimer to scan more to find clean pages. Ordinarily, processes that
> are dirtying memory will get throttled by dirty balancing but this
> is a global heuristic and does not take into account that LRUs are
> maintained on a per-zone basis. This can lead to a situation whereby
> reclaim is scanning heavily, skipping over a large number of pages
> under writeback and recycling them around the LRU consuming CPU.
> 
> This patch checks how many of the number of pages isolated from the
> LRU were dirty. If a percentage of them are dirty, the process will be
> throttled if a blocking device is congested or the zone being scanned
> is marked congested. The percentage that must be dirty depends on
> the priority. At default priority, all of them must be dirty. At
> DEF_PRIORITY-1, 50% of them must be dirty, DEF_PRIORITY-2, 25%
> etc. i.e.  as pressure increases the greater the likelihood the process
> will get throttled to allow the flusher threads to make some progress.
> 
> Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

-- 
Kind regards,
Minchan Kim
