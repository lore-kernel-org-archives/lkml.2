Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757062Ab1CaVOq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 17:14:46 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:37144 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753674Ab1CaVOp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 17:14:45 -0400
Subject: Re: [PATCH 04/12] mm: alloc_contig_freed_pages() added
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Michal Nazarewicz <mina86@mina86.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-mm@kvack.org, Kyungmin Park <kyungmin.park@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Ankita Garg <ankita@in.ibm.com>,
        Daniel Walker <dwalker@codeaurora.org>,
        Johan MOSSBERG <johan.xx.mossberg@stericsson.com>,
        Mel Gorman <mel@csn.ul.ie>, Pawel Osciak <pawel@osciak.com>
In-Reply-To: <op.vs77qfx03l0zgt@mnazarewicz-glaptop>
References: <1301577368-16095-1-git-send-email-m.szyprowski@samsung.com>
	 <1301577368-16095-5-git-send-email-m.szyprowski@samsung.com>
	 <1301587083.31087.1032.camel@nimitz>
	 <op.vs77qfx03l0zgt@mnazarewicz-glaptop>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Thu, 31 Mar 2011 14:14:38 -0700
Message-ID: <1301606078.31087.1275.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-31 at 23:09 +0200, Michal Nazarewicz wrote:
> On Thu, 31 Mar 2011 17:58:03 +0200, Dave Hansen <dave@linux.vnet.ibm.com>  
> wrote:
> > On Thu, 2011-03-31 at 15:16 +0200, Marek Szyprowski wrote:
> >> +unsigned long alloc_contig_freed_pages(unsigned long start, unsigned  
> >> long end,
> >> +                                      gfp_t flag)
> >> +{
> >> +       unsigned long pfn = start, count;
> >> +       struct page *page;
> >> +       struct zone *zone;
> >> +       int order;
> >> +
> >> +       VM_BUG_ON(!pfn_valid(start));
> >
> > This seems kinda mean.  Could we return an error?  I understand that
> > this is largely going to be an early-boot thing, but surely trying to
> > punt on crappy input beats a full-on BUG().
> 
> Actually, I would have to check but I think that the usage of this function
> (in this patchset) is that the caller expects the function to succeed.  It  
> is quite a low-level function so before running it a lot of preparation is  
> needed and the caller must make sure that several conditions are met.  I don't  
> really see advantage of returning a value rather then BUG()ing.
> 
> Also, CMA does not call this function at boot time.

We BUG_ON() in bootmem.  Basically if we try to allocate an early-boot
structure and fail, we're screwed.  We can't keep running without an
inode hash, or a mem_map[].

This looks like it's going to at least get partially used in drivers, at
least from the examples.  Are these kinds of things that, if the driver
fails to load, that the system is useless and hosed?  Or, is it
something where we might limp along to figure out what went wrong before
we reboot?

-- Dave

