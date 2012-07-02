Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028Ab2GBOcV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 10:32:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44705 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752509Ab2GBOcT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 10:32:19 -0400
Date: Mon, 2 Jul 2012 15:32:15 +0100
From: Mel Gorman <mgorman@suse.de>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        xfs@oss.sgi.com
Subject: Re: [MMTests] IO metadata on XFS
Message-ID: <20120702143215.GS14154@suse.de>
References: <20120620113252.GE4011@suse.de>
 <20120629111932.GA14154@suse.de>
 <20120629112505.GF14154@suse.de>
 <20120701235458.GM19223@dastard>
 <20120702063226.GA32151@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20120702063226.GA32151@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 02, 2012 at 02:32:26AM -0400, Christoph Hellwig wrote:
> > It increases the CPU overhead (dirty_inode can be called up to 4
> > times per write(2) call, IIRC), so with limited numbers of
> > threads/limited CPU power it will result in lower performance. Where
> > you have lots of CPU power, there will be little difference in
> > performance...
> 
> When I checked it it could only be called twice, and we'd already
> optimize away the second call.  I'd defintively like to track down where
> the performance changes happend, at least to a major version but even
> better to a -rc or git commit.
> 

By all means feel free to run the test yourself and run the bisection :)

It's rare but on this occasion the test machine is idle so I started an
automated git bisection. As you know the milage with an automated bisect
varies so it may or may not find the right commit. Test machine is sandy so
http://www.csn.ul.ie/~mel/postings/mmtests-20120424/global-dhp__io-metadata-xfs/sandy/comparison.html
is the report of interest. The script is doing a full search between v3.3 and
v3.4 for a point where average files/sec for fsmark-single drops below 25000.
I did not limit the search to fs/xfs on the off-chance that it is an
apparently unrelated patch that caused the problem.

-- 
Mel Gorman
SUSE Labs
