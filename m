Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755798Ab1KXP3R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 10:29:17 -0500
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:28425
	"EHLO VA3EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755367Ab1KXP3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 10:29:12 -0500
X-SpamScore: -18
X-BigFish: VPS-18(z1039oz179dN1432N98dKzz1202hzz15d4Rz2dh668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LV68CG-01-IYA-02
X-M-MSG: 
Date: Thu, 24 Nov 2011 16:27:47 +0100
From: "'Joerg Roedel'" <Joerg.Roedel@amd.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
CC: "'David Woodhouse'" <dwmw2@infradead.org>,
        "'Ohad Ben-Cohen'" <ohad@wizery.com>,
        "'KyongHo Cho'" <pullip.cho@samsung.com>,
        "'Kai Huang'" <mail.kai.huang@gmail.com>, <kvm@vger.kernel.org>,
        "'Arnd Bergmann'" <arnd@arndb.de>, <linux-kernel@vger.kernel.org>,
        <iommu@lists.linux-foundation.org>,
        "'Laurent Pinchart'" <laurent.pinchart@ideasonboard.com>,
        "'David Brown'" <davidb@codeaurora.org>, <linux-omap@vger.kernel.org>,
        "'Stepan Moskovchenko'" <stepanm@codeaurora.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: Changing IOMMU-API for generic DMA-mapping supported by the
 hardware
Message-ID: <20111124152747.GG11876@amd.com>
References: <1318850846-16066-1-git-send-email-ohad@wizery.com>
 <1318850846-16066-3-git-send-email-ohad@wizery.com>
 <CANqQZNH1YRSgYRVxceicQ3szD=t7zeJjhJKEQ30PeKsxtj5V+A@mail.gmail.com>
 <1320938930.22195.17.camel@i7.infradead.org>
 <20111110170918.GE13213@amd.com>
 <1320953319.535.11.camel@i7.infradead.org>
 <20111111131728.GG13213@amd.com>
 <023b01ccaaa7$ef16c910$cd445b30$%szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <023b01ccaaa7$ef16c910$cd445b30$%szyprowski@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 24, 2011 at 01:52:33PM +0100, Marek Szyprowski wrote:
> In my DMA-mapping IOMMU integration I've used a dma_iommu_mapping structure,
> which contains a pointer to iommu domain, a bitmap and a lock. Maybe we 
> should consider extending iommu domain with allocation bitmap (or other 
> structure that hold information about used/unused iova ranges)? From the
> DMA-mapping (as a IOMMU client) perspective we only need 2 more callbacks
> in IOMMU API: alloc_iova_range() and free_iova_range(). 
> 
> Each IOMMU implementation can provide these calls based on internal bitmap
> allocator which will also cover the issue with reserved ranges. What do you
> think about such solution?

Hmm, the main point of a generic DMA-mapping implementation is that a
common address-allocator will be used. Today every IOMMU driver that
implements the DMA-API has its own allocator, this is something to unify
between for all drivers.

The allocator information can be stored in the default iommu_domain. We
need a user-private pointer there, but that is easy to add.


	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

