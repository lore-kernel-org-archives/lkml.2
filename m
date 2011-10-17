Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822Ab1JQMVP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 08:21:15 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:24930 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752931Ab1JQMVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 08:21:11 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=us-ascii
Date: Mon, 17 Oct 2011 14:21:07 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCH 2/9] mm: alloc_contig_freed_pages() added
In-reply-to: <20111014162933.d8fead58.akpm@linux-foundation.org>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
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
Message-id: <01b201cc8cc7$3f6117d0$be234770$%szyprowski@samsung.com>
Organization: SPRC
X-Mailer: Microsoft Office Outlook 12.0
Content-language: pl
Thread-index: AcyKyST1RwCRS3JdTx+EvNpmVmqB2wB/cURg
References: <1317909290-29832-1-git-send-email-m.szyprowski@samsung.com>
 <1317909290-29832-3-git-send-email-m.szyprowski@samsung.com>
 <20111014162933.d8fead58.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Andrew,

Thanks for your comments. I will try to address them in the next round of
CMA patches.

On Saturday, October 15, 2011 1:30 AM Andrew Morton wrote:

(snipped)

> > +
> > +void free_contig_pages(unsigned long pfn, unsigned nr_pages)
> > +{
> > +	struct page *page = pfn_to_page(pfn);
> > +
> > +	while (nr_pages--) {
> > +		__free_page(page);
> > +		++pfn;
> > +		if (likely(zone_pfn_same_memmap(pfn - 1, pfn)))
> > +			++page;
> > +		else
> > +			page = pfn_to_page(pfn);
> > +	}
> > +}
> 
> You're sure these functions don't need EXPORT_SYMBOL()?  Maybe the
> design is that only DMA core calls into here (if so, that's good).

Drivers should not call it, it is intended to be used by low-level DMA
code. Do you think that a comment about missing EXPORT_SYMBOL is 
required?

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


