Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277Ab0G1LIc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 07:08:32 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47247 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795Ab0G1LIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 07:08:30 -0400
Date: Wed, 28 Jul 2010 07:08:07 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        Dave Chinner <david@fromorbit.com>,
        Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Christoph Hellwig <hch@infradead.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH 9/9] writeback: Prioritise dirty inodes encountered by
 reclaim for background flushing
Message-ID: <20100728110807.GB31360@infradead.org>
References: <1280312843-11789-1-git-send-email-mel@csn.ul.ie>
 <1280312843-11789-10-git-send-email-mel@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280312843-11789-10-git-send-email-mel@csn.ul.ie>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 28, 2010 at 11:27:23AM +0100, Mel Gorman wrote:
> It is preferable that as few dirty pages are dispatched for cleaning from
> the page reclaim path. When dirty pages are encountered by page reclaim,
> this patch marks the inodes that they should be dispatched immediately. When
> the background flusher runs, it moves such inodes immediately to the dispatch
> queue regardless of inode age.

Thus whole thing looks rather hacky to me.  Does it really give a large
enough benefit to be worth all the hacks?

