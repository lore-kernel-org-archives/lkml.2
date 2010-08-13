Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761149Ab0HMBgF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 21:36:05 -0400
Received: from snt0-omc1-s16.snt0.hotmail.com ([65.55.90.27]:5546 "EHLO
	snt0-omc1-s16.snt0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754906Ab0HMBgD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 21:36:03 -0400
Message-ID: <SNT125-W54B7AF8536BAFB36EB0118C3980@phx.gbl>
X-Originating-IP: [96.253.143.208]
From: Yuhong Bao <yuhongbao_386@hotmail.com>
To: <konrad.wilk@oracle.com>, <fujita.tomonori@lab.ntt.co.jp>
CC: <sa212+lkml@cyconix.com>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>
Subject: RE: Driver: PCIe: 'pci_map_sg' returning invalid bus address?
Date: Thu, 12 Aug 2010 18:35:59 -0700
Importance: Normal
In-Reply-To: <20100804145154.GC23544@phenom.dumpdata.com>
References: <4C593245.5070303@cyconix.com>
 <20100804190808D.fujita.tomonori@lab.ntt.co.jp>
 <4C594D78.6090407@cyconix.com>
 <20100804210206A.fujita.tomonori@lab.ntt.co.jp>,<20100804145154.GC23544@phenom.dumpdata.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 13 Aug 2010 01:36:01.0485 (UTC) FILETIME=[E312D7D0:01CB3A87]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > - add swiotlb support to x86_32 (I don't think that it's difficult but
> > I might miss something).
>
> I think the highmem support might be a bit tricky. The PowerPC folks
> did some work in there, so it _ought_ to work.
>
> Evan, you could edit arch/x86/Kconfig and change:
> config SWIOTLB
> def_bool y if X86_64
>
> to say
> def_bool y if X86
>
> and see how it works? FYI, it might wreak havoc on your machine thought,
> so be sure you have a fail-safe kernel and backup your root/home
> directory.
>
> (FYI, I made Xen-SWIOTLB be capable of running under X86_32 and so far
> no trouble.. but that is not baremetal obviously).
In fact, if you are going to port swiotlb, why not port the entire iommu support to x86_32 with PAE too?
In fact, I am really irritated at how the x86-64 port was developed completely separate from mainline, when 
it is just a variant of the same x86 arch. For another example of this, look at the history of ACPI SRAT support
in Linux.

Yuhong Bao
 		 	   		  