Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507Ab1H2KQE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 06:16:04 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:9848 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753387Ab1H2KP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 06:15:59 -0400
X-SpamScore: -21
X-BigFish: VPS-21(zz9371K1432N98dKzz1202hzz15d4R8275bhz32i668h839h944h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LQOPUF-02-0TK-02
X-M-MSG: 
Date: Mon, 29 Aug 2011 12:15:50 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        David Brown <davidb@codeaurora.org>,
        Stepan Moskovchenko <stepanm@codeaurora.org>
Subject: Re: [PATCH] iommu: Remove stub functions for !CONFIG_IOMMU_API
Message-ID: <20110829101550.GT1923@amd.com>
References: <1314364839-28492-1-git-send-email-joerg.roedel@amd.com>
 <CAK=WgbaiNxo_226Zp9BZpgUjYFajnvgPPCjCOYP2Tj4pkWTwVA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAK=WgbaiNxo_226Zp9BZpgUjYFajnvgPPCjCOYP2Tj4pkWTwVA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 27, 2011 at 07:56:39AM -0400, Ohad Ben-Cohen wrote:
> On Fri, Aug 26, 2011 at 4:20 PM, Joerg Roedel <joerg.roedel@amd.com> wrote:
> > Remove most of the stub functions because they are only
> > allowed to use when CONFIG_IOMMU_API is set anyway. This
> > will catch missing 'select' entries in kconfig at compile
> > time already.
> 
> I'm not sure we want this; think about a generic framework/driver that
> uses the IOMMU API only if the underlying hardware has an IOMMU and
> otherwise will skip calling the IOMMU API altogether (e.g. this is
> where remoteproc is headed).

CONFIG_IOMMU_API would just compile in drivers/iommu/iommu.c to provide
the base-functionality of the api. You don't need to select and IOMMU
driver in the first place if your board doesn't have one.

On the other side this change makes it easy for a developer to find
kconfig problems already at compile time when he/she uses iommu-api
functions without selecting the api.

> With this patch, such generic code will have to "select IOMMU_API"
> unconditionally, or it won't build when the hardware doesn't have an
> IOMMU (e.g. the DSP in at least several of the DaVinci SoC isn't
> behind an IOMMU). But doing so is a bit wasteful if there's no IOMMU
> hardware...

Isn't the abstraction that the drivers use the dma-api? There should be
an implementation that doesn't require the iommu-api for such devices,
no?

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

