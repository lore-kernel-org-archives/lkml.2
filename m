Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756256Ab1FJMWO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 08:22:14 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:19400 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755770Ab1FJMWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 08:22:10 -0400
Date: Fri, 10 Jun 2011 14:22:05 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCH 02/10] lib: genalloc: Generic allocator improvements
In-reply-to: <20110610122451.15af86d1@lxorguk.ukuu.org.uk>
To: "'Alan Cox'" <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-mm@kvack.org,
        linaro-mm-sig@lists.linaro.org,
        "'Michal Nazarewicz'" <mina86@mina86.com>,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'KAMEZAWA Hiroyuki'" <kamezawa.hiroyu@jp.fujitsu.com>,
        "'Ankita Garg'" <ankita@in.ibm.com>,
        "'Daniel Walker'" <dwalker@codeaurora.org>,
        "'Johan MOSSBERG'" <johan.xx.mossberg@stericsson.com>,
        "'Mel Gorman'" <mel@csn.ul.ie>, "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Jesse Barker'" <jesse.barker@linaro.org>
Message-id: <000c01cc2769$02669b70$0733d250$%szyprowski@samsung.com>
Organization: SPRC
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7BIT
Thread-index: AcwnYP17pPSneA7YQdyCWHjWn5mKQgABykRQ
References: <1307699698-29369-1-git-send-email-m.szyprowski@samsung.com>
 <1307699698-29369-3-git-send-email-m.szyprowski@samsung.com>
 <20110610122451.15af86d1@lxorguk.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Friday, June 10, 2011 1:25 PM Alan Cox wrote:

> I am curious about one thing
> 
> Why do we need this allocator. Why not use allocate_resource and friends.
> The kernel generic resource handler already handles object alignment and
> subranges. It just seems to be a surplus allocator that could perhaps be
> mostly removed by using the kernel resource allocator we already have ?

genalloc was used mainly for historical reasons (in the earlier version we
were looking for direct replacement for first fit allocator).

I plan to replace it with lib/bitmap.c bitmap_* based allocator (similar like
it it is used by dma_declare_coherent_memory() and friends in
drivers/base/dma-coherent.c). We need something really simple for CMA area
management. 

IMHO allocate_resource and friends a bit too heavy here, but good to know 
that such allocator also exists.

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


