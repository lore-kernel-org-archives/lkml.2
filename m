Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751964Ab1HKP6J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 11:58:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34153 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751116Ab1HKP6G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 11:58:06 -0400
Message-ID: <4E43FBF0.1010607@redhat.com>
Date: Thu, 11 Aug 2011 11:57:36 -0400
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
Subject: Re: [PATCH 1/7] mm: vmscan: Do not writeback filesystem pages in
 direct reclaim
References: <1312973240-32576-1-git-send-email-mgorman@suse.de> <1312973240-32576-2-git-send-email-mgorman@suse.de>
In-Reply-To: <1312973240-32576-2-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/10/2011 06:47 AM, Mel Gorman wrote:
> From: Mel Gorman<mel@csn.ul.ie>
>
> When kswapd is failing to keep zones above the min watermark, a process
> will enter direct reclaim in the same manner kswapd does. If a dirty
> page is encountered during the scan, this page is written to backing
> storage using mapping->writepage.
>
> This causes two problems. First, it can result in very deep call
> stacks, particularly if the target storage or filesystem are complex.
> Some filesystems ignore write requests from direct reclaim as a result.
> The second is that a single-page flush is inefficient in terms of IO.
> While there is an expectation that the elevator will merge requests,
> this does not always happen. Quoting Christoph Hellwig;
>
> 	The elevator has a relatively small window it can operate on,
> 	and can never fix up a bad large scale writeback pattern.
>
> This patch prevents direct reclaim writing back filesystem pages by
> checking if current is kswapd. Anonymous pages are still written to
> swap as there is not the equivalent of a flusher thread for anonymous
> pages. If the dirty pages cannot be written back, they are placed
> back on the LRU lists. There is now a direct dependency on dirty page
> balancing to prevent too many pages in the system being dirtied which
> would prevent reclaim making forward progress.
>
> Signed-off-by: Mel Gorman<mgorman@suse.de>
> Reviewed-by: Minchan Kim<minchan.kim@gmail.com>

Reviewed-by: Rik van Riel <riel@redhat.com>
