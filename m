Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139Ab2AXLEy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 06:04:54 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:1922 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755734Ab2AXLEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 06:04:53 -0500
X-SpamScore: -28
X-BigFish: VPS-28(zz179dN1102K1432N98dKzz1202hzz15d4Rz2dhc1bhc31hc1ah668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LYAURV-02-84L-02
X-M-MSG: 
Date: Tue, 24 Jan 2012 12:04:44 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Hiroshi Doyu <hdoyu@nvidia.com>
CC: "joro@8bytes.org" <joro@8bytes.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linaro-mm-sig-bounces@lists.linaro.org" 
	<linaro-mm-sig-bounces@lists.linaro.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 2/2] ARM: IOMMU: Tegra30: Add iommu_ops for SMMU driver
Message-ID: <20120124110444.GB19255@amd.com>
References: <1325747509-29665-1-git-send-email-hdoyu@nvidia.com>
 <1325747509-29665-3-git-send-email-hdoyu@nvidia.com>
 <20120123154310.GC6269@8bytes.org>
 <20120124.115701.2179509760878976509.hdoyu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120124.115701.2179509760878976509.hdoyu@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 24, 2012 at 10:57:01AM +0100, Hiroshi Doyu wrote:
> > Why do you completly ignore the size parameter in this function (and
> > in the unmap part below)?
> > According to the page-sizes you export to the generic layer size can be
> > 4k or 4M. You need to take care of that in this function.
> 
> I'll drop 4MB support here once. I'll make another patch for 4MB page
> support later.

Okay, so when you only export 4k everything should be fine.

> > Hmm, this looks like there is a 1-1 mapping between hardware SMMU
> > devices and domains. This is not consistent with IOMMU-API semantics
> > where a domain can contain devices behind different SMMUs. Please fix
> > that.
> 
> I'm a bit confused with the concept of "domain". I thought that
> "domain" is equivalent to a "virtual address space". Usually a IOMMU
> device provides a virtual address space for multiple client
> devices. IOW, a IOMMU device provides a virtual address space, which
> can be shared with multiple client devices.
> 
> Actually Tegra SMMU case, a single IOMMU device has 4 different
> virtual address speace("smmu_as"). Each "smmu_as" has its own virtual
> address space. "smmu_as[i]" has mutiple "smmu_client" devices.
> 
>   smmu_as[i] == domain[i]
> 
> I don't understand why "a domain can contain devices behind different
> SMMUs" because those client devices belong to different virtual
> address spaces, and they should belong to different "domains".
> 
> Could you please explain a bit more about "domain"?

A domain is, as you said, a virtual address space for IO devices. But
the important point is, an arbitrary number of devices can be part of a
domain. This also means that the devices can be behind different
hardware SMMUs. In this case your driver needs to program the page-table
pointer into more than one SMMU to give devices behind different SMMUs
the same address space.


	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

