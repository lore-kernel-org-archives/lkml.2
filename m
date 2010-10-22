Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753655Ab0JVBFd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 21:05:33 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:64931 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751884Ab0JVBFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 21:05:31 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhYEAKN/wEx5LdoFgWdsb2JhbAChXRYBARYiIr53hUoE
Date: Fri, 22 Oct 2010 12:05:27 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Nick Piggin <npiggin@kernel.dk>
Cc: Christoph Lameter <cl@linux.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 13/14] fs: icache split IO and LRU lists
Message-ID: <20101022010527.GA6048@amd>
References: <20101021130829.442910807@kernel.dk>
 <20101021131017.274548424@kernel.dk>
 <alpine.DEB.2.00.1010211018250.24115@router.home>
 <20101022000028.GE3270@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101022000028.GE3270@amd>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 22, 2010 at 11:00:28AM +1100, Nick Piggin wrote:
> On Thu, Oct 21, 2010 at 10:28:42AM -0500, Christoph Lameter wrote:
> > On Fri, 22 Oct 2010, npiggin@kernel.dk wrote:
> > 
> > > Split inode reclaim and writeback lists in preparation to scale them up
> > > (per-bdi locking for i_io and per-zone locking for i_lru)
> > 
> > Why per zone and not per node? Is there any chance of having lru lists for
> > ZONE_NORMAL and ZONE_DMA?
> 
> I guess I see that as coupling a bit too much with the MM. We know that
> zones are the unit of allocation and reclaim, but I don't think we need
> to care about which zones we need to care about, or the node:zone
> relationship.

But let's not worry about that in the context of this patch set.
This is just a minimal lock breaking, and the scalability steps can
go in any direction after this. I think zone based reclaim seems to
be the way to go, but we could discuss the point in a patch that
implements it, on top of this series.

Thanks,
Nick

