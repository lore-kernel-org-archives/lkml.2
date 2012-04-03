Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549Ab2DCT0i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 15:26:38 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:5545 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754944Ab2DCT0h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 15:26:37 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Tue, 03 Apr 2012 12:26:26 -0700
From: Krishna Reddy <vdumpa@nvidia.com>
To: Arnd Bergmann <arnd@arndb.de>, Kyungmin Park <kmpark@infradead.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Hiroshi Doyu <hdoyu@nvidia.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>
Date: Tue, 3 Apr 2012 12:26:25 -0700
Subject: RE: Linux 3.4-rc1
Thread-Topic: Linux 3.4-rc1
Thread-Index: Ac0ReTYPHr3RJHYhQNKcjS26hhKlHQAVHXwA
Message-ID: <401E54CE964CD94BAE1EB4A729C7087E37982E5C8F@HQMAIL04.nvidia.com>
References: <CA+55aFy4aFGRLUrF+rYN3dskTepBtC+=x3B3bc_rzf1OaN_5pw@mail.gmail.com>
 <CAH9JG2Wha0+6BwGW0APtEX2KACyR1+9fdKpJkM+iOU1m8N6d4w@mail.gmail.com>
 <201204030907.29306.arnd@arndb.de>
In-Reply-To: <201204030907.29306.arnd@arndb.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> We are seeing lots of IOMMUs come up on ARM now, but unfortunately the
> existing dma_map_ops do not cover the need on ARM to have two different
> kind of coherent memory (write-combine and not
> write-combine) that we have traditionally abstracted using the
> dma_alloc_coherent and dma_alloc_writecombine functions on both arm
> and avr32.

I agree with Arnd. 
Nvidia Tegra3 SOC and the other  future SOC's, which are based on ARM, have
IOMMU support. Most of the H/W modules see the memory through IOMMU.
We definitely need IOMMU support under dma_api's for ARM based SOC's
This really helps in avoiding vendor specific code for IOMMU space management.


>In order to support IOMMUs on ARM using the same API as
> everyone else, I've asked Marek to use dma_map_ops on ARM, which
> requires slightly extending the include/linux/dma-mapping.h interfaces so
> they cover this variation.

We have been using Marek patches from quite some time. 
The patches are stable enough and we are using them already internally.
 It  would be nice to get them into main stream as possible to avoid back porting
 during kernel transitions.

My two cents.


-KR
-nvpublic

> -----Original Message-----
> From: Arnd Bergmann [mailto:arnd@arndb.de]
> Sent: Tuesday, April 03, 2012 2:07 AM
> To: Kyungmin Park
> Cc: Linus Torvalds; Linux Kernel Mailing List; Krishna Reddy; Hiroshi Doyu;
> konrad.wilk@oracle.com
> Subject: Re: Linux 3.4-rc1
> 
> On Tuesday 03 April 2012, Kyungmin Park wrote:
> > >
> > >  - DMA-mapping framework. The tree now has a few more acks from
> > > people, and it's largely in the same situation as HSI is: I'll
> > > probably pull, but I really wanted the users who are impacted to
> > > actually talk to me about it.
> > >
> > Hi,
> >
> > Now Marek and Nvidia persons are used it for DMA mapping based
> IOMMU.
> >
> > Are there other person who help to merge it?
> > (+CC related persons).
> 
> I can give a little more background information.
> 
> We used to have separate implementations of dma_map_ops for each
> architecture that had the need to abstract dma_alloc_coherent and
> dma_map_* across both IOMMU and linear (virt_to_bus style) mappings
> and/or swiotlb. Those dma_map_ops imlpementations were already merged
> before the start of the git history and subsequently got used on powerpc,
> ia64, x86_64, sparc, alpha, mips, unicore32 and hexagon, roughly in that
> order.
> 
> We are seeing lots of IOMMUs come up on ARM now, but unfortunately the
> existing dma_map_ops do not cover the need on ARM to have two different
> kind of coherent memory (write-combine and not
> write-combine) that we have traditionally abstracted using the
> dma_alloc_coherent and dma_alloc_writecombine functions on both arm
> and avr32. In order to support IOMMUs on ARM using the same API as
> everyone else, I've asked Marek to use dma_map_ops on ARM, which
> requires slightly extending the include/linux/dma-mapping.h interfaces so
> they cover this variation.
> 
> The actually interesting work to implement a better abstraction for IOMMUs,
> building the dma-mapping.h API on top of the iommu.h API in an architecture
> independent way has also been implemented but requires these changes as
> a prerequisite.
> 
> 	Arnd
