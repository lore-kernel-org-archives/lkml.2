Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005Ab1HCLhj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 07:37:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57404 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753971Ab1HCLhe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 07:37:34 -0400
Date: Wed, 3 Aug 2011 13:37:06 +0200
From: Johannes Weiner <jweiner@redhat.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        XFS <xfs@oss.sgi.com>, Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH 8/8] mm: vmscan: Do not writeback filesystem pages from
 kswapd
Message-ID: <20110803113706.GF27199@redhat.com>
References: <1311265730-5324-1-git-send-email-mgorman@suse.de>
 <1311265730-5324-9-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311265730-5324-9-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 21, 2011 at 05:28:50PM +0100, Mel Gorman wrote:
> Assuming that flusher threads will always write back dirty pages promptly
> then it is always faster for reclaimers to wait for flushers. This patch
> prevents kswapd writing back any filesystem pages.
> 
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Relying on the flushers may mean that every dirty page in the system
has to be written back before the pages from the zone of interest are
clean.

De-facto we have only one mechanism to stay on top of the dirty pages
from a per-zone perspective, and that is single-page writeout from
reclaim.

While we all agree that this sucks, we can not remove it unless we
have a replacement that makes zones reclaimable in a reasonable time
frame (or keep them reclaimable in the first place, what per-zone
dirty limits attempt to do).

As such, please include

Nacked-by: Johannes Weiner <jweiner@redhat.com>
