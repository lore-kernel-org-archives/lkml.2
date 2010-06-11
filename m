Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757055Ab0FKQac (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 12:30:32 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50851 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755473Ab0FKQaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 12:30:30 -0400
Date: Fri, 11 Jun 2010 12:30:26 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
       Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
       Rik van Riel <riel@redhat.com>
Subject: Re: [RFC PATCH 0/6] Do not call ->writepage[s] from direct reclaim
 and use a_ops->writepages() where possible
Message-ID: <20100611163026.GD24707@infradead.org>
References: <1275987745-21708-1-git-send-email-mel@csn.ul.ie>
 <20100610225749.c8cc3bc3.akpm@linux-foundation.org>
 <20100611123320.GA8798@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100611123320.GA8798@csn.ul.ie>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 11, 2010 at 01:33:20PM +0100, Mel Gorman wrote:
> Ok, I was under the mistaken impression that filesystems wanted to be
> given ranges of pages where possible. Considering that there has been no
> reaction to the patch in question from the filesystem people cc'd, I'll
> drop the problem for now.

Yes, we'd prefer them if possible.  Then again we'd really prefer to
get as much I/O as possible from the flusher threads, and not kswapd.

