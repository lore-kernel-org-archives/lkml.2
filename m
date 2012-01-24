Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756524Ab2AXL5e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 06:57:34 -0500
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:22088
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754374Ab2AXL5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 06:57:31 -0500
X-SpamScore: -19
X-BigFish: VPS-19(zz1432N98dKzz1202hzz15d4Rz2dhc1bhc31hc1ah668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LYAX7M-01-9NE-02
X-M-MSG: 
Date: Tue, 24 Jan 2012 12:57:23 +0100
From: "joerg.roedel@amd.com" <joerg.roedel@amd.com>
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
Message-ID: <20120124115723.GC19255@amd.com>
References: <20120123154310.GC6269@8bytes.org>
 <20120124.115701.2179509760878976509.hdoyu@nvidia.com>
 <20120124110444.GB19255@amd.com>
 <20120124.133614.1646093482547685131.hdoyu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120124.133614.1646093482547685131.hdoyu@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 24, 2012 at 12:36:14PM +0100, Hiroshi Doyu wrote:
> > A domain is, as you said, a virtual address space for IO devices. But
> > the important point is, an arbitrary number of devices can be part of a
> > domain. This also means that the devices can be behind different
> > hardware SMMUs. In this case your driver needs to program the page-table
> > pointer into more than one SMMU to give devices behind different SMMUs
> > the same address space.
> 
> Thank you for explaining.
> 
> Does the above mean that a buffer can be shared with different devices
> which belong to different IOMMU devices(virtual address spaces)?
> 
> For example, assuming the following:
> 
> - We have "struct iommu_domain *domain1".
> - "domain1" has iommu device "iommu_dev1" and "iommu_dev2".
> - "iommu_dev1" has "client_dev1" and "client_dev2".
> - "iommu_dev2" has "client_dev3" and "client_dev4".
> 
> "iommu_map(domain1, iova, pa, ...)" will create the following mapping
> ___at once___:
> 
> - (iova)-(pa) mapping in iommu_dev1(iommmu_dev1's virtual address space)
> - (iova)-(pa) mapping in iommu_dev2(iommmu_dev2's virtual address space)
> 
> Is the above correct?

Yes, this is correct.

> It seems that the same (iova) is used for different virtual address
> spaces. What kind of case is this beneficial most in?

It is actually the _same_ virtual address space which is used by
iommu_dev1 and iommu_dev2. Think of it like multiple threads of a single
process. They also share the address space.
This is a requirement of the iommu-api which is beneficial for
virtualization and simplifies the usage of the api in general. The user
does not need to care which devices can be assigned to which domain
because of underlying hardware constraints. The goal of the iommu-api is
to hide such contraints.


	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

