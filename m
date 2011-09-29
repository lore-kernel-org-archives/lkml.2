Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756999Ab1I2Sz1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 14:55:27 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:7502 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756769Ab1I2SzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 14:55:23 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 29 Sep 2011 11:55:04 -0700
Date: Thu, 29 Sep 2011 21:55:00 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Stephen Warren <swarren@nvidia.com>
CC: Russell King <linux@arm.linux.org.uk>, Colin Cross <ccross@android.com>,
        Erik Gilling <konkers@android.com>, Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH v5 3/3] arm/tegra: device tree support for ventana board
Message-ID: <20110929185500.GP21166@tbergstrom-lnx.Nvidia.com>
References: <1317248978-10829-1-git-send-email-pdeschrijver@nvidia.com>
 <1317248978-10829-4-git-send-email-pdeschrijver@nvidia.com>
 <74CDBE0F657A3D45AFBB94109FB122FF173A2C6717@HQMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF173A2C6717@HQMAIL01.nvidia.com>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 29, 2011 at 07:04:15PM +0200, Stephen Warren wrote:
> Peter De Schrijver wrote at Wednesday, September 28, 2011 4:30 PM:
> ...
> > diff --git a/arch/arm/mach-tegra/board-dt.c b/arch/arm/mach-tegra/board-dt.c
> ...
> > @@ -80,9 +80,19 @@ static struct of_device_id tegra_dt_gic_match[] __initdata = {
> >  	{}
> >  };
> > 
> > +static struct {
> > +	char *machine;
> > +	void (*init)(void);
> > +} pinmux_configs[] = {
> > +	{ "nvidia,harmony", harmony_pinmux_init() },
> > +	{ "nvidia,seaboard", seaboard_pinmux_init() },
> > +	{ "nvidia,ventana", ventana_pinmux_init() },
> > +};
> 
> Do you want the brackets after the function names there? Locally, they
> cause the following syntax errors during compilation:
> 
> arch/arm/mach-tegra/board-dt.c:85: error: initializer element is not constant
> arch/arm/mach-tegra/board-dt.c:85: error: (near initialization for 'pinmux_configs[0].init')
> arch/arm/mach-tegra/board-dt.c:86: error: initializer element is not constant
> arch/arm/mach-tegra/board-dt.c:86: error: (near initialization for 'pinmux_configs[1].init')
> arch/arm/mach-tegra/board-dt.c:87: error: initializer element is not constant
> arch/arm/mach-tegra/board-dt.c:87: error: (near initialization for 'pinmux_configs[2].init')
> 
> (using gcc version 4.4.3 (gcc-4.4.3_cos_gg_51096))

It compiled fine here using gcc version 4.5.1 (Sourcery G++ Lite 2010.09-50).
I will change it next week when I'm back at the office.

Cheers,

Peter.

