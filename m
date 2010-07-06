Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755851Ab0GFU2a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 16:28:30 -0400
Received: from f0.cmpxchg.org ([85.214.51.133]:52351 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753541Ab0GFU23 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 16:28:29 -0400
Date: Tue, 6 Jul 2010 22:27:58 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Minchan Kim <minchan.kim@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
       Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
       Rik van Riel <riel@redhat.com>, Christoph Hellwig <hch@infradead.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH 12/14] vmscan: Do not writeback pages in direct reclaim
Message-ID: <20100706202758.GC18210@cmpxchg.org>
References: <20100702125155.69c02f85.akpm@linux-foundation.org>
 <20100705134949.GC13780@csn.ul.ie>
 <20100706093529.CCD1.A69D9226@jp.fujitsu.com>
 <20100706101235.GE13780@csn.ul.ie>
 <AANLkTin8FotAC1GvjuoYU9XA2eiSr6FWWh6bwypTdhq3@mail.gmail.com>
 <20100706152539.GG13780@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100706152539.GG13780@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 06, 2010 at 04:25:39PM +0100, Mel Gorman wrote:
> On Tue, Jul 06, 2010 at 08:24:57PM +0900, Minchan Kim wrote:
> > but it is still problem in case of swap file.
> > That's because swapout on swapfile cause file system writepage which
> > makes kernel stack overflow.
> 
> I don't *think* this is a problem unless I missed where writing out to
> swap enters teh filesystem code. I'll double check.

It bypasses the fs.  On swapon, the blocks are resolved
(mm/swapfile.c::setup_swap_extents) and then the writeout path uses
bios directly (mm/page_io.c::swap_writepage).

(GFP_NOFS still includes __GFP_IO, so allows swapping)

	Hannes
