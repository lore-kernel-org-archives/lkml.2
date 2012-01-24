Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756550Ab2AXNl2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 08:41:28 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:4491 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754436Ab2AXNl1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 08:41:27 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 24 Jan 2012 05:41:26 -0800
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: "joro@8bytes.org" <joro@8bytes.org>
CC: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-mm-sig-bounces@lists.linaro.org" 
	<linaro-mm-sig-bounces@lists.linaro.org>
Date: Tue, 24 Jan 2012 14:41:21 +0100
Subject: Re: [PATCH 2/2] ARM: IOMMU: Tegra30: Add iommu_ops for SMMU driver
Thread-Topic: [PATCH 2/2] ARM: IOMMU: Tegra30: Add iommu_ops for SMMU driver
Thread-Index: Aczand1O++Gny6yZQRSckoP8Qc0nYg==
Message-ID: <20120124.154121.1062920821192552748.hdoyu@nvidia.com>
References: <1325747509-29665-1-git-send-email-hdoyu@nvidia.com><1325747509-29665-3-git-send-email-hdoyu@nvidia.com><20120123154310.GC6269@8bytes.org>
In-Reply-To: <20120123154310.GC6269@8bytes.org>
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

From: Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH 2/2] ARM: IOMMU: Tegra30: Add iommu_ops for SMMU driver
Date: Mon, 23 Jan 2012 16:43:10 +0100
Message-ID: <20120123154310.GC6269@8bytes.org>

> > +	}
> > +
> > +	spin_unlock_irqrestore(&as->lock, flags);
> > +
> > +	domain->priv = NULL;
> > +	dev_dbg(smmu->dev, "smmu_as@%p\n", as);
> > +}
> > +
> > +static int smmu_iommu_attach_dev(struct iommu_domain *domain,
> > +				 struct device *dev)
> > +{
> > +	struct smmu_as *as = domain->priv;
> > +	struct smmu_device *smmu = as->smmu;
> 
> Hmm, this looks like there is a 1-1 mapping between hardware SMMU
> devices and domains. This is not consistent with IOMMU-API semantics
> where a domain can contain devices behind different SMMUs. Please fix
> that.

Actually I really like the concept of this "domain" now, which hides
the H/W hierarchy from users.

But in Tegra SMMU/GART case, there's a single one IOMMU device in the
system. Keeping a iommu device list in a domain and iterating iommu
device list in each iommu_ops seem to be so nice, but I'm afraid that
this may be a bit too much when one already knows that there's only
one IOMMU device in the system.

If there's no actual problem for 1-1 mapping between IOMMU H/Ws and
domains, I think that it may not so bad to keep the original code(1-1)
for GART and SMMU. What do you think?
