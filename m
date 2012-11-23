Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756045Ab2KWLNh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 06:13:37 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:57934 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755779Ab2KWLNe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 06:13:34 -0500
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
        "Bedia, Vaibhav" <vaibhav.bedia@ti.com>
Subject: RE: [PATCH v4 05/11] pwm: pwm-tiecap: pinctrl support
Thread-Topic: [PATCH v4 05/11] pwm: pwm-tiecap: pinctrl support
Thread-Index: AQHNx+n+ghztK6SWoUidSxrU/c+AZZf1/JEAgAEx05D//7Z5AIAAYKdw
Date: Fri, 23 Nov 2012 11:12:15 +0000
Deferred-Delivery: Fri, 23 Nov 2012 11:12:00 +0000
Message-ID: <518397C60809E147AF5323E0420B992E3E9EEAAA@DBDE01.ent.ti.com>
References: <1353503469-18634-1-git-send-email-avinashphilip@ti.com>
 <1353503469-18634-6-git-send-email-avinashphilip@ti.com>
 <20121122205944.GC16716@avionic-0098.adnet.avionic-design.de>
 <518397C60809E147AF5323E0420B992E3E9EE991@DBDE01.ent.ti.com>
 <20121123105110.GA6884@avionic-0098.adnet.avionic-design.de>
In-Reply-To: <20121123105110.GA6884@avionic-0098.adnet.avionic-design.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 23, 2012 at 16:21:10, Thierry Reding wrote:
> On Fri, Nov 23, 2012 at 10:34:02AM +0000, Philip, Avinash wrote:
> > On Fri, Nov 23, 2012 at 02:29:44, Thierry Reding wrote:
> > > On Wed, Nov 21, 2012 at 06:41:02PM +0530, Philip, Avinash wrote:
> > > [...]
> > > > +	pinctrl = devm_pinctrl_get_select_default(&pdev->dev);
> > > > +	if (IS_ERR(pinctrl))
> > > > +		dev_warn(&pdev->dev, "failed to configure pins from driver\n");
> > > 
> > > I think we already discussed this, but shouldn't this be a fatal error?
> > 
> > I had checked relevant discussion and found this can be warning message.
> > This is because most boards don't have pinctrl implemented at this point,
> > or may never have.
> > 
> > https://lkml.org/lkml/2012/9/11/369
> > 
> > Any way I will change to
> > dev_warn(&pdev->dev, "unable to select pin group\n");
> > as in other drivers.
> 
> But in case pinctrl isn't implemented, shouldn't the implementation of
> devm_pinctrl_get_select_default() just be a no-op?

So driver can still exist but pin mux functionality missing. Then warning
message will give hints.
I am also ok with error message & failure of driver with EPROBE_DEFER,
if you want?

Thanks
Avinash

> 
> Thierry
> 

