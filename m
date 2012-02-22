Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209Ab2BVQ1D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 11:27:03 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:14513 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888Ab2BVQ1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 11:27:00 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=us-ascii
Date: Wed, 22 Feb 2012 17:26:43 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCHv22 13/16] drivers: add Contiguous Memory Allocator
In-reply-to: <alpine.DEB.2.00.1202212121560.962@localhost>
To: "'Aaro Koskinen'" <aaro.koskinen@iki.fi>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-mm@kvack.org,
        linaro-mm-sig@lists.linaro.org,
        "'Michal Nazarewicz'" <mina86@mina86.com>,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Russell King'" <linux@arm.linux.org.uk>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'KAMEZAWA Hiroyuki'" <kamezawa.hiroyu@jp.fujitsu.com>,
        "'Daniel Walker'" <dwalker@codeaurora.org>,
        "'Mel Gorman'" <mel@csn.ul.ie>, "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Jesse Barker'" <jesse.barker@linaro.org>,
        "'Jonathan Corbet'" <corbet@lwn.net>,
        "'Shariq Hasnain'" <shariq.hasnain@linaro.org>,
        "'Chunsang Jeong'" <chunsang.jeong@linaro.org>,
        "'Dave Hansen'" <dave@linux.vnet.ibm.com>,
        "'Benjamin Gaignard'" <benjamin.gaignard@linaro.org>,
        "'Rob Clark'" <rob.clark@linaro.org>,
        "'Ohad Ben-Cohen'" <ohad@wizery.com>
Message-id: <000001ccf17e$c3e50040$4baf00c0$%szyprowski@samsung.com>
Organization: SPRC
X-Mailer: Microsoft Office Outlook 12.0
Content-language: pl
Thread-index: Aczw4ACUXapK7zqmQ0uq7qn8Sm07iwAUZ2GA
References: <1329507036-24362-1-git-send-email-m.szyprowski@samsung.com>
 <1329507036-24362-14-git-send-email-m.szyprowski@samsung.com>
 <alpine.DEB.2.00.1202212121560.962@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tuesday, February 21, 2012 10:30 PM Aaro Koskinen wrote:

> On Fri, 17 Feb 2012, Marek Szyprowski wrote:
> > +/**
> > + * dma_release_from_contiguous() - release allocated pages
> > + * @dev:   Pointer to device for which the pages were allocated.
> > + * @pages: Allocated pages.
> > + * @count: Number of allocated pages.
> > + *
> > + * This function releases memory allocated by dma_alloc_from_contiguous().
> > + * It returns false when provided pages do not belong to contiguous area and
> > + * true otherwise.
> > + */
> > +bool dma_release_from_contiguous(struct device *dev, struct page *pages,
> > +				 int count)
> > +{
> > +	struct cma *cma = dev_get_cma_area(dev);
> > +	unsigned long pfn;
> > +
> > +	if (!cma || !pages)
> > +		return false;
> > +
> > +	pr_debug("%s(page %p)\n", __func__, (void *)pages);
> > +
> > +	pfn = page_to_pfn(pages);
> > +
> > +	if (pfn < cma->base_pfn || pfn >= cma->base_pfn + cma->count)
> > +		return false;
> > +
> > +	VM_BUG_ON(pfn + count > cma->base_pfn);
> 
> Are you sure the VM_BUG_ON() condition is correct here?

Thanks for pointing this bug. '+ cma->count' is missing in the second part.

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


