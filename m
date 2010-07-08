Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905Ab0GHGjM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 02:39:12 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:39217 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094Ab0GHGjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 02:39:10 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 12/14] vmscan: Do not writeback pages in direct reclaim
Cc: kosaki.motohiro@jp.fujitsu.com, Mel Gorman <mel@csn.ul.ie>,
       Minchan Kim <minchan.kim@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
       Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
       Rik van Riel <riel@redhat.com>, Christoph Hellwig <hch@infradead.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrea Arcangeli <aarcange@redhat.com>
In-Reply-To: <20100706202758.GC18210@cmpxchg.org>
References: <20100706152539.GG13780@csn.ul.ie> <20100706202758.GC18210@cmpxchg.org>
Message-Id: <20100708153811.CD30.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu,  8 Jul 2010 15:39:03 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, Jul 06, 2010 at 04:25:39PM +0100, Mel Gorman wrote:
> > On Tue, Jul 06, 2010 at 08:24:57PM +0900, Minchan Kim wrote:
> > > but it is still problem in case of swap file.
> > > That's because swapout on swapfile cause file system writepage which
> > > makes kernel stack overflow.
> > 
> > I don't *think* this is a problem unless I missed where writing out to
> > swap enters teh filesystem code. I'll double check.
> 
> It bypasses the fs.  On swapon, the blocks are resolved
> (mm/swapfile.c::setup_swap_extents) and then the writeout path uses
> bios directly (mm/page_io.c::swap_writepage).

Yeah, my fault. I did misunderstand this.

Thank you.



> 
> (GFP_NOFS still includes __GFP_IO, so allows swapping)
> 
> 	Hannes



