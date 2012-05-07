Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755952Ab2EGJXy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 05:23:54 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:10089 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755497Ab2EGJXw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 05:23:52 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 07 May 2012 02:23:02 -0700
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: "arnd@arndb.de" <arnd@arndb.de>
CC: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "balbi@ti.com" <balbi@ti.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>,
        "ccross@android.com" <ccross@android.com>,
        "olof@lixom.net" <olof@lixom.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "ohad@wizery.com" <ohad@wizery.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "linville@tuxdriver.com" <linville@tuxdriver.com>,
        "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 7 May 2012 11:23:33 +0200
Subject: Re: [PATCHv5 1/3] ARM: tegra: Add Tegra AHB driver
Thread-Topic: [PATCHv5 1/3] ARM: tegra: Add Tegra AHB driver
Thread-Index: Ac0sMxQNpAaOYwW7QaevySJDPvUu0A==
Message-ID: <20120507.122333.2024326166703361049.hdoyu@nvidia.com>
References: <20120507074228.GK26481@n2100.arm.linux.org.uk><20120507.105254.1899925115243585929.hdoyu@nvidia.com><201205070859.29174.arnd@arndb.de>
In-Reply-To: <201205070859.29174.arnd@arndb.de>
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

From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCHv5 1/3] ARM: tegra: Add Tegra AHB driver
Date: Mon, 7 May 2012 10:59:28 +0200
Message-ID: <201205070859.29174.arnd@arndb.de>

> On Monday 07 May 2012, Hiroshi Doyu wrote:
> > > On Mon, May 07, 2012 at 09:43:45AM +0300, Hiroshi DOYU wrote:
> > > > diff --git a/drivers/Makefile b/drivers/Makefile
> > > > index 5870322..d97e2e2 100644
> > > > --- a/drivers/Makefile
> > > > +++ b/drivers/Makefile
> > > > @@ -18,7 +18,7 @@ obj-$(CONFIG_SFI)         += sfi/
> > > >  # PnP must come after ACPI since it will eventually need to check if acpi
> > > >  # was used and do nothing if so
> > > >  obj-$(CONFIG_PNP)          += pnp/
> > > > -obj-$(CONFIG_ARM_AMBA)             += amba/
> > > > +obj-$(CONFIG_ARM)          += amba/
> > > 
> > > NAK.  This makes amba only buildable for ARM which is not the intention.
> > > Other architectures do have Primecells.
> > 
> > What about the following?
> > 
> >  +obj-y         += amba/
> 
> Looks ok to me, but which problem are you trying to solve anyway? Tegra
> always enables ARM_AMBA, so AFAICT there is no difference between this
> and the original code.

Tegra doesn't enable ARM_AMBA and Tegra doesn't use the following
"drivers/amba/bus.c" right now. I needed to make this directory
available to ones without ARM_AMBA enabled.

drivers/amba/Makefile:

obj-$(CONFIG_ARM_AMBA)		+= bus.o
obj-$(CONFIG_TEGRA_AHB)		+= tegra-ahb.o
