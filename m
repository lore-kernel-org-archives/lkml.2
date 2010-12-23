Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752295Ab0LWNJz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 08:09:55 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:65233 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493Ab0LWNJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 08:09:54 -0500
Date: Thu, 23 Dec 2010 14:09:44 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCHv8 00/12] Contiguous Memory Allocator
In-reply-to: <20101223121917.GG3636@n2100.arm.linux.org.uk>
To: "'Russell King - ARM Linux'" <linux@arm.linux.org.uk>
Cc: "'Kyungmin Park'" <kmpark@infradead.org>,
        "'Michal Nazarewicz'" <m.nazarewicz@samsung.com>,
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
Message-id: <00ec01cba2a2$af20b8b0$0d622a10$%szyprowski@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7BIT
Thread-index: Acuim6rWc290esufReGeGb3ho0NVWgABUgRw
References: <cover.1292443200.git.m.nazarewicz@samsung.com>
 <AANLkTim8_=0+-zM5z4j0gBaw3PF3zgpXQNetEn-CfUGb@mail.gmail.com>
 <20101223100642.GD3636@n2100.arm.linux.org.uk>
 <00ea01cba290$4d67f500$e837df00$%szyprowski@samsung.com>
 <20101223121917.GG3636@n2100.arm.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thursday, December 23, 2010 1:19 PM Russell King - ARM Linux wrote:

> On Thu, Dec 23, 2010 at 11:58:08AM +0100, Marek Szyprowski wrote:
> > Actually this contiguous memory allocator is a better replacement for
> > alloc_pages() which is used by dma_alloc_coherent(). It is a generic
> > framework that is not tied only to ARM architecture.
> 
> ... which is open to abuse.  What I'm trying to find out is - if it
> can't be used for DMA, what is it to be used for?
> 
> Or are we inventing an everything-but-ARM framework?

We are trying to get something that really works and SOLVES some of the
problems with real devices that require contiguous memory for DMA.

> > > In other words, do we _actually_ have a use for this which doesn't
> > > involve doing something like allocating 32MB of memory from it,
> > > remapping it so that it's DMA coherent, and then performing DMA
> > > on the resulting buffer?
> >
> > This is an arm specific problem, also related to dma_alloc_coherent()
> > allocator. To be 100% conformant with ARM specification we would
> > probably need to unmap all pages used by the dma_coherent allocator
> > from the LOW MEM area. This is doable, but completely not related
> > to the CMA and this patch series.
> 
> You've already been told why we can't unmap pages from the kernel
> direct mapping.

It requires some amount of work but I see no reason why we shouldn't be
able to unmap that pages to stay 100% conformant with ARM spec.

Please notice that there are also use cases where the memory will not be
accessed by the CPU at all (like DMA transfers between multimedia devices
and the system memory).

> Okay, so I'm just going to assume that CMA has _no_ _business_ being
> used on ARM, and is not something that should interest anyone in the
> ARM community.

Go ahead! Remeber to remove dma_coherent because it also breaks the spec. :)
Oh, I forgot. We can also remove all device drivers that might use DMA. :)



Merry Christmas and Happy New Year for everyone! :)

Best regards
--
Marek Szyprowski
Samsung Poland R&D Center

