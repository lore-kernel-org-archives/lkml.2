Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983Ab2DXMjk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 08:39:40 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:7403 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753879Ab2DXMjj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 08:39:39 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 24 Apr 2012 05:39:35 -0700
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
Date: Tue, 24 Apr 2012 14:39:30 +0200
Subject: Re: [PATCH v2 2/3] ARM: tegra: Add SMMU enabler in AHB
Thread-Topic: [PATCH v2 2/3] ARM: tegra: Add SMMU enabler in AHB
Thread-Index: Ac0iF0xL8M7hTabnRUK8HQDzXNNXbg==
Message-ID: <20120424.153930.1438573079107186567.hdoyu@nvidia.com>
References: <1335269116-9578-1-git-send-email-hdoyu@nvidia.com><1335269116-9578-2-git-send-email-hdoyu@nvidia.com><20120424123248.GG8444@arwen.pp.htv.fi>
In-Reply-To: <20120424123248.GG8444@arwen.pp.htv.fi>
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
Date: Tue, 24 Apr 2012 14:32:52 +0200
Message-ID: <20120424123248.GG8444@arwen.pp.htv.fi>

> * PGP Signed by an unknown key
> 
> Hi,
> 
> On Tue, Apr 24, 2012 at 03:05:15PM +0300, Hiroshi DOYU wrote:
> > @@ -95,6 +98,21 @@ static inline void gizmo_writel(unsigned long value, unsigned long offset)
> >  	writel(value, tegra_ahb->regs + offset);
> >  }
> >  
> > +#ifdef CONFIG_ARCH_TEGRA_3x_SOC
> > +
> > +void tegra_ahb_enable_smmu(void)
> > +{
> > +	unsigned long val;
> > +
> > +	val = gizmo_readl(AHB_ARBITRATION_XBAR_CTRL);
> > +	val |= AHB_ARBITRATION_XBAR_CTRL_SMMU_INIT_DONE_DONE <<
> > +		AHB_ARBITRATION_XBAR_CTRL_SMMU_INIT_DONE_SHIFT;
> > +	gizmo_writel(val, AHB_ARBITRATION_XBAR_CTRL);
> > +}
> > +EXPORT_SYMBOL(tegra_ahb_enable_smmu);
> 
> ok, so this is the only place where you need that global pointer. Who
> would call this ? Can you do runtime detection of the SoC and enable
> SMMU based on that ?
> 
> I mean, will this function always be called for TEGRA 3 SoCs or is there
> another condition to that ?

Only Tegra3 has SMMU.
