Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752274Ab2GEIkL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 04:40:11 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:44241 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750917Ab2GEIkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 04:40:07 -0400
X-Authenticated: #9962044
X-Provags-ID: V01U2FsdGVkX18oCklNyO8oUnm5EnqXrrnGI6qvzY4+9/3QCt3Vvz
	pk+xuh2jAdCuR2
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
Subject: Re: [PATCH 1/5] ARM: tegra: set up wlan clocks for tegra dt
Date: Thu, 05 Jul 2012 10:39:56 +0200
Message-ID: <1721436.iVeh2uNYS7@fb07-iapwap2>
User-Agent: KMail/4.8.4 (Linux/3.4.4-3-desktop; KDE/4.8.4; x86_64; ; )
In-Reply-To: <1341458294.9009.973.camel@tegra-chromium-2>
References: <1341394488-13169-1-git-send-email-wni@nvidia.com> <5111476.afQhu2nTJB@fb07-iapwap2> <1341458294.9009.973.camel@tegra-chromium-2>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="UTF-8"
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 5. Juli 2012, 11:18:14 schrieb Wei Ni:
> On Wed, 2012-07-04 at 19:51 +0800, Marc Dietrich wrote:
> > Am Mittwoch, 4. Juli 2012, 19:23:33 schrieb Wei Ni:
> > > On Wed, 2012-07-04 at 18:43 +0800, Marc Dietrich wrote:
> > > > Am Mittwoch, 4. Juli 2012, 17:34:44 schrieb Wei Ni:
> > > > > Set up the wlan clock tree for Tegra20 and Tegra30.
> > > > > 
> > > > > Signed-off-by: Wei Ni <wni@nvidia.com>
> > > > > ---
> > > > > 
> > > > >  arch/arm/mach-tegra/board-dt-tegra20.c |    1 +
> > > > >  arch/arm/mach-tegra/board-dt-tegra30.c |    1 +
> > > > >  2 files changed, 2 insertions(+), 0 deletions(-)
> > > > > 
> > > > > diff --git a/arch/arm/mach-tegra/board-dt-tegra20.c
> > > > > b/arch/arm/mach-tegra/board-dt-tegra20.c index 70a19a9..fbcc7d9
> > > > > 100644
> > > > > --- a/arch/arm/mach-tegra/board-dt-tegra20.c
> > > > > +++ b/arch/arm/mach-tegra/board-dt-tegra20.c
> > > > > @@ -78,6 +78,7 @@ static __initdata struct tegra_clk_init_table
> > > > > tegra_dt_clk_init_table[] = { { "pll_a",      "pll_p_out1",  
> > > > > 56448000,
> > > > > 
> > > > >   true },
> > > > >   
> > > > >  	{ "pll_a_out0", "pll_a",        11289600,       true },
> > > > >  	{ "cdev1",      NULL,           0,              true },
> > > > > 
> > > > > +	{ "blink",      "clk_32k",      32768,          true },
> > > > 
> > > > what's the reason to enable this on all boards? Would it make sense to
> > > > set
> > > > this to "false" instead?
> > > 
> > > This clock is used for the wlan device, it need to be enabled, so that
> > > the wlan device can be powered on, and then the mmc driver can enumerate
> > > it.
> > ...
> Yes we have thought about this issue.
> In here we need to enable this clock before loading wifi driver, so that
> the mmc driver can enumerate it.
> This likes another thing that the SD controller should be taught how to
> provide to clients, such as trigger the power/reset gpios. We had talked
> about it in the:
> http://www.spinics.net/lists/linux-wireless/msg92093.html

ah, sorry, I didn't followed this discussion.

> And we are trying to provide the tegra clk framework support, so at that
> time we could set this clock for different boards.
> 
> So I suppose we can just dump it into the clk init tables for now.

ok, thanks for explanation. Let's hope there will be a better solution in the 
future.

Thanks!

Marc


