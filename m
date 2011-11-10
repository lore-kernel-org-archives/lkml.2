Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935568Ab1KJQOb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 11:14:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28010 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933007Ab1KJQO3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 11:14:29 -0500
Date: Thu, 10 Nov 2011 17:12:44 +0100
From: Johannes Weiner <jweiner@redhat.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Konstantin Khlebnikov <khlebnikov@parallels.com>,
        Pekka Enberg <penberg@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mel@csn.ul.ie>, Minchan Kim <minchan.kim@gmail.com>,
        Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [rfc 3/3] mm: vmscan: revert file list boost on lru addition
Message-ID: <20111110161244.GN3153@redhat.com>
References: <20110808110658.31053.55013.stgit@localhost6>
 <CAOJsxLF909NRC2r6RL+hm1ARve+3mA6UM_CY9epJaauyqJTG8w@mail.gmail.com>
 <4E3FD403.6000400@parallels.com>
 <20111102163056.GG19965@redhat.com>
 <20111102163247.GJ19965@redhat.com>
 <20111107114520.33050d75.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111107114520.33050d75.kamezawa.hiroyu@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 07, 2011 at 11:45:20AM +0900, KAMEZAWA Hiroyuki wrote:
> On Wed, 2 Nov 2011 17:32:47 +0100
> Johannes Weiner <jweiner@redhat.com> wrote:
> 
> > The idea in 9ff473b 'vmscan: evict streaming IO first' was to steer
> > reclaim focus onto file pages with every new file page that hits the
> > lru list, so that an influx of used-once file pages does not lead to
> > swapping of anonymous pages.
> > 
> > The problem is that nobody is fixing up the balance if the pages in
> > fact become part of the resident set.
> > 
> > Anonymous page creation is neutral to the inter-lru balance, so even a
> > comparably tiny number of heavily used file pages tip the balance in
> > favor of the file list.
> > 
> > In addition, there is no refault detection, and every refault will
> > bias the balance even more.  A thrashing file working set will be
> > mistaken for a very lucrative source of reclaimable pages.
> > 
> > As anonymous pages are no longer swapped above a certain priority
> > level, this mechanism is no longer needed.  Used-once file pages
> > should get reclaimed before the VM even considers swapping.
> > 
> > Signed-off-by: Johannes Weiner <jweiner@redhat.com>
> 
> Do you have some results ?

Not yet, sorry, I had to drop it all and do something else.

This change relies on the VM having a different mechanism to go for
one-shot file cache first, so I need to address Kosaki-san's concerns
about 1/3 before pursuing this patch.
