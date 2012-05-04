Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752615Ab2EDGRq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 02:17:46 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:13010 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193Ab2EDGRo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 02:17:44 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 03 May 2012 23:17:40 -0700
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>
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
Date: Fri, 4 May 2012 08:17:36 +0200
Subject: Re: [PATCHv3 1/4] ARM: tegra: Add Tegra AHB driver
Thread-Topic: [PATCHv3 1/4] ARM: tegra: Add Tegra AHB driver
Thread-Index: Ac0pvZp0XmqkYoGARXudf2BjCEqz/w==
Message-ID: <20120504.091736.839941449020176796.hdoyu@nvidia.com>
References: <1336061147-10245-1-git-send-email-hdoyu@nvidia.com><4FA2C34F.5060406@wwwdotorg.org>
In-Reply-To: <4FA2C34F.5060406@wwwdotorg.org>
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

From: Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: [PATCHv3 1/4] ARM: tegra: Add Tegra AHB driver
Date: Thu, 3 May 2012 19:41:35 +0200
Message-ID: <4FA2C34F.5060406@wwwdotorg.org>

> On 05/03/2012 10:05 AM, Hiroshi DOYU wrote:
> > Tegra AHB Bus conforms to the AMBA Specification (Rev 2.0) Advanced
> > High-performance Bus (AHB) architecture.
> > 
> > The AHB Arbiter controls AHB bus master arbitration. This effectively
> > forms a second level of arbitration for access to the memory
> > controller through the AHB Slave Memory device. The AHB pre-fetch
> > logic can be configured to enhance performance for devices doing
> > sequential access. Each AHB master is assigned to either the high or
> > low priority bin. Both Tegra20/30 have this AHB bus.
> > 
> > Some of configuration param could be passed from DT too.
> 
> > diff --git a/drivers/amba/tegra-ahb.c b/drivers/amba/tegra-ahb.c
> > +static u32 tegra_ahb_gizmo[] = {
> 
> const?

Yes.

> > +static int __init tegra_ahb_module_init(void)
> > +{
> > +	return platform_driver_register(&tegra_ahb_driver);
> > +}
> > +postcore_initcall(tegra_ahb_module_init);
> 
> Can this be a module_init() instead of postcore_initcall()?

Since this driver configures prefetch size from AHB client devices,
it's better to make this driver available before other AHB client
drivers get ready. So "postcore_initcall()" seems to make sense if
there's no other better initcall.

> > +
> > +static void __exit tegra_ahb_module_exit(void)
> > +{
> > +	platform_driver_unregister(&tegra_ahb_driver);
> > +}
> > +module_exit(tegra_ahb_module_exit);
> 
> If so, all of the previous two quoted chunks can be replaced with just:
> 
> module_platform_driver(tegra_ahb_module_init);
