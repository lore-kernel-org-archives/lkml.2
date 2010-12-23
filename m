Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664Ab0LWK6U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 05:58:20 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:29232 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752378Ab0LWK6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 05:58:19 -0500
Date: Thu, 23 Dec 2010 11:58:08 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCHv8 00/12] Contiguous Memory Allocator
In-reply-to: <20101223100642.GD3636@n2100.arm.linux.org.uk>
To: "'Russell King - ARM Linux'" <linux@arm.linux.org.uk>,
        "'Kyungmin Park'" <kmpark@infradead.org>
Cc: "'Michal Nazarewicz'" <m.nazarewicz@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        "'Daniel Walker'" <dwalker@codeaurora.org>,
        "'Johan MOSSBERG'" <johan.xx.mossberg@stericsson.com>,
        "'Mel Gorman'" <mel@csn.ul.ie>, linux-kernel@vger.kernel.org,
        "'Michal Nazarewicz'" <mina86@mina86.com>, linux-mm@kvack.org,
        "'Ankita Garg'" <ankita@in.ibm.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        linux-media@vger.kernel.org,
        "'KAMEZAWA Hiroyuki'" <kamezawa.hiroyu@jp.fujitsu.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <00ea01cba290$4d67f500$e837df00$%szyprowski@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7BIT
Thread-index: AcuiiWPfhnfwa0RHTauoouex3IdUTQABZHLQ
References: <cover.1292443200.git.m.nazarewicz@samsung.com>
 <AANLkTim8_=0+-zM5z4j0gBaw3PF3zgpXQNetEn-CfUGb@mail.gmail.com>
 <20101223100642.GD3636@n2100.arm.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thursday, December 23, 2010 11:07 AM Russell King - ARM Linux wrote:

> On Thu, Dec 23, 2010 at 06:30:57PM +0900, Kyungmin Park wrote:
> > Hi Andrew,
> >
> > any comments? what's the next step to merge it for 2.6.38 kernel. we
> > want to use this feature at mainline kernel.
> 
> Has anyone addressed my issue with it that this is wide-open for
> abuse by allocating large chunks of memory, and then remapping
> them in some way with different attributes, thereby violating the
> ARM architecture specification?

Actually this contiguous memory allocator is a better replacement for
alloc_pages() which is used by dma_alloc_coherent(). It is a generic
framework that is not tied only to ARM architecture.

> In other words, do we _actually_ have a use for this which doesn't
> involve doing something like allocating 32MB of memory from it,
> remapping it so that it's DMA coherent, and then performing DMA
> on the resulting buffer?

This is an arm specific problem, also related to dma_alloc_coherent()
allocator. To be 100% conformant with ARM specification we would
probably need to unmap all pages used by the dma_coherent allocator
from the LOW MEM area. This is doable, but completely not related
to the CMA and this patch series.

Best regards
--
Marek Szyprowski
Samsung Poland R&D Center


