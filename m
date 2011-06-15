Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355Ab1FOHMP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 03:12:15 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:57093 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851Ab1FOHMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 03:12:14 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=utf-8
Date: Wed, 15 Jun 2011 09:11:39 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCH 08/10] mm: cma: Contiguous Memory Allocator added
In-reply-to: <201106142030.07549.arnd@arndb.de>
To: "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Michal Nazarewicz'" <mina86@mina86.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-mm@kvack.org,
        linaro-mm-sig@lists.linaro.org,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'KAMEZAWA Hiroyuki'" <kamezawa.hiroyu@jp.fujitsu.com>,
        "'Ankita Garg'" <ankita@in.ibm.com>,
        "'Daniel Walker'" <dwalker@codeaurora.org>,
        "'Mel Gorman'" <mel@csn.ul.ie>,
        "'Jesse Barker'" <jesse.barker@linaro.org>
Message-id: <000501cc2b2b$789a54b0$69cefe10$%szyprowski@samsung.com>
Organization: SPRC
X-Mailer: Microsoft Office Outlook 12.0
Content-language: pl
Thread-index: AcwqwTteM6782y5XQ++EZ7tOUabeiAAX3hvg
References: <1307699698-29369-1-git-send-email-m.szyprowski@samsung.com>
 <201106141803.00876.arnd@arndb.de> <op.vw2r3xrj3l0zgt@mnazarewicz-glaptop>
 <201106142030.07549.arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tuesday, June 14, 2011 8:30 PM Arnd Bergmann wrote:

> On Tuesday 14 June 2011 18:58:35 Michal Nazarewicz wrote:
> > On Tue, 14 Jun 2011 18:03:00 +0200, Arnd Bergmann wrote:
> > > For all I know, that is something that is only true for a few very
> > > special Samsung devices,
> >
> > Maybe.  I'm just answering your question. :)
> >
> > Ah yes, I forgot that separate regions for different purposes could
> > decrease fragmentation.
> 
> That is indeed a good point, but having a good allocator algorithm
> could also solve this. I don't know too much about these allocation
> algorithms, but there are probably multiple working approaches to this.
> 
> > > I would suggest going forward without having multiple regions:
> >
> > Is having support for multiple regions a bad thing?  Frankly,
> > removing this support will change code from reading context passed
> > as argument to code reading context from global variable.  Nothing
> > is gained; functionality is lost.
> 
> What is bad IMHO is making them the default, which forces the board
> code to care about memory management details. I would much prefer
> to have contiguous allocation parameters tuned automatically to just
> work on most boards before we add ways to do board-specific hacks.

I see your concerns, but I really wonder how to determine the properties
of the global/default cma pool. You definitely don't want to give all
available memory o CMA, because it will have negative impact on kernel
operation (kernel really needs to allocate unmovable pages from time to
time). 

The only solution I see now is to provide Kconfig entry to determine
the size of the global CMA pool, but this still have some issues,
especially for multi-board kernels (each board probably will have
different amount of RAM and different memory-consuming devices
available). It looks that each board startup code still might need to
tweak the size of CMA pool. I can add a kernel command line option for
it, but such solution also will not solve all the cases (afair there
was a discussion about kernel command line parameters for memory 
configuration and the conclusion was that it should be avoided).

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center



