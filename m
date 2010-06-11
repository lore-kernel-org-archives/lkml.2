Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758788Ab0FKRoz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 13:44:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47379 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756771Ab0FKRox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 13:44:53 -0400
Date: Fri, 11 Jun 2010 10:43:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
       Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
       Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 6/6] vmscan: Do not writeback pages in direct reclaim
Message-Id: <20100611104331.d8463580.akpm@linux-foundation.org>
In-Reply-To: <20100611162523.GA24707@infradead.org>
References: <1275987745-21708-1-git-send-email-mel@csn.ul.ie>
	<1275987745-21708-7-git-send-email-mel@csn.ul.ie>
	<20100610231706.1d7528f2.akpm@linux-foundation.org>
	<20100611162523.GA24707@infradead.org>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jun 2010 12:25:23 -0400 Christoph Hellwig <hch@infradead.org> wrote:

> On Thu, Jun 10, 2010 at 11:17:06PM -0700, Andrew Morton wrote:
> > As it stands, it would be wildly incautious to make a change like
> > this without first working out why we're pulling so many dirty pages
> > off the LRU tail, and fixing that.
> 
> Note that unlike the writepage vs writepages from kswapd which can
> be fixed by the right tuning this is a black or white issue.  Writeback
> from direct reclaim will kill your stack if the caller happens to be
> the wrong one, and just making it happen less often is not a fix - it
> must not happen at all.

Of course, but making a change like that in the current VM will cause a
large number of dirty pages to get refiled, so the impact of this
change on some workloads could be quite bad.

If, however, we can get things back to the state where few dirty pages
ever reach the tail of the LRU then the adverse impact of this change
will be much less.

