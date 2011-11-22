Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684Ab1KVRvD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 12:51:03 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:53386 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472Ab1KVRvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 12:51:01 -0500
Date: Wed, 23 Nov 2011 02:50:55 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Linux-MM <linux-mm@kvack.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Jan Kara <jack@suse.cz>, Andy Isaacson <adi@hexapodia.org>,
        Johannes Weiner <jweiner@redhat.com>, Rik van Riel <riel@redhat.com>,
        Nai Xia <nai.xia@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/7] mm: page allocator: Limit when direct reclaim is
 used when compaction is deferred
Message-ID: <20111122175055.GE15253@barrios-laptop.redhat.com>
References: <1321900608-27687-1-git-send-email-mgorman@suse.de>
 <1321900608-27687-7-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1321900608-27687-7-git-send-email-mgorman@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 21, 2011 at 06:36:47PM +0000, Mel Gorman wrote:
> If compaction is deferred, we enter direct reclaim to try reclaim the
> pages that way. For small high-orders, this has a reasonable chance
> of success. However, if the caller as specified __GFP_NO_KSWAPD to
> limit the disruption to the system, it makes more sense to fail the
> allocation rather than stall the caller in direct reclaim. This patch
> will skip direct reclaim if compaction is deferred and the caller
> specifies __GFP_NO_KSWAPD.
> 
> Async compaction only considers a subset of pages so it is possible for
> compaction to be deferred prematurely and not enter direct reclaim even
> in cases where it should. To compensate for this, this patch also defers
> compaction only if sync compaction failed.
> 
> Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: Minchan Kim <minchan.kim@gmail.com>

It does make sense to me. 

-- 
Kind regards,
Minchan Kim
