Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756133Ab1CaUds (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 16:33:48 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:56193 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752957Ab1CaUdq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 16:33:46 -0400
Subject: Re: [PATCH 04/12] mm: alloc_contig_freed_pages() added
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-mm@kvack.org, Michal Nazarewicz <mina86@mina86.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Ankita Garg <ankita@in.ibm.com>,
        Daniel Walker <dwalker@codeaurora.org>,
        Johan MOSSBERG <johan.xx.mossberg@stericsson.com>,
        Mel Gorman <mel@csn.ul.ie>, Pawel Osciak <pawel@osciak.com>
In-Reply-To: <20110331192429.GD14441@home.goodmis.org>
References: <1301577368-16095-1-git-send-email-m.szyprowski@samsung.com>
	 <1301577368-16095-5-git-send-email-m.szyprowski@samsung.com>
	 <1301587083.31087.1032.camel@nimitz>
	 <20110331192429.GD14441@home.goodmis.org>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Thu, 31 Mar 2011 13:33:39 -0700
Message-ID: <1301603619.31087.1203.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-31 at 15:24 -0400, Steven Rostedt wrote:
> On Thu, Mar 31, 2011 at 08:58:03AM -0700, Dave Hansen wrote:
> > On Thu, 2011-03-31 at 15:16 +0200, Marek Szyprowski wrote:
> > > 
> > > +unsigned long alloc_contig_freed_pages(unsigned long start, unsigned long end,
> > > +                                      gfp_t flag)
> > > +{
> > > +       unsigned long pfn = start, count;
> > > +       struct page *page;
> > > +       struct zone *zone;
> > > +       int order;
> > > +
> > > +       VM_BUG_ON(!pfn_valid(start));
> > 
> > This seems kinda mean.  Could we return an error?  I understand that
> > this is largely going to be an early-boot thing, but surely trying to
> > punt on crappy input beats a full-on BUG().
> > 
> > 	if (!pfn_valid(start))
> > 		return -1;
> 
> But still keep the warning?
> 
> 	if (WARN_ON(!pfn_valid(start))
> 		return -1;

Sure.  You might also want to make sure you're respecting __GFP_NOWARN
if you're going to do that, or maybe just warn once per boot.


-- Dave

