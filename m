Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752339Ab1HPKSJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 06:18:09 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:9796 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752025Ab1HPKSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 06:18:06 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=us-ascii
Date: Tue, 16 Aug 2011 12:17:30 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCH 7/9] ARM: DMA: steal memory for DMA coherent mappings
In-reply-to: <201108121453.05898.arnd@arndb.de>
To: "'Arnd Bergmann'" <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-mm@kvack.org,
        linaro-mm-sig@lists.linaro.org,
        "'Michal Nazarewicz'" <mina86@mina86.com>,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Russell King'" <linux@arm.linux.org.uk>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'KAMEZAWA Hiroyuki'" <kamezawa.hiroyu@jp.fujitsu.com>,
        "'Ankita Garg'" <ankita@in.ibm.com>,
        "'Daniel Walker'" <dwalker@codeaurora.org>,
        "'Mel Gorman'" <mel@csn.ul.ie>,
        "'Jesse Barker'" <jesse.barker@linaro.org>,
        "'Jonathan Corbet'" <corbet@lwn.net>,
        "'Shariq Hasnain'" <shariq.hasnain@linaro.org>,
        "'Chunsang Jeong'" <chunsang.jeong@linaro.org>
Message-id: <004301cc5bfd$b50048d0$1f00da70$%szyprowski@samsung.com>
Organization: SPRC
X-Mailer: Microsoft Office Outlook 12.0
Content-language: pl
Thread-index: AcxY7umCzwNZCqTbRRCWw2jnfxVpiwDCDRRg
References: <1313146711-1767-1-git-send-email-m.szyprowski@samsung.com>
 <1313146711-1767-8-git-send-email-m.szyprowski@samsung.com>
 <201108121453.05898.arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Friday, August 12, 2011 2:53 PM Arnd Bergmann wrote:

> On Friday 12 August 2011, Marek Szyprowski wrote:
> >
> > From: Russell King <rmk+kernel@arm.linux.org.uk>
> >
> > Steal memory from the kernel to provide coherent DMA memory to drivers.
> > This avoids the problem with multiple mappings with differing attributes
> > on later CPUs.
> >
> > Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
> > [m.szyprowski: rebased onto 3.1-rc1]
> > Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> 
> Hi Marek,
> 
> Is this the same patch that Russell had to revert because it didn't
> work on some of the older machines, in particular those using
> dmabounce?

Yes.
 
> I thought that our discussion ended with the plan to use this only
> for ARMv6+ (which has a problem with double mapping) but not on ARMv5
> and below (which don't have this problem but might need dmabounce).

Ok, my fault. I've forgot to mention that this patch was almost ready 
during Linaro meeting, but I didn't manage to post it that time. Of course 
it doesn't fulfill all the agreements from that discussion.

I was only unsure if we should care about the case where CMA is not enabled
for ARMv6+ or not. This patch was prepared in assumption that 
dma_alloc_coherent should work in both cases - with and without CMA.

Now I assume that for ARMv6+ the CMA should be enabled unconditionally.

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center

