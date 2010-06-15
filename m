Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757735Ab0FOQfv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 12:35:51 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59697 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753975Ab0FOQft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 12:35:49 -0400
Date: Tue, 15 Jun 2010 12:35:46 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
       Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
       Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
       Rik van Riel <riel@redhat.com>
Subject: Re: [RFC PATCH 0/6] Do not call ->writepage[s] from direct reclaim
 and use a_ops->writepages() where possible
Message-ID: <20100615163546.GA21250@infradead.org>
References: <1275987745-21708-1-git-send-email-mel@csn.ul.ie>
 <20100615140011.GD28052@random.random>
 <20100615141122.GA27893@infradead.org>
 <20100615142219.GE28052@random.random>
 <20100615144342.GA3339@infradead.org>
 <20100615150850.GF28052@random.random>
 <20100615153838.GO26788@csn.ul.ie>
 <20100615161419.GH28052@random.random>
 <20100615163044.GR26788@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100615163044.GR26788@csn.ul.ie>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 15, 2010 at 05:30:44PM +0100, Mel Gorman wrote:
> After grepping through fs/, it was only xfs and btrfs that I saw were
> specfically disabling writepage from reclaim context.

ext4 doesn't specificly disable writeback from reclaim context, but
in a rather convoluted way disabled basically all writeback through
->writepage.  The only thing allowed is overwrites of already allocated
blocks.

In addition to that reiserfs also frefuses to write back pages
from reclaim context if they require a transaction, which is the case
if the file was written to through mmap.
