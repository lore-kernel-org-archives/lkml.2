Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753780Ab2GJGDe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 02:03:34 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:13369 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752052Ab2GJGDb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 02:03:31 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 09 Jul 2012 23:03:31 -0700
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: Rajendra Nayak <rnayak@ti.com>, Kishon Vijay Abraham I <kishon@ti.com>
CC: "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "b-cousson@ti.com" <b-cousson@ti.com>,
        "tony@atomide.com" <tony@atomide.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "balbi@ti.com" <balbi@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "hvaibhav@ti.com" <hvaibhav@ti.com>
Date: Tue, 10 Jul 2012 11:33:23 +0530
Subject: RE: [PATCH v1 01/11] drivers: usb: otg: add a new driver for omap
 usb2 phy
Thread-Topic: [PATCH v1 01/11] drivers: usb: otg: add a new driver for omap
 usb2 phy
Thread-Index: Ac1eX4lJqNVWPCBvQFml9Nws/jJ5KQAAHYsQ
Message-ID: <D958900912E20642BCBC71664EFECE3E6DDAD9FF96@BGMAIL02.nvidia.com>
References: <1340884267-28908-1-git-send-email-kishon@ti.com>
 <1340884267-28908-2-git-send-email-kishon@ti.com> <4FFBC1D0.5030506@ti.com>
In-Reply-To: <4FFBC1D0.5030506@ti.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +
> > +#ifdef CONFIG_PM

Should it not be CONFIG_PM_SLEEP instead of just CONFIG_PM? 

> > +
> > +static int omap_usb2_runtime_suspend(struct device *dev)
> > +{
> > +	struct platform_device	*pdev = to_platform_device(dev);
> > +	struct omap_usb	*phy = platform_get_drvdata(pdev);
> > +


> > +static int __init usb2_omap_init(void)
> > +{
> > +	return platform_driver_register(&omap_usb2_driver);
> > +}
> > +arch_initcall(usb2_omap_init);
> > +
> > +static void __exit usb2_omap_exit(void)
> > +{
> > +	platform_driver_unregister(&omap_usb2_driver);
> > +}
> > +module_exit(usb2_omap_exit);
> > +

Do you really need arch_initcall here?
If not, then you can replace above two function calls with module_platform_driver().

> > +MODULE_ALIAS("platform: omap_usb2");
> > +MODULE_AUTHOR("Texas Instruments Inc.");
> > +MODULE_DESCRIPTION("OMAP USB2 PHY DRIVER");
