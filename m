Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169Ab0DXL77 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Apr 2010 07:59:59 -0400
Received: from gir.skynet.ie ([193.1.99.77]:39557 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751967Ab0DXL76 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Apr 2010 07:59:58 -0400
Date: Sat, 24 Apr 2010 12:59:37 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Minchan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Adam Litke <agl@us.ibm.com>,
       Avi Kivity <avi@redhat.com>, David Rientjes <rientjes@google.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 04/14] mm,migration: Allow the migration of
	PageSwapCache  pages
Message-ID: <20100424115936.GG14351@csn.ul.ie>
References: <20100422195153.d91c1c9e.kamezawa.hiroyu@jp.fujitsu.com> <1271946226.2100.211.camel@barrios-desktop> <1271947206.2100.216.camel@barrios-desktop> <20100422154443.GD30306@csn.ul.ie> <20100423183135.GT32034@random.random> <20100423192311.GC14351@csn.ul.ie> <20100423193948.GU32034@random.random> <20100423213549.GV32034@random.random> <20100424105226.GF14351@csn.ul.ie> <20100424111340.GB32034@random.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20100424111340.GB32034@random.random>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 24, 2010 at 01:13:40PM +0200, Andrea Arcangeli wrote:
> On Sat, Apr 24, 2010 at 11:52:27AM +0100, Mel Gorman wrote:
> > I think you're right. This is a new bug introduced by the anon_vma changes. On
> > the plus side, it means we don't have to worry about -stable.
> 
> Correct, no worry about -stable.
> 
> > > vma_adjust already takes the anon_vma->lock and of course I also
> > > further verified that trying to apply your snippet to vma_adjust
> > > results in immediately deadlock as the very same lock is already taken
> > > in my tree as it's the same anon-vma (simpler).
> > 
> > Yes, I expected that. Previously, there was only one anon_vma so if you
> > double-take the lock, bad things happen.
> > 
> > > So aa.git will be
> > > immune from these bugs for now.
> > > 
> > 
> > It should be. I expect that's why you have never seen the bugon in
> > swapops.
> 
> Correct, I never seen it, and I keep it under very great stress with
> swap storms of hugepages, lots of I/O and khugepaged at 100% cpu.
> 

Well, to me this is also good because it shows it's not an existing bug in
migration or a new bug introduced by compaction either. Previously I hadn't
seen this bug either but until relatively recently, the bulk of the testing
was against 2.6.33.

> Also keep in mind expand_downwards which also adjusts
> vm_start/vm_pgoff the same way (and without mmap_sem write mode).
> 

Will keep it in mind. It's taking the anon_vma lock but once again,
there might be more than one anon_vma to worry about and the proper
locking still isn't massively clear to me.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
