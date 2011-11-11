Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753982Ab1KKVyn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 16:54:43 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:12820 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089Ab1KKVyl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 16:54:41 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 11 Nov 2011 13:54:39 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Jamie Iles <jamie@jamieiles.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Fri, 11 Nov 2011 13:54:37 -0800
Subject: RE: [PATCH v4 04/10] arm/tegra: prepare early init for multiple
 tegra variants
Thread-Topic: [PATCH v4 04/10] arm/tegra: prepare early init for multiple
 tegra variants
Thread-Index: AcygZ2fBDUJAcWB/RxK+heItltZPGQAVPcPg
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF17408058BB@HQMAIL01.nvidia.com>
References: <1321010541-31337-1-git-send-email-pdeschrijver@nvidia.com>
 <1321010541-31337-5-git-send-email-pdeschrijver@nvidia.com>
 <20111111114521.GB5114@totoro>
In-Reply-To: <20111111114521.GB5114@totoro>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jamie Iles wrote at Friday, November 11, 2011 4:45 AM:
> On Fri, Nov 11, 2011 at 01:22:10PM +0200, Peter De Schrijver wrote:
> > This patch splits the early init code in a common and a tegra20 specific part.
> > L2 cache initialization is generalized and discovers the cache associativity
> > at runtime. Also use arm_pm_restart instead of arm_arch_reset and reset the
> > the system using the PMC reset feature rather then the CAR system reset.
...
> > diff --git a/arch/arm/mach-tegra/board-dt.c b/arch/arm/mach-tegra/board-dt.c
...
> > +static struct {
> > +	const char *machine;
> > +	void (*init)(void);
> > +} early_init[] __initdata = {
> > +#ifdef CONFIG_ARCH_TEGRA_2x_SOC
> > +	{ "nvidia,tegra20", tegra20_init_early },
> > +#endif
> > +};
> > +
> > +static void __init tegra_init_early(void)
> > +{
> > +
> > +	int i;
> > +
> > +	for (i = 0; i < ARRAY_SIZE(early_init); i++)
> > +		if (of_machine_is_compatible(early_init[i].machine))
> > +			return early_init[i].init();
> > +
> > +	pr_warn("Unknown platform detected\n");
> > +}
> 
> Wouldn't it be better just to have separate machine descs for tegra20
> and tegra30 and have a different .init_early for each?  I'm not sure
> that this extra indirection buys us much, especially if we had to repeat
> it for any of the other entries.

Jamie, thanks for pointing that. I think that does sound a lot simpler.

-- 
nvpublic

