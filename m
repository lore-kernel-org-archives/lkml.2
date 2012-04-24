Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754352Ab2DXNDa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 09:03:30 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:4499 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753927Ab2DXND2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 09:03:28 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Tue, 24 Apr 2012 06:03:25 -0700
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: "balbi@ti.com" <balbi@ti.com>
CC: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "ccross@android.com" <ccross@android.com>,
        "olof@lixom.net" <olof@lixom.net>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "tony@atomide.com" <tony@atomide.com>,
        "hsweeten@visionengravers.com" <hsweeten@visionengravers.com>,
        "jamie@jamieiles.com" <jamie@jamieiles.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 24 Apr 2012 15:03:19 +0200
Subject: Re: [PATCH v2 2/3] ARM: tegra: Add SMMU enabler in AHB
Thread-Topic: [PATCH v2 2/3] ARM: tegra: Add SMMU enabler in AHB
Thread-Index: Ac0iGp/FadhhH4F2Qfqdo1s37vAXCg==
Message-ID: <20120424.160319.1903472399760352200.hdoyu@nvidia.com>
References: <20120424123248.GG8444@arwen.pp.htv.fi><20120424.153930.1438573079107186567.hdoyu@nvidia.com><20120424124115.GL8444@arwen.pp.htv.fi>
In-Reply-To: <20120424124115.GL8444@arwen.pp.htv.fi>
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

From: Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH v2 2/3] ARM: tegra: Add SMMU enabler in AHB
Date: Tue, 24 Apr 2012 14:41:18 +0200
Message-ID: <20120424124115.GL8444@arwen.pp.htv.fi>

> * PGP Signed by an unknown key
> 
> On Tue, Apr 24, 2012 at 02:39:30PM +0200, Hiroshi Doyu wrote:
> > From: Felipe Balbi <balbi@ti.com>
> > Subject: Re: [PATCH v2 2/3] ARM: tegra: Add SMMU enabler in AHB
> > Date: Tue, 24 Apr 2012 14:32:52 +0200
> > Message-ID: <20120424123248.GG8444@arwen.pp.htv.fi>
> > 
> > > > Old Signed by an unknown key
> > > 
> > > Hi,
> > > 
> > > On Tue, Apr 24, 2012 at 03:05:15PM +0300, Hiroshi DOYU wrote:
> > > > @@ -95,6 +98,21 @@ static inline void gizmo_writel(unsigned long value, unsigned long offset)
> > > >  	writel(value, tegra_ahb->regs + offset);
> > > >  }
> > > >  
> > > > +#ifdef CONFIG_ARCH_TEGRA_3x_SOC
> > > > +
> > > > +void tegra_ahb_enable_smmu(void)
> > > > +{
> > > > +	unsigned long val;
> > > > +
> > > > +	val = gizmo_readl(AHB_ARBITRATION_XBAR_CTRL);
> > > > +	val |= AHB_ARBITRATION_XBAR_CTRL_SMMU_INIT_DONE_DONE <<
> > > > +		AHB_ARBITRATION_XBAR_CTRL_SMMU_INIT_DONE_SHIFT;
> > > > +	gizmo_writel(val, AHB_ARBITRATION_XBAR_CTRL);
> > > > +}
> > > > +EXPORT_SYMBOL(tegra_ahb_enable_smmu);
> > > 
> > > ok, so this is the only place where you need that global pointer. Who
> > > would call this ? Can you do runtime detection of the SoC and enable
> > > SMMU based on that ?
> > > 
> > > I mean, will this function always be called for TEGRA 3 SoCs or is there
> > > another condition to that ?
> > 
> > Only Tegra3 has SMMU.
> 
> but all of them ? In that case, you could call this from probe itself,
> right ? But an ifdef won't work in all cases, so you need to do runtime
> detection based on some revision register or cpu detection...

So far we don't have so many variants, and presently TEGRA_3x_SOC
always has a SMMU. If there were some variants of TEGRA_3x_SOC, where
some might not have SMMU, then runtime detection would make sense
there. Now it's something like TEGRA_3x_SOC == SMMU.
