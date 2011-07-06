Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565Ab1GFQTJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 12:19:09 -0400
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:29956 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752115Ab1GFQTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 12:19:07 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: e_fq3hwVM1mFImfE3_JhV0RAgVaH4ewtvAyB3LuAqrVGpCS
 e71WJYnzhzGLHysqeAUOK35O7LMYZhWxsITX2YwhCDSS1KAzq_aKaG0GtJWE
 WM4kQtQi0r5keMowLn.tcKNt_acc1i4ZC7RtVk2QNv_lAMWWbPQQpRf1UVML
 t1Q3tqXde3SAYg4Yjrq2cXpVUXQwnJYD9b2URRt0skmZLdChpg0LKS9sQf09
 C5baOvwjcLPXi1BoOVQYkA8WRFo1wX7lIzWgmYeIipKehFJmWHIjt.pFhars
 3CO.3cX43_cUwFKbLugNaexxMmxwPxfwj9DAPFTeTyLnIe3re
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 6 Jul 2011 11:19:00 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Michal Nazarewicz <mina86@mina86.com>
cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        "'Daniel Walker'" <dwalker@codeaurora.org>,
        "'Jonathan Corbet'" <corbet@lwn.net>, "'Mel Gorman'" <mel@csn.ul.ie>,
        "'Chunsang Jeong'" <chunsang.jeong@linaro.org>,
        "'Jesse Barker'" <jesse.barker@linaro.org>,
        "'KAMEZAWA Hiroyuki'" <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
        linux-mm@kvack.org, "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Ankita Garg'" <ankita@in.ibm.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-media@vger.kernel.org, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 6/8] drivers: add Contiguous Memory Allocator
In-Reply-To: <op.vx7ghajd3l0zgt@mnazarewicz-glaptop>
Message-ID: <alpine.DEB.2.00.1107061114150.19547@router.home>
References: <1309851710-3828-1-git-send-email-m.szyprowski@samsung.com> <201107061609.29996.arnd@arndb.de> <20110706142345.GC8286@n2100.arm.linux.org.uk> <201107061651.49824.arnd@arndb.de> <20110706154857.GG8286@n2100.arm.linux.org.uk>
 <alpine.DEB.2.00.1107061100290.17624@router.home> <op.vx7ghajd3l0zgt@mnazarewicz-glaptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Jul 2011, Michal Nazarewicz wrote:

> On Wed, 06 Jul 2011 18:05:00 +0200, Christoph Lameter <cl@linux.com> wrote:
> > ZONE_DMA is a zone for memory of legacy (crippled) devices that cannot DMA
> > into all of memory (and so is ZONE_DMA32).  Memory from ZONE_NORMAL
> > can be used for DMA as well and a fully capable device would be expected
> > to handle any memory in the system for DMA transfers.
> >
> > "guaranteed" dmaable memory? DMA abilities are device specific. Well maybe
> > you can call ZONE_DMA memory to be guaranteed if you guarantee
> > that any device must at mininum be able to perform DMA into ZONE_DMA
> > memory. But there may not be much of that memory around so you would
> > want to limit the use of that scarce resource.
>
> As pointed in Marek's other mail, this reasoning is not helping in any
> way.  In case of video codec on various Samsung devices (and from some
> other threads this is not limited to Samsung), the codec needs separate
> buffers in separate memory banks.

What I described is the basic memory architecture of Linux. I am not that
familiar with ARM and the issue discussed here. Only got involved because
ZONE_DMA was mentioned. The nature of ZONE_DMA is often misunderstood.

The allocation of the memory banks for the Samsung devices has to fit
somehow into one of these zones. Its probably best to put the memory banks
into ZONE_NORMAL and not have any dependency on ZONE_DMA at all.

