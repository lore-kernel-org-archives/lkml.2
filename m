Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934572Ab0GSOUz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 10:20:55 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57699 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933836Ab0GSOUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 10:20:53 -0400
Date: Mon, 19 Jul 2010 10:20:51 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, Dave Chinner <david@fromorbit.com>,
        Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Christoph Hellwig <hch@infradead.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH 6/8] fs,xfs: Allow kswapd to writeback pages
Message-ID: <20100719142051.GC12510@infradead.org>
References: <1279545090-19169-1-git-send-email-mel@csn.ul.ie>
 <1279545090-19169-7-git-send-email-mel@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1279545090-19169-7-git-send-email-mel@csn.ul.ie>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 19, 2010 at 02:11:28PM +0100, Mel Gorman wrote:
> As only kswapd and memcg are writing back pages, there should be no
> danger of overflowing the stack. Allow the writing back of dirty pages
> in xfs from the VM.

As pointed out during the discussion on one of your previous post memcg
does pose a huge risk of stack overflows.  In the XFS tree we've already
relaxed the check to allow writeback from kswapd, and until the memcg
situation we'll need to keep that check.

