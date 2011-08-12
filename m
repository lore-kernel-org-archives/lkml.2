Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752188Ab1HLP1x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 11:27:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45879 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751066Ab1HLP1v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 11:27:51 -0400
Message-ID: <4E454656.9010608@redhat.com>
Date: Fri, 12 Aug 2011 11:27:18 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        XFS <xfs@oss.sgi.com>, Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Johannes Weiner <jweiner@redhat.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH 7/7] mm: vmscan: Immediately reclaim end-of-LRU dirty
 pages when writeback completes
References: <1312973240-32576-1-git-send-email-mgorman@suse.de> <1312973240-32576-8-git-send-email-mgorman@suse.de>
In-Reply-To: <1312973240-32576-8-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/10/2011 06:47 AM, Mel Gorman wrote:
> When direct reclaim encounters a dirty page, it gets recycled around
> the LRU for another cycle. This patch marks the page PageReclaim
> similar to deactivate_page() so that the page gets reclaimed almost
> immediately after the page gets cleaned. This is to avoid reclaiming
> clean pages that are younger than a dirty page encountered at the
> end of the LRU that might have been something like a use-once page.
>
> Signed-off-by: Mel Gorman<mgorman@suse.de>
> Acked-by: Johannes Weiner<jweiner@redhat.com>

I'm thinking we may need to add some code to
ClearPageReclaim to mark_page_accessed, but
that would be completely independent of these
patches, so ...

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
