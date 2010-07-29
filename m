Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757246Ab0G2MJl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 08:09:41 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:55547
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754118Ab0G2MJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 08:09:39 -0400
X-SpamScore: -23
X-BigFish: VPS-23(zz1432N9370J98dNzz1202hzz15d4Rz32i2a8h87h43h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L6BJ3H-02-D2Z-02
X-M-MSG: 
Date: Thu, 29 Jul 2010 14:12:02 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        "stepanm@codeaurora.org" <stepanm@codeaurora.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "dwalker@codeaurora.org" <dwalker@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] arm: msm: Add System MMU support.
Message-ID: <20100729121202.GR26098@amd.com>
References: <20100729090607.GN26098@amd.com>
 <20100729184336N.fujita.tomonori@lab.ntt.co.jp>
 <20100729100108.GQ26098@amd.com>
 <201007291325.48129.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <201007291325.48129.arnd@arndb.de>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 29, 2010 at 07:25:47AM -0400, Arnd Bergmann wrote:
> On Thursday 29 July 2010, Roedel, Joerg wrote:
> 
> > > You designed it for what you need at the time. It should have been
> > > named appropriately to avoid confusion. Later, when we actually
> > > understand what other IOMMUs need, we can evolve the specific API for
> > > generic purposes. Then we can rename the API to more generic.
> > 
> > At the time the iommu-api was written is was generic enough for what we
> > had. So it was designed as an generic API. At this point in time nobody
> > knew what the future requirements would we. So today it turns out that
> > it is not generic enough anymore for latest hardware. The logical
> > consequence is to fix this in the iommu-api.
> 
> Well, I think the real question is why we have two APIs that both claim
> to work with IOMMUs in a generic way and how we could unify the two.

The DMA-API itself does not claim to be an iommu-frontend. The purpose
of the DMA-API is to convert physical memory addresses into dma handles
and do all the management of these handles. Backend implementations can
use hardware iommus for this task. But depending on the hardware in the
system the DMA-API can very well be implemented without any hardware
support. This is an important difference to the IOMMU-API which needs
hardware because it exposes hardware iommu features to software.

> The Intel and AMD IOMMU drivers currently register at both the DMA
> API and the IOMMU API. The first one is used by everything except
> KVM and the second is only used by KVM.

Right. But there is also a mode where the AMD IOMMU driver only
registers for the IOMMU-API.

> I really think we should not extend the (KVM) IOMMU API further but
> just use the generic DMA mapping api for KVM and extend it as necessary.
> It already has the concept of cache coherency and mapping/unmapping
> that are in the IOMMU API and could be extended to support domains
> as well, through the use of dma_attrs.

If we find a nice and clean way to expose lower-level iommu
functionality through the DMA-API, thats fine. We could certainly
discuss ideas in this direction.  I think this is going to be hard
because the DMA-API today does not provide enough flexibility to let the
user choose both sides of a io-virtual<->cpu-physical address mapping.
Thats fine for most drivers because it makes sense for them to use the
generic io-address-allocator the DMA-API provides but not for KVM which
needs this flexibility.

	Joerg

-- 
Joerg Roedel - AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

