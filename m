Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756948Ab0G2LZ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 07:25:56 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:59088 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753157Ab0G2LZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 07:25:55 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>
Subject: Re: [PATCH 1/2] arm: msm: Add System MMU support.
Date: Thu, 29 Jul 2010 13:25:47 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-8-generic; KDE/4.3.2; x86_64; ; )
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        "stepanm@codeaurora.org" <stepanm@codeaurora.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "dwalker@codeaurora.org" <dwalker@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20100729090607.GN26098@amd.com> <20100729184336N.fujita.tomonori@lab.ntt.co.jp> <20100729100108.GQ26098@amd.com>
In-Reply-To: <20100729100108.GQ26098@amd.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007291325.48129.arnd@arndb.de>
X-Provags-ID: V02:K0:e3oKlfHQhVHUQSkRx8oqTR76HnM3dRa+1aRoCeWawgZ
 MN9u+6qYHnulz2h3nRuTeVfMhtKDxIWBSDynJ2Pz4/CgTWi/vP
 eILIrIojfQTfF3jhzp335uFRda2CmtNYL9ssxzpuTBuFmFJpOa
 fG5AtEyKfR/sgdVAPfkQHufdWj7wKU198Zkv0rnoSYBeyLoSKV
 CqJNxGsjLgCPaCdTPr1wA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 29 July 2010, Roedel, Joerg wrote:

> > You designed it for what you need at the time. It should have been
> > named appropriately to avoid confusion. Later, when we actually
> > understand what other IOMMUs need, we can evolve the specific API for
> > generic purposes. Then we can rename the API to more generic.
> 
> At the time the iommu-api was written is was generic enough for what we
> had. So it was designed as an generic API. At this point in time nobody
> knew what the future requirements would we. So today it turns out that
> it is not generic enough anymore for latest hardware. The logical
> consequence is to fix this in the iommu-api.

Well, I think the real question is why we have two APIs that both claim
to work with IOMMUs in a generic way and how we could unify the two.

The Intel and AMD IOMMU drivers currently register at both the DMA
API and the IOMMU API. The first one is used by everything except
KVM and the second is only used by KVM.

I really think we should not extend the (KVM) IOMMU API further but
just use the generic DMA mapping api for KVM and extend it as necessary.
It already has the concept of cache coherency and mapping/unmapping
that are in the IOMMU API and could be extended to support domains
as well, through the use of dma_attrs.

	Arnd
