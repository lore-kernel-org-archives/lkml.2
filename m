Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750907Ab1IUNrO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 09:47:14 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:31276 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711Ab1IUNrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 09:47:13 -0400
Date: Wed, 21 Sep 2011 15:47:05 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCH 7/8] ARM: integrate CMA with DMA-mapping subsystem
In-reply-to: <CAMjpGUch=ogFQwBLqOukKVnyh60600jw5tMq-KYeNGSZ2PLQpA@mail.gmail.com>
To: "'Mike Frysinger'" <vapier.adi@gmail.com>
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
        "'Mel Gorman'" <mel@csn.ul.ie>, "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Jesse Barker'" <jesse.barker@linaro.org>,
        "'Jonathan Corbet'" <corbet@lwn.net>,
        "'Shariq Hasnain'" <shariq.hasnain@linaro.org>,
        "'Chunsang Jeong'" <chunsang.jeong@linaro.org>
Message-id: <001a01cc7864$f2c98ea0$d85cabe0$%szyprowski@samsung.com>
Organization: SPRC
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=utf-8
Content-language: pl
Content-transfer-encoding: 7BIT
Thread-index: AcxuTKFS5tdpLRmXSXyFjNDs9zySPQKFwqFQ
References: <1313764064-9747-1-git-send-email-m.szyprowski@samsung.com>
 <1313764064-9747-8-git-send-email-m.szyprowski@samsung.com>
 <CAMjpGUch=ogFQwBLqOukKVnyh60600jw5tMq-KYeNGSZ2PLQpA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thursday, September 08, 2011 7:27 PM Mike Frysinger wrote:

> On Fri, Aug 19, 2011 at 10:27, Marek Szyprowski wrote:
> >  arch/arm/include/asm/device.h         |    3 +
> >  arch/arm/include/asm/dma-contiguous.h |   33 +++
> 
> seems like these would be good asm-generic/ additions rather than arm

Only some of them can be really moved to asm-generic imho. The following
lines are definitely architecture specific:

void dma_contiguous_early_fixup(phys_addr_t base, unsigned long size);

Some other archs might define empty fixup function. Right now only ARM 
architecture is the real client of the CMA. IMHO if any other arch stats
using CMA, some of the CMA definitions can be then moved to asm-generic.
Right now I wanted to keep it as simple as possible.

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center



