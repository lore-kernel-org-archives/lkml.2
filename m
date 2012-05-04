Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752224Ab2EDGgt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 02:36:49 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:14506 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815Ab2EDGgs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 02:36:48 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 03 May 2012 23:36:40 -0700
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>
CC: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "joerg.roedel@amd.com" <joerg.roedel@amd.com>,
        "thierry.reding@avionic-design.de" <thierry.reding@avionic-design.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 4 May 2012 08:36:37 +0200
Subject: Re: [PATCHv3 3/4] iommu/tegra: smmu: Refrain from accessing to AHB
Thread-Topic: [PATCHv3 3/4] iommu/tegra: smmu: Refrain from accessing to AHB
Thread-Index: Ac0pwEHg1PDusHwCTVSKJXtTOp320Q==
Message-ID: <20120504.093637.894939287045949033.hdoyu@nvidia.com>
References: <1336061147-10245-3-git-send-email-hdoyu@nvidia.com><4FA2C4E9.2080509@wwwdotorg.org><4FA2C746.5080000@wwwdotorg.org>
In-Reply-To: <4FA2C746.5080000@wwwdotorg.org>
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

From: Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: [PATCHv3 3/4] iommu/tegra: smmu: Refrain from accessing to AHB
Date: Thu, 3 May 2012 19:58:30 +0200
Message-ID: <4FA2C746.5080000@wwwdotorg.org>

> On 05/03/2012 11:48 AM, Stephen Warren wrote:
> > On 05/03/2012 10:05 AM, Hiroshi DOYU wrote:
> >> Use "tegra_ahb_enable_smmu()" to inform AHB that SMMU is
> >> ready, instead of directly aceessing AHB registers.
> 
> Oh, that should be "accessing".
> 
> >> @@ -911,14 +899,16 @@ static int tegra_smmu_probe(struct platform_device *pdev)
> > 
> >> +	smmu->ahb = of_parse_phandle(pdev->dev.of_node, "ahb", 0);
> > 
> > Hmm, "ahb" should probably be "nvidia,ahb".
> > 
> > I see that neither this patch nor the next patch include binding
> > documentation that describe this property. Can you please add documentation.
> 
> Oh, the next patch is just adding the entry to the .dtsi file for the
> AHB, so no surprise it doesn't add a binding document for the SMMU!
> 
> I see that with this patch, the driver still expects the DMA window to
> be represented as a reg property (IORESOURCE_MEM), so if we add a
> binding document to this patch it won't be very consistent either:-( And
> then, there's the issue of whether the SMMU should be it's own device or
> a child of some MC device, since there's non-SMMU functionality in these
> registers too. This makes all the SMMU rework need a little more thought.
> 
> So, I propose dropping this patch from this series, since this series is
> all about adding the AHB driver. We should move this patch to a series
> relating to the SMMU driver.

Ok, I'll post the first 3 patches.
