Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752495Ab1HPUY1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 16:24:27 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:2963 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739Ab1HPUY0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 16:24:26 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Tue, 16 Aug 2011 13:24:03 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Shawn Guo <shawn.guo@freescale.com>
CC: Grant Likely <grant.likely@secretlab.ca>, Colin Cross <ccross@android.com>,
        Erik Gilling <konkers@android.com>, Olof Johansson <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Belisko Marek <marek.belisko@gmail.com>,
        Jamie Iles <jamie@jamieiles.com>,
        Sergei Shtylyov <sshtylyov@mvista.com>
Date: Tue, 16 Aug 2011 13:24:00 -0700
Subject: RE: [RFC PATCH v2 03/13] arm/tegra: board-dt: Add AUXDATA for
 tegra-gpio and tegra-pinmux
Thread-Topic: [RFC PATCH v2 03/13] arm/tegra: board-dt: Add AUXDATA for
 tegra-gpio and tegra-pinmux
Thread-Index: Acxbw89aB9vlqAMVTQ68l+CBq3wBVgAjknxw
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF04AEA25430@HQMAIL01.nvidia.com>
References: <1313440100-17131-1-git-send-email-swarren@nvidia.com>
 <1313440100-17131-4-git-send-email-swarren@nvidia.com>
 <20110816033056.GE8044@S2100-06.ap.freescale.net>
In-Reply-To: <20110816033056.GE8044@S2100-06.ap.freescale.net>
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

Shawn Guo wrote at Monday, August 15, 2011 9:31 PM:
> On Mon, Aug 15, 2011 at 02:28:10PM -0600, Stephen Warren wrote:
> > Add AUXDATA so that Tegra GPIO and pinmux devices that are instantiated
> > from device-tree are named consistently with the static platform devices
> > in mach-tegra/devices.c. Note that the device-tree file tegra20.dtsi
> > already includes a node for the Tegra GPIO controller, whereas the node
> > for the Tegra pinmux controller will be added in a subsequent commit.
> >
> > Signed-off-by: Stephen Warren <swarren@nvidia.com>
> > ---
> >  arch/arm/mach-tegra/board-dt.c |    2 ++
> >  1 files changed, 2 insertions(+), 0 deletions(-)
> >
> > diff --git a/arch/arm/mach-tegra/board-dt.c b/arch/arm/mach-tegra/board-dt.c
> > index 9f47e04..1995b79 100644
> > --- a/arch/arm/mach-tegra/board-dt.c
> > +++ b/arch/arm/mach-tegra/board-dt.c
> > @@ -50,6 +50,8 @@ void seaboard_pinmux_init(void);
> >
> >
> >  struct of_dev_auxdata tegra20_auxdata_lookup[] __initdata = {
> > +	OF_DEV_AUXDATA("nvidia,tegra20-gpio", TEGRA_GPIO_BASE, "tegra-gpio", NULL),
> > +	OF_DEV_AUXDATA("nvidia,tegra20-pinmux", TEGRA_APB_MISC_BASE, "tegra-pinmux", NULL),
> >  	OF_DEV_AUXDATA("nvidia,tegra20-sdhci", TEGRA_SDMMC1_BASE, "sdhci-tegra.0", NULL),
> >  	OF_DEV_AUXDATA("nvidia,tegra20-sdhci", TEGRA_SDMMC2_BASE, "sdhci-tegra.1", NULL),
> >  	OF_DEV_AUXDATA("nvidia,tegra20-sdhci", TEGRA_SDMMC3_BASE, "sdhci-tegra.2", NULL),
> >
> The whole auxdata table was primarily added to keep clk API working
> with the device name looking up.  Your gpio and pinmux can still work
> without this patch, right?  If that's case, I do not think we need to
> have this patch just for consistent device name between dt and non-dt.
> They are not and they do not have to be.

Indeed, everything does work fine without the AUXDATA; there's no
dependence on any clock lookups or similar in the new drivers.

Initially, I thought consistency in device naming would be important,
since Tegra works with and without device-tree, but I guess we'll be able
to turn off the hard-coded board files soon, so device name consistency
probably isn't too relevant.

I'll drop this patch.

-- 
nvpublic

