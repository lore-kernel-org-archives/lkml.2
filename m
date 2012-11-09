Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697Ab2KILBG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 06:01:06 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:51322 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752118Ab2KILA6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 06:00:58 -0500
From: "Philip, Avinash" <avinashphilip@ti.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: "paul@pwsan.com" <paul@pwsan.com>, "tony@atomide.com" <tony@atomide.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "Cousson, Benoit" <b-cousson@ti.com>,
        "Hiremath, Vaibhav" <hvaibhav@ti.com>,
        "AnilKumar, Chimata" <anilkumar@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        "Hebbar, Gururaja" <gururaja.hebbar@ti.com>,
        "Bedia, Vaibhav" <vaibhav.bedia@ti.com>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>
Subject: RE: [PATCH v2 08/10] pwm: pwm-tiehrpwm: Adding TBCLK gating support.
Thread-Topic: [PATCH v2 08/10] pwm: pwm-tiehrpwm: Adding TBCLK gating
 support.
Thread-Index: AQHNvYbt9l/dyWxaiEaI9tlgsbkSLJfgzEUAgACDSHA=
Date: Fri, 9 Nov 2012 10:59:30 +0000
Deferred-Delivery: Fri, 9 Nov 2012 10:48:00 +0000
Message-ID: <518397C60809E147AF5323E0420B992E3E9E4501@DBDE01.ent.ti.com>
References: <1352361197-27442-1-git-send-email-avinashphilip@ti.com>
 <1352361197-27442-9-git-send-email-avinashphilip@ti.com>
 <20121109081104.GB26007@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20121109081104.GB26007@avionic-0098.mockup.avionic-design.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.162.24]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 09, 2012 at 13:41:04, Thierry Reding wrote:
> On Thu, Nov 08, 2012 at 01:23:15PM +0530, Philip, Avinash wrote:
...
> > +	/* Some platforms require explicit tbclk gating */
> > +	if (of_property_read_bool(pdev->dev.of_node, "tbclkgating")) {
> 
> Is it really necessary to have an extra boolean property for this?
> Couldn't this just be handled by not defining a clock for the tbclk
> consumer in board setup/DT

If no clk node defined, driver can still continue expecting this platform 
the requirement is not there. So I will check for tbclk with devm_clk_get()
and continue by removing Boolean property.

> 
> > +		pc->tbclk = clk_get(&pdev->dev, "tbclk");
> 
> You should be using devm_clk_get() or add a matching clk_put() in
> .remove().

Ok

Thanks
Avinash

> 
> Thierry
> 

