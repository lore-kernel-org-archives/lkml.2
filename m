Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752928Ab2GBGca (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 02:32:30 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:37306
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751057Ab2GBGc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 02:32:29 -0400
Date: Mon, 2 Jul 2012 02:32:26 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        xfs@oss.sgi.com
Subject: Re: [MMTests] IO metadata on XFS
Message-ID: <20120702063226.GA32151@infradead.org>
References: <20120620113252.GE4011@suse.de>
 <20120629111932.GA14154@suse.de>
 <20120629112505.GF14154@suse.de>
 <20120701235458.GM19223@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120701235458.GM19223@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 02, 2012 at 09:54:58AM +1000, Dave Chinner wrote:
> That will be caused by the fact we changed all the metadata updates
> to be logged, which means a transaction every time .dirty_inode is
> called.
> 
> This should mostly go away when XFS is converted to use .update_time
> rather than .dirty_inode to only issue transactions when the VFS
> updates the atime rather than every .dirty_inode call...

I think the patch to do that conversion still needs review..

> It increases the CPU overhead (dirty_inode can be called up to 4
> times per write(2) call, IIRC), so with limited numbers of
> threads/limited CPU power it will result in lower performance. Where
> you have lots of CPU power, there will be little difference in
> performance...

When I checked it it could only be called twice, and we'd already
optimize away the second call.  I'd defintively like to track down where
the performance changes happend, at least to a major version but even
better to a -rc or git commit.

