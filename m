Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759165Ab0JVABF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 20:01:05 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:52928 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759014Ab0JVABB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 20:01:01 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhYEAJRxwEx5LdoFgWdsb2JhbAChXhYBARYiIr84hUoE
Date: Fri, 22 Oct 2010 11:00:28 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Christoph Lameter <cl@linux.com>
Cc: npiggin@kernel.dk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 13/14] fs: icache split IO and LRU lists
Message-ID: <20101022000028.GE3270@amd>
References: <20101021130829.442910807@kernel.dk>
 <20101021131017.274548424@kernel.dk>
 <alpine.DEB.2.00.1010211018250.24115@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1010211018250.24115@router.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 21, 2010 at 10:28:42AM -0500, Christoph Lameter wrote:
> On Fri, 22 Oct 2010, npiggin@kernel.dk wrote:
> 
> > Split inode reclaim and writeback lists in preparation to scale them up
> > (per-bdi locking for i_io and per-zone locking for i_lru)
> 
> Why per zone and not per node? Is there any chance of having lru lists for
> ZONE_NORMAL and ZONE_DMA?

I guess I see that as coupling a bit too much with the MM. We know that
zones are the unit of allocation and reclaim, but I don't think we need
to care about which zones we need to care about, or the node:zone
relationship.


