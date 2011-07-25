Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517Ab1GYW4U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 18:56:20 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:32971 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014Ab1GYW4O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 18:56:14 -0400
MIME-Version: 1.0
In-Reply-To: <1311625159-13771-2-git-send-email-jweiner@redhat.com>
References: <1311625159-13771-1-git-send-email-jweiner@redhat.com>
	<1311625159-13771-2-git-send-email-jweiner@redhat.com>
Date: Tue, 26 Jul 2011 07:56:12 +0900
Message-ID: <CAEwNFnBB_WPv5mh65+Uis8OQdiq0p_j8UtuQsezDxRw4Ye3w8Q@mail.gmail.com>
Subject: Re: [patch 1/5] mm: page_alloc: increase __GFP_BITS_SHIFT to include __GFP_OTHER_NODE
From: Minchan Kim <minchan.kim@gmail.com>
To: Johannes Weiner <jweiner@redhat.com>
Cc: linux-mm@kvack.org, Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Wu Fengguang <fengguang.wu@intel.com>, Rik van Riel <riel@redhat.com>,
        Jan Kara <jack@suse.cz>, Andi Kleen <ak@linux.intel.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 26, 2011 at 5:19 AM, Johannes Weiner <jweiner@redhat.com> wrote:
> From: Johannes Weiner <hannes@cmpxchg.org>
>
> __GFP_OTHER_NODE is used for NUMA allocations on behalf of other
> nodes.  It's supposed to be passed through from the page allocator to
> zone_statistics(), but it never gets there as gfp_allowed_mask is not
> wide enough and masks out the flag early in the allocation path.
>
> The result is an accounting glitch where successful NUMA allocations
> by-agent are not properly attributed as local.
>
> Increase __GFP_BITS_SHIFT so that it includes __GFP_OTHER_NODE.
>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

Nice catch.

-- 
Kind regards,
Minchan Kim
