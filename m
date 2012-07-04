Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756534Ab2GDLXx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 07:23:53 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:11036 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755771Ab2GDLXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 07:23:52 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 04 Jul 2012 04:23:48 -0700
Subject: Re: [PATCH 1/5] ARM: tegra: set up wlan clocks for tegra dt
From: Wei Ni <wni@nvidia.com>
To: Marc Dietrich <marvin24@gmx.de>
CC: Stephen Warren <swarren@nvidia.com>, "olof@lixom.net" <olof@lixom.net>,
        "ccross@android.com" <ccross@android.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "cjb@laptop.org" <cjb@laptop.org>
In-Reply-To: <6135516.CD1aogiCta@fb07-iapwap2>
References: <1341394488-13169-1-git-send-email-wni@nvidia.com>
	 <1341394488-13169-2-git-send-email-wni@nvidia.com>
	 <6135516.CD1aogiCta@fb07-iapwap2>
Date: Wed, 4 Jul 2012 19:23:33 +0800
Message-ID: <1341401013.9009.931.camel@tegra-chromium-2>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-07-04 at 18:43 +0800, Marc Dietrich wrote:
> Am Mittwoch, 4. Juli 2012, 17:34:44 schrieb Wei Ni:
> > Set up the wlan clock tree for Tegra20 and Tegra30.
> > 
> > Signed-off-by: Wei Ni <wni@nvidia.com>
> > ---
> >  arch/arm/mach-tegra/board-dt-tegra20.c |    1 +
> >  arch/arm/mach-tegra/board-dt-tegra30.c |    1 +
> >  2 files changed, 2 insertions(+), 0 deletions(-)
> > 
> > diff --git a/arch/arm/mach-tegra/board-dt-tegra20.c
> > b/arch/arm/mach-tegra/board-dt-tegra20.c index 70a19a9..fbcc7d9 100644
> > --- a/arch/arm/mach-tegra/board-dt-tegra20.c
> > +++ b/arch/arm/mach-tegra/board-dt-tegra20.c
> > @@ -78,6 +78,7 @@ static __initdata struct tegra_clk_init_table
> > tegra_dt_clk_init_table[] = { { "pll_a",      "pll_p_out1",   56448000,    
> >   true },
> >  	{ "pll_a_out0", "pll_a",        11289600,       true },
> >  	{ "cdev1",      NULL,           0,              true },
> > +	{ "blink",      "clk_32k",      32768,          true },
> 
> what's the reason to enable this on all boards? Would it make sense to set 
> this to "false" instead?

This clock is used for the wlan device, it need to be enabled, so that
the wlan device can be powered on, and then the mmc driver can enumerate
it.

> 
> Marc
> 
> 
> >  	{ "i2s1",       "pll_a_out0",   11289600,       false},
> >  	{ "i2s2",       "pll_a_out0",   11289600,       false},
> >  	{ NULL,		NULL,		0,		0},
> > diff --git a/arch/arm/mach-tegra/board-dt-tegra30.c
> > b/arch/arm/mach-tegra/board-dt-tegra30.c index 53bf60f..2d73c61 100644
> > --- a/arch/arm/mach-tegra/board-dt-tegra30.c
> > +++ b/arch/arm/mach-tegra/board-dt-tegra30.c
> > @@ -61,6 +61,7 @@ static __initdata struct tegra_clk_init_table
> > tegra_dt_clk_init_table[] = { { "pll_a_out0",	"pll_a",	11289600,	true },
> >  	{ "extern1",	"pll_a_out0",	0,		true },
> >  	{ "clk_out_1",	"extern1",	0,		true },
> > +	{ "blink",	"clk_32k",	32768,		true },
> >  	{ "i2s0",	"pll_a_out0",	11289600,	false},
> >  	{ "i2s1",	"pll_a_out0",	11289600,	false},
> >  	{ "i2s2",	"pll_a_out0",	11289600,	false},


