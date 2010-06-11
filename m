Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573Ab0FKQZd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 12:25:33 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48545 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144Ab0FKQZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 12:25:31 -0400
Date: Fri, 11 Jun 2010 12:25:23 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
       Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
       Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 6/6] vmscan: Do not writeback pages in direct reclaim
Message-ID: <20100611162523.GA24707@infradead.org>
References: <1275987745-21708-1-git-send-email-mel@csn.ul.ie>
 <1275987745-21708-7-git-send-email-mel@csn.ul.ie>
 <20100610231706.1d7528f2.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100610231706.1d7528f2.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 10, 2010 at 11:17:06PM -0700, Andrew Morton wrote:
> As it stands, it would be wildly incautious to make a change like
> this without first working out why we're pulling so many dirty pages
> off the LRU tail, and fixing that.

Note that unlike the writepage vs writepages from kswapd which can
be fixed by the right tuning this is a black or white issue.  Writeback
from direct reclaim will kill your stack if the caller happens to be
the wrong one, and just making it happen less often is not a fix - it
must not happen at all.

