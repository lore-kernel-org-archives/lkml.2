Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752923Ab1JQSjZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 14:39:25 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:36708 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992Ab1JQSjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 14:39:23 -0400
Date: Mon, 17 Oct 2011 11:39:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-mm@kvack.org,
        linaro-mm-sig@lists.linaro.org,
        "'Michal Nazarewicz'" <mina86@mina86.com>,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Russell King'" <linux@arm.linux.org.uk>,
        "'KAMEZAWA Hiroyuki'" <kamezawa.hiroyu@jp.fujitsu.com>,
        "'Ankita Garg'" <ankita@in.ibm.com>,
        "'Daniel Walker'" <dwalker@codeaurora.org>,
        "'Mel Gorman'" <mel@csn.ul.ie>, "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Jesse Barker'" <jesse.barker@linaro.org>,
        "'Jonathan Corbet'" <corbet@lwn.net>,
        "'Shariq Hasnain'" <shariq.hasnain@linaro.org>,
        "'Chunsang Jeong'" <chunsang.jeong@linaro.org>,
        "'Dave Hansen'" <dave@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/9] mm: alloc_contig_freed_pages() added
Message-Id: <20111017113919.3b7ac253.akpm@linux-foundation.org>
In-Reply-To: <01b201cc8cc7$3f6117d0$be234770$%szyprowski@samsung.com>
References: <1317909290-29832-1-git-send-email-m.szyprowski@samsung.com>
	<1317909290-29832-3-git-send-email-m.szyprowski@samsung.com>
	<20111014162933.d8fead58.akpm@linux-foundation.org>
	<01b201cc8cc7$3f6117d0$be234770$%szyprowski@samsung.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Oct 2011 14:21:07 +0200
Marek Szyprowski <m.szyprowski@samsung.com> wrote:

> > > +
> > > +void free_contig_pages(unsigned long pfn, unsigned nr_pages)
> > > +{
> > > +	struct page *page = pfn_to_page(pfn);
> > > +
> > > +	while (nr_pages--) {
> > > +		__free_page(page);
> > > +		++pfn;
> > > +		if (likely(zone_pfn_same_memmap(pfn - 1, pfn)))
> > > +			++page;
> > > +		else
> > > +			page = pfn_to_page(pfn);
> > > +	}
> > > +}
> > 
> > You're sure these functions don't need EXPORT_SYMBOL()?  Maybe the
> > design is that only DMA core calls into here (if so, that's good).
> 
> Drivers should not call it, it is intended to be used by low-level DMA
> code.

OK, thanks for checking.

> Do you think that a comment about missing EXPORT_SYMBOL is 
> required?

No.  If someone later wants to use these from a module then we can look
at their reasons and make a decision at that time.

