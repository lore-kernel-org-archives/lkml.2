Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724Ab0F2Mhb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 08:37:31 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42090 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754591Ab0F2Mh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 08:37:29 -0400
Date: Tue, 29 Jun 2010 08:37:22 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mm@kvack.org, Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
       Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
       Christoph Hellwig <hch@infradead.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH 14/14] fs,xfs: Allow kswapd to writeback pages
Message-ID: <20100629123722.GA725@infradead.org>
References: <1277811288-5195-1-git-send-email-mel@csn.ul.ie>
 <1277811288-5195-15-git-send-email-mel@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277811288-5195-15-git-send-email-mel@csn.ul.ie>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't see a patch in this set which refuses writeback from the memcg
context, which we identified as having large stack footprint in hte
discussion of the last patch set.

Meanwhile I've submitted a patch to xfs to allow reclaim from kswapd,
and just prevent it from direct and memcg reclaim.

Btw, it might be worth to also allow kswap to all writeout on ext4,
but doing that will be a bit more complicated than the btrfs and xfs
variants as the code is rather convoluted.

