Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112Ab1JNQCP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 12:02:15 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:58238 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753391Ab1JNQCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 12:02:13 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19MxROZsy5fbPjqAheorfLK
Date: Fri, 14 Oct 2011 09:02:09 -0700
From: Tony Lindgren <tony@atomide.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        "Cousson, Benoit" <b-cousson@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] initial omap DT support for v3.2 merge window (Re:
 [PATCH 26/30] ARM: omap: add board autoselection)
Message-ID: <20111014160209.GA27515@atomide.com>
References: <1317566760-25681-1-git-send-email-arnd@arndb.de>
 <201110040944.13205.arnd@arndb.de>
 <20111004155752.GT6324@atomide.com>
 <2340307.S2RzXdHlIz@wuerfel>
 <20111005010550.GX6324@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111005010550.GX6324@atomide.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd,

* Tony Lindgren <tony@atomide.com> [111004 17:32]:
> * Arnd Bergmann <arnd@arndb.de> [111004 11:55]:
> > On Tuesday 04 October 2011 08:57:52 Tony Lindgren wrote:
> > > * Arnd Bergmann <arnd@arndb.de> [111004 00:10]:
> > > > On Monday 03 October 2011, Tony Lindgren wrote:
> > > >
> > > > > Yes please leave out the list so we don't need to constantly update it.
> > > > > Let's just always build in MACH_OMAP_GENERIC.
> > > > 
> > > > That's what I had initially, but now that board file has become
> > > > omap2-specific and no longer works on omap3-only or omap4-only
> > > > configurations.
> > > 
> > > Will send a pull request for basic DT bootstrap support from Benoit
> > > that fixes that. So maybe let's sort that out first, then always
> > > select it?
> > 
> > Yes, sounds good. That is certainly the better solution in the long run.
> 
> Here you are. We had to rebase it earlier today because of the
> SOB update in fixes branch for the musb related fix that's needed
> here to avoid a merge conflict.
> 
> This series pretty much depends and conflicts with all the ealier
> branches, so I created a new dt-base branch to deal with the merge
> conflicts. If you prefer some other base, please let me know.
> 
> If you prefer to build some other merge base yourself, see the
> attached patch that's needed to avoid two build warnings after
> merging the various base branches together.
> 
> The dt-base I did is a merge of cleanup-part3, voltage, dmtimer
> and l3 into fixes. You may not yet have l3 and fixes pulled in,
> I sent pull requests for those yesterday. The others you have
> already pulled I believe.
> 
> Despite using the merge base this will cause a minor merge conflict
> in board-generic.c with Nicolas Pitre's earlier patch titled
> "ARM: mach-omap2: convert boot_params to atag_offset". The 
> atag_offset can be just left out, as the default will work.

Ping, any news on merging these? It would be nice to get these out of
the way so we have something to base other branches on without having
constant merge conflicts.
 
> Regards,
> 
> Tony
> 
> 
> The following changes since commit c541c15fb5ab48c47bc9b90121538fd30d152f23:
>   Tony Lindgren (1):
>         Merge branches 'cleanup-part3', 'voltage', 'dmtimer' and 'l3' into dt-base
> 
> are available in the git repository at:
> 
>   git://github.com/tmlind/linux.git dt
> 
> Benoit Cousson (18):
>       ARM: OMAP3: beagle-board: Use the omap_hwmod_name_get_dev API
>       ARM: OMAP2+: pm: Use hwmod name instead of dev pointer
>       ARM: OMAP2+: pm: Remove static devices variable for mpu, dsp, iva and l3 PM
>       ARM: OMAP: omap_device: Create a default omap_device_pm_latency
>       ARM: OMAP2+: devices: Remove all omap_device_pm_latency structures
>       of: Add helpers to get one string in multiple strings property
>       ARM: OMAP: omap_device: Add omap_device_[alloc|delete] for DT integration
>       ARM: OMAP: omap_device: Add a method to build an omap_device from a DT node
>       arm/dts: Add initial device tree support for OMAP4 SoC
>       arm/dts: Add support for OMAP4 PandaBoard
>       arm/dts: Add support for OMAP4 SDP board
>       arm/dts: Add initial device tree support for OMAP3 SoC
>       arm/dts: Add support for OMAP3 Beagle board
>       ARM: OMAP2+: board-generic: Add DT support to generic board
>       ARM: OMAP2+: board-generic: Add i2c static init
>       ARM: OMAP2+: l3-noc: Add support for device-tree
>       arm/dts: OMAP4: Add a main ocp entry bound to l3-noc driver
>       arm/dts: OMAP3+: Add mpu, dsp and iva nodes
> 
> Nishanth Menon (1):
>       ARM: OMAP: omap_device: Add omap_device_get_by_hwmod_name
> 
> Tony Lindgren (1):
>       Merge branch 'for_3.2/3_omap_devicetree' of git://gitorious.org/omap-pm/linux into dt
> 
>  Documentation/devicetree/bindings/arm/omap/dsp.txt |   14 +
>  Documentation/devicetree/bindings/arm/omap/iva.txt |   19 ++
>  .../devicetree/bindings/arm/omap/l3-noc.txt        |   19 ++
>  Documentation/devicetree/bindings/arm/omap/mpu.txt |   27 ++
>  .../devicetree/bindings/arm/omap/omap.txt          |   43 +++
>  arch/arm/boot/dts/omap3-beagle.dts                 |   29 ++
>  arch/arm/boot/dts/omap3.dtsi                       |   63 ++++
>  arch/arm/boot/dts/omap4-panda.dts                  |   29 ++
>  arch/arm/boot/dts/omap4-sdp.dts                    |   29 ++
>  arch/arm/boot/dts/omap4.dtsi                       |  103 +++++++
>  arch/arm/mach-omap2/Kconfig                        |    8 +-
>  arch/arm/mach-omap2/board-generic.c                |  156 ++++++++---
>  arch/arm/mach-omap2/board-omap3beagle.c            |    4 +-
>  arch/arm/mach-omap2/devices.c                      |   51 +---
>  arch/arm/mach-omap2/display.c                      |   11 +-
>  arch/arm/mach-omap2/dma.c                          |   11 +-
>  arch/arm/mach-omap2/gpio.c                         |   12 +-
>  arch/arm/mach-omap2/hsmmc.c                        |   18 +-
>  arch/arm/mach-omap2/hwspinlock.c                   |   12 +-
>  arch/arm/mach-omap2/mcbsp.c                        |   11 +-
>  arch/arm/mach-omap2/omap_l3_noc.c                  |   25 ++-
>  arch/arm/mach-omap2/pm.c                           |   72 ++---
>  arch/arm/mach-omap2/serial.c                       |   25 +--
>  arch/arm/mach-omap2/sr_device.c                    |   11 +-
>  arch/arm/mach-omap2/usb-musb.c                     |   11 +-
>  arch/arm/plat-omap/i2c.c                           |   10 +-
>  arch/arm/plat-omap/include/plat/omap_device.h      |    1 +
>  arch/arm/plat-omap/omap_device.c                   |  313 +++++++++++++++++---
>  drivers/of/base.c                                  |   84 ++++++
>  include/linux/of.h                                 |   18 ++
>  30 files changed, 929 insertions(+), 310 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/arm/omap/dsp.txt
>  create mode 100644 Documentation/devicetree/bindings/arm/omap/iva.txt
>  create mode 100644 Documentation/devicetree/bindings/arm/omap/l3-noc.txt
>  create mode 100644 Documentation/devicetree/bindings/arm/omap/mpu.txt
>  create mode 100644 Documentation/devicetree/bindings/arm/omap/omap.txt
>  create mode 100644 arch/arm/boot/dts/omap3-beagle.dts
>  create mode 100644 arch/arm/boot/dts/omap3.dtsi
>  create mode 100644 arch/arm/boot/dts/omap4-panda.dts
>  create mode 100644 arch/arm/boot/dts/omap4-sdp.dts
>  create mode 100644 arch/arm/boot/dts/omap4.dtsi

