Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754318Ab2DCO6i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 10:58:38 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:35702 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753449Ab2DCO6h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 10:58:37 -0400
MIME-Version: 1.0
In-Reply-To: <201204030907.29306.arnd@arndb.de>
References: <CA+55aFy4aFGRLUrF+rYN3dskTepBtC+=x3B3bc_rzf1OaN_5pw@mail.gmail.com>
	<CAH9JG2Wha0+6BwGW0APtEX2KACyR1+9fdKpJkM+iOU1m8N6d4w@mail.gmail.com>
	<201204030907.29306.arnd@arndb.de>
Date: Tue, 3 Apr 2012 10:58:36 -0400
Message-ID: <CAH3drwaGz0m_hnZqj41yAFXVLc++ZFBYR4G-ydUa6=NrkS78kQ@mail.gmail.com>
Subject: Re: Linux 3.4-rc1
From: Jerome Glisse <j.glisse@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Kyungmin Park <kmpark@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        vdumpa@nvidia.com, hdoyu@nvidia.com, konrad.wilk@oracle.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 3, 2012 at 5:07 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Tuesday 03 April 2012, Kyungmin Park wrote:
>> >
>> >  - DMA-mapping framework. The tree now has a few more acks from
>> > people, and it's largely in the same situation as HSI is: I'll
>> > probably pull, but I really wanted the users who are impacted to
>> > actually talk to me about it.
>> >
>> Hi,
>>
>> Now Marek and Nvidia persons are used it for DMA mapping based IOMMU.
>>
>> Are there other person who help to merge it?
>> (+CC related persons).
>
> I can give a little more background information.
>
> We used to have separate implementations of dma_map_ops for each
> architecture that had the need to abstract dma_alloc_coherent
> and dma_map_* across both IOMMU and linear (virt_to_bus style)
> mappings and/or swiotlb. Those dma_map_ops imlpementations were
> already merged before the start of the git history and subsequently
> got used on powerpc, ia64, x86_64, sparc, alpha, mips, unicore32
> and hexagon, roughly in that order.
>
> We are seeing lots of IOMMUs come up on ARM now, but unfortunately
> the existing dma_map_ops do not cover the need on ARM to have
> two different kind of coherent memory (write-combine and not
> write-combine) that we have traditionally abstracted using
> the dma_alloc_coherent and dma_alloc_writecombine functions on both
> arm and avr32. In order to support IOMMUs on ARM using the same
> API as everyone else, I've asked Marek to use dma_map_ops on
> ARM, which requires slightly extending the include/linux/dma-mapping.h
> interfaces so they cover this variation.
>
> The actually interesting work to implement a better abstraction for
> IOMMUs, building the dma-mapping.h API on top of the iommu.h API
> in an architecture independent way has also been implemented but
> requires these changes as a prerequisite.
>
>        Arnd

Out of curiosity where is the IOMMU abstraction work being discussed ?
Worked on ? I would like similar things on x86 platform and i spend
sometimes thinking on it in the past. Would like to make sure this
could also fit our need.

Cheers,
Jerome
