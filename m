Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754431Ab0FHJIQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 05:08:16 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46466 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754006Ab0FHJIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 05:08:14 -0400
Date: Tue, 8 Jun 2010 05:08:11 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mm@kvack.org, Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
       Rik van Riel <riel@redhat.com>
Subject: Re: [RFC PATCH 0/6] Do not call ->writepage[s] from direct reclaim
 and use a_ops->writepages() where possible
Message-ID: <20100608090811.GA5949@infradead.org>
References: <1275987745-21708-1-git-send-email-mel@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1275987745-21708-1-git-send-email-mel@csn.ul.ie>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 08, 2010 at 10:02:19AM +0100, Mel Gorman wrote:
> seeky patterns.  The second is that direct reclaim calling the filesystem
> splices two potentially deep call paths together and potentially overflows
> the stack on complex storage or filesystems. This series is an early draft
> at tackling both of these problems and is in three stages.

Btw, one more thing came up when I discussed the issue again with Dave
recently:

 - we also need to care about ->releasepage.  At least for XFS it
   can end up in the same deep allocator chain as ->writepage because
   it does all the extent state conversions, even if it doesn't
   start I/O.  I haven't managed yet to decode the ext4/btrfs codepaths
   for ->releasepage yet to figure out how they release a page that
   covers a delayed allocated or unwritten range.

