Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756957Ab1EXPu2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 11:50:28 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:20188 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753866Ab1EXPu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 11:50:27 -0400
Date: Tue, 24 May 2011 11:50:07 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Daniel Haid <d.haid@gogi.tv>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Question about iommu on x86_64 and radeon driver.
Message-ID: <20110524155007.GB29481@dumpdata.com>
References: <6ac3f6faad655602b767aa14b355e982@admin.gogi.tv>
 <20110523220536.GB11961@dumpdata.com>
 <756073831c36e0404199a4e8239bcb70@admin.gogi.tv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <756073831c36e0404199a4e8239bcb70@admin.gogi.tv>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4DDBD3BA.0167:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 24, 2011 at 12:45:47AM +0100, Daniel Haid wrote:
> >There had to be more than 'Map around memory hole'? Was it called
> >GART or IOMMU?
> I do not think that there was "IOMMU" or "GART" written there,
> but I do not think that the mainboard in question has an IOMMU
> (Am I correct that it would be a feature of the mainboard while
> the AMD GART is a feature of the CPU?).

So AMD GART is called poor-man IOMMU. And it is part of the
motherboard (northbridge mostly I think).

> I will look again as soon as I have physical access to the system.
> 
> >The problem you are hitting (I think) is that the AMD GART poor-man
> >IOMMU is turned off
> >and the SWIOTLB is used instead. If you would like some technical
> >details, take a look at:
> >
> >http://lists.freedesktop.org/archives/dri-devel/2011-January/006885.html
> >(the point #2 is what you are hitting).
> 
> You are correct. In all the cases where the radeon card does not work
> I see that SWIOTLB has been enabled in the kernel log.
> 
> So this is a bug? I suppose that all hardware should be working with
> SWIOTLB? Will a patch that fixes this somewhen be included?
> (The bug where your link points to was closed with WONTFIX)

Not bug per say. I've been working on making the TTM use the DMA API
so that those pages are allocated at startup and you don't end up
with having to sync the pages .. but I broke PowerPC and ARM during 2.6.39
so I need to redo it.

> 
> >Not sure why the AMD GART IOMMU gets disabled on VIA chipsets. You
> >might
> >want to use 'git gui blame arch/x86/kernel/early-quirks.c' and look
> >at the code in question to figure that out.
> >Well, if everything works.... but you might just want to use
> >the git gui blame to take a look at the back-story of why the quirk
> >was added.
> 
> Unfortunately I am getting crashes with "iommu=allowed". I will look
> at git blame.
> 
> Thank you for your answers.
