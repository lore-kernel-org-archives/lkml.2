Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755000Ab1DSNLv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 09:11:51 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:64784 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754752Ab1DSNLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 09:11:50 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Kyungmin Park <kmpark@infradead.org>
Subject: Re: [PATCH] OMAP: iommu flush page table entries from L1 and L2 cache
Date: Tue, 19 Apr 2011 15:11:39 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        Fernando Guzman Lugo <fernando.lugo@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Hiroshi DOYU <Hiroshi.DOYU@nokia.com>, linux-kernel@vger.kernel.org,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Ramesh Gupta <grgupta@ti.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Marek Szyprowski <m.szyprowski@samsung.com>
References: <1302817968-28516-1-git-send-email-fernando.lugo@ti.com> <201104191401.34818.arnd@arndb.de> <BANLkTim_30SbVhPLFOaq-KYwz5N6NGCe6A@mail.gmail.com>
In-Reply-To: <BANLkTim_30SbVhPLFOaq-KYwz5N6NGCe6A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104191511.39370.arnd@arndb.de>
X-Provags-ID: V02:K0:qI9EosoPDbs5iG7nuEy4QdudLxJEfFAY3xPFCKu3+EX
 Y9jXGdrs7Y9mVoS5lu+g3bwo8FnlyPY0l9BYHbInnBJifCEcf2
 qNf+ukIuvSTJwfc8k7XxcatnJJtqnyZPtQ7gQyyXMvnRaqPUiN
 vTplyIJ6+awRXffxc00gpfM1tbcVcJw1OOFmdEcf5DV2iVMx9S
 k/qVvC4gLnaKz8eq4o+sA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 19 April 2011, Kyungmin Park wrote:
> On Tue, Apr 19, 2011 at 9:01 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Tuesday 19 April 2011, Kyungmin Park wrote:
> >> On Mon, Apr 18, 2011 at 11:13 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> >> > On Monday 18 April 2011, Kyungmin Park wrote:
> >> >> On Mon, Apr 18, 2011 at 8:58 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> >> >> >
> >> >> > One missing piece is still a way for a platform to provide both
> >> >> > the iommu and the dma-mapping API in a unified driver. Right now,
> >> >> > you have to export both interface for a generic solution.
> >> >>
> >> >> Actually MSM and we (Michal, Marek) tried to merge the generic IOMMU
> >> >> implementation into mm, but MM did't accept it.
> >> >
> >> > I'm confused. What do you mean with MM?
> >> linux/mm, Memory Management.
> >
> > I'm still confused. What were you suggesting to merge in there?
> > Do you have a link to a mailing list discussion?
> 
> First, Zach Pfeffer <zpfeffer@codeaurora.org> sent the patch
> https://patchwork.kernel.org/patch/108736/
> 
> Second, Michal tried it.
> http://lkml.org/lkml/2010/9/6/41
> 
> http://lwn.net/Articles/403643/
> https://patchwork.kernel.org/patch/157451/

Ah, I did not realize you were talking about VCMM. I believe the main
reason what that patch was not received well is that it tried to add
yet another abstraction for IOMMUs when we already have too many of them.

It is essentially doing the opposite of what I was referring to above:
If we had added VCMM, each platform that has IOMMUs would now have to 
implement three interfaces: dma-mapping.h (struct dma_map_ops),
iommu.h (struct iommu_ops) and and vcm_driver.h (struct vcm_driver).

What I really meant was to unify the two we already have, so that
a platform only needs to implement e.g. iommu_ops and get the dma_mapping.h
interfaces for free.

	Arnd
