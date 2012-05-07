Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937Ab2EGGHR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 02:07:17 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:10187 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820Ab2EGGHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 02:07:15 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Sun, 06 May 2012 23:06:22 -0700
Date: Mon, 7 May 2012 09:06:19 +0300
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "balbi@ti.com" <balbi@ti.com>, "arnd@arndb.de" <arnd@arndb.de>,
        "ccross@android.com" <ccross@android.com>,
        "olof@lixom.net" <olof@lixom.net>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "ohad@wizery.com" <ohad@wizery.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "linville@tuxdriver.com" <linville@tuxdriver.com>,
        "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCHv3 1/4] ARM: tegra: Add Tegra AHB driver
Message-ID: <20120507090619.90932b9f67a4b672abeb887f@nvidia.com>
In-Reply-To: <4FA40878.7070709@wwwdotorg.org>
References: <1336061147-10245-1-git-send-email-hdoyu@nvidia.com>
	<4FA2C34F.5060406@wwwdotorg.org>
	<20120504.091736.839941449020176796.hdoyu@nvidia.com>
	<4FA40878.7070709@wwwdotorg.org>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 May 2012 18:48:56 +0200
Stephen Warren <swarren@wwwdotorg.org> wrote:

> On 05/04/2012 12:17 AM, Hiroshi Doyu wrote:
> > Stephen Warren wrote at Thu, 3 May 2012 19:41:35 +0200:
> >> On 05/03/2012 10:05 AM, Hiroshi DOYU wrote:
> >>> Tegra AHB Bus conforms to the AMBA Specification (Rev 2.0) Advanced
> >>> High-performance Bus (AHB) architecture.
> ...
> >>> +static int __init tegra_ahb_module_init(void)
> >>> +{
> >>> +	return platform_driver_register(&tegra_ahb_driver);
> >>> +}
> >>> +postcore_initcall(tegra_ahb_module_init);
> >>
> >> Can this be a module_init() instead of postcore_initcall()?
> > 
> > Since this driver configures prefetch size from AHB client devices,
> > it's better to make this driver available before other AHB client
> > drivers get ready. So "postcore_initcall()" seems to make sense if
> > there's no other better initcall.
> 
> I believe this only affects when the driver is registered and has no
> influence over when the device itself is probed.
> 
> When booting with board files rather than DT, it was possible to
> register drivers and platform devices early using various initcalls to
> control the order. However, with DT, I believe all the devices are
> instantiated from DT at the same time (well, one by one in whatever
> order as the DT is parsed), so the time when the driver is registered
> isn't relevant.
> 
> So, if the other AHB devices really need this AHB driver to initialize
> first, you'd better move all the AHB devices inside the AHB node in DT,
> so that the AHB driver can influence when the children get probed.
> Still, I'd suggest leaving that to a later patch, since everything
> clearly works fine right now without this driver even existing.

Ok, I'll use module_platform_driver(tegra_ahb_driver). These order would be revisited.
