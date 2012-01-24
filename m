Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753888Ab2AXMHx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 07:07:53 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:15487 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471Ab2AXMHw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 07:07:52 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 24 Jan 2012 04:07:50 -0800
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: "joerg.roedel@amd.com" <joerg.roedel@amd.com>
CC: "joro@8bytes.org" <joro@8bytes.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linaro-mm-sig-bounces@lists.linaro.org" 
	<linaro-mm-sig-bounces@lists.linaro.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Tue, 24 Jan 2012 13:07:40 +0100
Subject: Re: [PATCH 2/2] ARM: IOMMU: Tegra30: Add iommu_ops for SMMU driver
Thread-Topic: [PATCH 2/2] ARM: IOMMU: Tegra30: Add iommu_ops for SMMU driver
Thread-Index: AczakMl7Y700/DRRTt+ySYGe/3uE/Q==
Message-ID: <20120124.140740.446867797082060957.hdoyu@nvidia.com>
References: <20120124110444.GB19255@amd.com><20120124.133614.1646093482547685131.hdoyu@nvidia.com><20120124115723.GC19255@amd.com>
In-Reply-To: <20120124115723.GC19255@amd.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-nvconfidentiality: public
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "joerg.roedel@amd.com" <joerg.roedel@amd.com>
Subject: Re: [PATCH 2/2] ARM: IOMMU: Tegra30: Add iommu_ops for SMMU driver
Date: Tue, 24 Jan 2012 12:57:23 +0100
Message-ID: <20120124115723.GC19255@amd.com>

> On Tue, Jan 24, 2012 at 12:36:14PM +0100, Hiroshi Doyu wrote:
> > > A domain is, as you said, a virtual address space for IO devices. But
> > > the important point is, an arbitrary number of devices can be part of a
> > > domain. This also means that the devices can be behind different
> > > hardware SMMUs. In this case your driver needs to program the page-table
> > > pointer into more than one SMMU to give devices behind different SMMUs
> > > the same address space.
> > 
> > Thank you for explaining.
> > 
> > Does the above mean that a buffer can be shared with different devices
> > which belong to different IOMMU devices(virtual address spaces)?
> > 
> > For example, assuming the following:
> > 
> > - We have "struct iommu_domain *domain1".
> > - "domain1" has iommu device "iommu_dev1" and "iommu_dev2".
> > - "iommu_dev1" has "client_dev1" and "client_dev2".
> > - "iommu_dev2" has "client_dev3" and "client_dev4".
> > 
> > "iommu_map(domain1, iova, pa, ...)" will create the following mapping
> > ___at once___:
> > 
> > - (iova)-(pa) mapping in iommu_dev1(iommmu_dev1's virtual address space)
> > - (iova)-(pa) mapping in iommu_dev2(iommmu_dev2's virtual address space)
> > 
> > Is the above correct?
> 
> Yes, this is correct.
> 
> > It seems that the same (iova) is used for different virtual address
> > spaces. What kind of case is this beneficial most in?
> 
> It is actually the _same_ virtual address space which is used by
> iommu_dev1 and iommu_dev2. Think of it like multiple threads of a single
> process. They also share the address space.

I see. The above makes more sense.

> This is a requirement of the iommu-api which is beneficial for
> virtualization and simplifies the usage of the api in general. The user
> does not need to care which devices can be assigned to which domain
> because of underlying hardware constraints. The goal of the iommu-api is
> to hide such contraints.

Now it's clear to me. I'll send the update patch soon.
Thank you for explaining all of this.

> 
> 
> 	Joerg
> 
> -- 
> AMD Operating System Research Center
> 
> Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
> General Managers: Alberto Bozzo
> Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632
> 
