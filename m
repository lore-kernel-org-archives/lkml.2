Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756840Ab2GDLvb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 07:51:31 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:38316 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756287Ab2GDLv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 07:51:29 -0400
X-Authenticated: #9962044
X-Provags-ID: V01U2FsdGVkX19iyZJMah5ilW2HtmeZVdF/6p2eHd7+2iK9dr+JxK
	Tn5/YfPbrGy5IP
From: Marc Dietrich <marvin24@gmx.de>
To: Wei Ni <wni@nvidia.com>
Cc: Stephen Warren <swarren@nvidia.com>, "olof@lixom.net" <olof@lixom.net>,
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
Subject: Re: Re: [PATCH 1/5] ARM: tegra: set up wlan clocks for tegra dt
Date: Wed, 04 Jul 2012 13:51:23 +0200
Message-ID: <5111476.afQhu2nTJB@fb07-iapwap2>
User-Agent: KMail/4.8.4 (Linux/3.4.4-3-desktop; KDE/4.8.4; x86_64; ; )
In-Reply-To: <1341401013.9009.931.camel@tegra-chromium-2>
References: <1341394488-13169-1-git-send-email-wni@nvidia.com> <6135516.CD1aogiCta@fb07-iapwap2> <1341401013.9009.931.camel@tegra-chromium-2>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="UTF-8"
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 4. Juli 2012, 19:23:33 schrieb Wei Ni:
> On Wed, 2012-07-04 at 18:43 +0800, Marc Dietrich wrote:
> > Am Mittwoch, 4. Juli 2012, 17:34:44 schrieb Wei Ni:
> > > Set up the wlan clock tree for Tegra20 and Tegra30.
> > > 
> > > Signed-off-by: Wei Ni <wni@nvidia.com>
> > > ---
> > > 
> > >  arch/arm/mach-tegra/board-dt-tegra20.c |    1 +
> > >  arch/arm/mach-tegra/board-dt-tegra30.c |    1 +
> > >  2 files changed, 2 insertions(+), 0 deletions(-)
> > > 
> > > diff --git a/arch/arm/mach-tegra/board-dt-tegra20.c
> > > b/arch/arm/mach-tegra/board-dt-tegra20.c index 70a19a9..fbcc7d9 100644
> > > --- a/arch/arm/mach-tegra/board-dt-tegra20.c
> > > +++ b/arch/arm/mach-tegra/board-dt-tegra20.c
> > > @@ -78,6 +78,7 @@ static __initdata struct tegra_clk_init_table
> > > tegra_dt_clk_init_table[] = { { "pll_a",      "pll_p_out1",   56448000,
> > > 
> > >   true },
> > >   
> > >  	{ "pll_a_out0", "pll_a",        11289600,       true },
> > >  	{ "cdev1",      NULL,           0,              true },
> > > 
> > > +	{ "blink",      "clk_32k",      32768,          true },
> > 
> > what's the reason to enable this on all boards? Would it make sense to set
> > this to "false" instead?
> 
> This clock is used for the wlan device, it need to be enabled, so that
> the wlan device can be powered on, and then the mmc driver can enumerate
> it.

My question was more why you enable it for *all* boards, even those without 
wlan cards connected to the sdhci. Defining it, but set it to "false", would 
give the driver the chance to enable it only on request. On the other hand, 
the impact on additional power consumption may be too low to measure.

Marc

> > 
> > >  	{ "i2s1",       "pll_a_out0",   11289600,       false},
> > >  	{ "i2s2",       "pll_a_out0",   11289600,       false},
> > >  	{ NULL,		NULL,		0,		0},
> > > 
> > > diff --git a/arch/arm/mach-tegra/board-dt-tegra30.c
> > > b/arch/arm/mach-tegra/board-dt-tegra30.c index 53bf60f..2d73c61 100644
> > > --- a/arch/arm/mach-tegra/board-dt-tegra30.c
> > > +++ b/arch/arm/mach-tegra/board-dt-tegra30.c
> > > @@ -61,6 +61,7 @@ static __initdata struct tegra_clk_init_table
> > > tegra_dt_clk_init_table[] = { { "pll_a_out0",	"pll_a",	11289600,	true },
> > > 
> > >  	{ "extern1",	"pll_a_out0",	0,		true },
> > >  	{ "clk_out_1",	"extern1",	0,		true },
> > > 
> > > +	{ "blink",	"clk_32k",	32768,		true },
> > > 
> > >  	{ "i2s0",	"pll_a_out0",	11289600,	false},
> > >  	{ "i2s1",	"pll_a_out0",	11289600,	false},
> > >  	{ "i2s2",	"pll_a_out0",	11289600,	false},
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-tegra" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