> --- a/arch/arm/mach-omap2/timer.c
> +++ b/arch/arm/mach-omap2/timer.c
> @@ -434,7 +434,7 @@ static int __init omap_timer_init(struct omap_hwmod *oh, void *unused)
>  	int ret = 0;
>  	char *name = "omap_timer";
>  	struct dmtimer_platform_data *pdata;
> -	struct omap_device *od;
> +	struct platform_device *pdev;
>  	struct omap_timer_capability_dev_attr *timer_dev_attr;
>  	struct powerdomain *pwrdm;
>  
> @@ -476,12 +476,12 @@ static int __init omap_timer_init(struct omap_hwmod *oh, void *unused)
>  #ifdef CONFIG_PM
>  	pdata->get_context_loss_count = omap_pm_get_dev_context_loss_count;
>  #endif
> -	od = omap_device_build(name, id, oh, pdata, sizeof(*pdata),
> +	pdev = omap_device_build(name, id, oh, pdata, sizeof(*pdata),
>  			omap2_dmtimer_latency,
>  			ARRAY_SIZE(omap2_dmtimer_latency),
>  			0);
>  
> -	if (IS_ERR(od)) {
> +	if (IS_ERR(pdev)) {
>  		pr_err("%s: Can't build omap_device for %s: %s.\n",
>  			__func__, name, oh->name);
>  		ret = -EINVAL;
> --- a/arch/arm/mach-omap2/usb-musb.c
> +++ b/arch/arm/mach-omap2/usb-musb.c
> @@ -115,7 +115,6 @@ static struct omap_musb_board_data musb_default_board_data = {
>  void __init usb_musb_init(struct omap_musb_board_data *musb_board_data)
>  {
>  	struct omap_hwmod		*oh;
> -	struct omap_device		*od;
>  	struct platform_device		*pdev;
>  	struct device			*dev;
>  	int				bus_id = -1;
> @@ -145,22 +144,20 @@ void __init usb_musb_init(struct omap_musb_board_data *musb_board_data)
>  		name = "musb-omap2430";
>  	}
>  
> -	oh = omap_hwmod_lookup(oh_name);
> -	if (!oh) {
> -		pr_err("Could not look up %s\n", oh_name);
> -		return;
> -	}
> +        oh = omap_hwmod_lookup(oh_name);
> +        if (WARN(!oh, "%s: could not find omap_hwmod for %s\n",
> +                 __func__, oh_name))
> +                return;
>  
> -	od = omap_device_build(name, bus_id, oh, &musb_plat,
> +	pdev = omap_device_build(name, bus_id, oh, &musb_plat,
>  			       sizeof(musb_plat), omap_musb_latency,
>  			       ARRAY_SIZE(omap_musb_latency), false);
> -	if (IS_ERR(od)) {
> +	if (IS_ERR(pdev)) {
>  		pr_err("Could not build omap_device for %s %s\n",
>  						name, oh_name);
>  		return;
>  	}
>  
> -	pdev = &od->pdev;
>  	dev = &pdev->dev;
>  	get_device(dev);
>  	dev->dma_mask = &musb_dmamask;

