Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757950Ab2ECRyq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 13:54:46 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:18531 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753464Ab2ECRyp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 13:54:45 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 03 May 2012 10:54:36 -0700
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>
CC: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "joerg.roedel@amd.com" <joerg.roedel@amd.com>,
        "thierry.reding@avionic-design.de" <thierry.reding@avionic-design.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 3 May 2012 19:54:31 +0200
Subject: Re: [PATCHv3 3/4] iommu/tegra: smmu: Refrain from accessing to AHB
Thread-Topic: [PATCHv3 3/4] iommu/tegra: smmu: Refrain from accessing to AHB
Thread-Index: Ac0pVcv3zzCrkQ8BQSS8lwe3UtFs0Q==
Message-ID: <20120503.205431.1876975023371235981.hdoyu@nvidia.com>
References: <1336061147-10245-1-git-send-email-hdoyu@nvidia.com><1336061147-10245-3-git-send-email-hdoyu@nvidia.com><4FA2C4E9.2080509@wwwdotorg.org>
In-Reply-To: <4FA2C4E9.2080509@wwwdotorg.org>
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
Date: Thu, 3 May 2012 19:48:25 +0200
Message-ID: <4FA2C4E9.2080509@wwwdotorg.org>

> On 05/03/2012 10:05 AM, Hiroshi DOYU wrote:
> > Use "tegra_ahb_enable_smmu()" to inform AHB that SMMU is
> > ready, instead of directly aceessing AHB registers.
> 
> You need to make the Kconfig option for the SMMU either depend on or
> select the TEGRA_AHB option. If you don't, then if someone disables the
> AHB driver, the SMMU driver may still build, yet fail to link since the
> AHB API it calls doesn't exist.
> 
> > diff --git a/drivers/iommu/tegra-smmu.c b/drivers/iommu/tegra-smmu.c
> 
> > @@ -398,10 +388,8 @@ static void smmu_setup_regs(struct smmu_device *smmu)
> >  
> >  	smmu_flush_regs(smmu, 1);
> >  
> > -	val = ahb_read(smmu, AHB_XBAR_CTRL);
> > -	val |= AHB_XBAR_CTRL_SMMU_INIT_DONE_DONE <<
> > -		AHB_XBAR_CTRL_SMMU_INIT_DONE_SHIFT;
> > -	ahb_write(smmu, val, AHB_XBAR_CTRL);
> > +	err = tegra_ahb_enable_smmu(smmu->ahb);
> > +	return err;
> 
> You can just "return tegra_ahb_..." here.
> 
> > @@ -911,14 +899,16 @@ static int tegra_smmu_probe(struct platform_device *pdev)
> 
> > +	smmu->ahb = of_parse_phandle(pdev->dev.of_node, "ahb", 0);
> 
> Hmm, "ahb" should probably be "nvidia,ahb".
> 
> I see that neither this patch nor the next patch include binding
> documentation that describe this property. Can you please add documentation.

There will be the tegra Memory Controller(MC) patches following, which
will change the way DT is passed, where SMMU/dt is passed from
MC.

Can we wait for the following MC patches, not haveing doc for this
patch?
