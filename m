Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753852Ab0HBPsz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 11:48:55 -0400
Received: from smtp107.prem.mail.ac4.yahoo.com ([76.13.13.46]:27923 "HELO
	smtp107.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753581Ab0HBPsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 11:48:53 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: DsqsXsQVM1myAr3Sl7go6YEdCBISgfOhaK27D9BiaLbqg1C
 8rTTeqC0f5HLgOaIHKKNcq8FoeuAmh645LrSf3NkX1Xzgyc.CFUZWnhXmThk
 rL_1qrX0QUd0MDTtZ.h7w7.yuQWDwoGnJiauUqYgsFMh_.SckIvr2csnmN35
 FoRZwDeqHvTwVDb8h0tr3hWJn6XltZ.AxEUa2IPKlN5Rp0RRAc4aArdpcXb3
 SDMeOraM32C0AyE54bziFJ.r9VmnKPOre3hJDXdMBOMEabm1M
X-Yahoo-Newman-Property: ymail-3
Date: Mon, 2 Aug 2010 10:48:46 -0500 (CDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: Dave Hansen <dave@linux.vnet.ibm.com>, Minchan Kim <minchan.kim@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Milton Miller <miltonm@bga.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mel@csn.ul.ie>, Johannes Weiner <hannes@cmpxchg.org>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: Re: [PATCH] Tight check of pfn_valid on sparsemem - v4
In-Reply-To: <20100731153031.GE27064@n2100.arm.linux.org.uk>
Message-ID: <alpine.DEB.2.00.1008021044380.18490@router.home>
References: <alpine.DEB.2.00.1007291038100.16510@router.home> <20100729161856.GA16420@barrios-desktop> <alpine.DEB.2.00.1007291132210.17734@router.home> <20100729170313.GB16420@barrios-desktop> <alpine.DEB.2.00.1007291222410.17734@router.home>
 <20100729183320.GH18923@n2100.arm.linux.org.uk> <1280436919.16922.11246.camel@nimitz> <20100729221426.GA28699@n2100.arm.linux.org.uk> <1280450338.16922.11735.camel@nimitz> <alpine.DEB.2.00.1007300745180.9007@router.home>
 <20100731153031.GE27064@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 31 Jul 2010, Russell King - ARM Linux wrote:

> Looking at vmemmap sparsemem, we need to fix it as the page table
> allocation in there bypasses the arch defined page table setup.

You are required to define your own vmemmap_populate function. In that you
can call some of the provided functions or use your own.

> This causes a problem if you have 256-entry L2 page tables with no
> room for the additional Linux VM PTE support bits (such as young,
> dirty, etc), and need to glue two 256-entry L2 hardware page tables
> plus a Linux version to store its accounting in each page.  See
> arch/arm/include/asm/pgalloc.h.
>
> So this causes a problem with vmemmap:
>
>                 pte_t entry;
>                 void *p = vmemmap_alloc_block_buf(PAGE_SIZE, node);
>                 if (!p)
>                         return NULL;
>                 entry = pfn_pte(__pa(p) >> PAGE_SHIFT, PAGE_KERNEL);
>
> Are you willing for this stuff to be replaced by architectures as
> necessary?

Sure its designed that way. If we missed anything we'd surely add it.

