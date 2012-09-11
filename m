Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759081Ab2IKL16 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 07:27:58 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:33195 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759001Ab2IKL14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 07:27:56 -0400
Date: Tue, 11 Sep 2012 07:29:05 -0400
From: Matt Porter <mporter@ti.com>
To: "Hiremath, Vaibhav" <hvaibhav@ti.com>
Cc: Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Cousson, Benoit" <b-cousson@ti.com>
Subject: Re: [PATCH] ARM: dts: AM33XX: fix gpio node numbering to match
 hardware
Message-ID: <20120911112905.GM27758@beef>
References: <1347294020-22661-1-git-send-email-mporter@ti.com>
 <79CD15C6BA57404B839C016229A409A83EAB03D3@DBDE01.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <79CD15C6BA57404B839C016229A409A83EAB03D3@DBDE01.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 11, 2012 at 04:57:08AM +0000, Hiremath, Vaibhav wrote:
> On Mon, Sep 10, 2012 at 21:50:20, Porter, Matt wrote:
> > On AM33xx, the datasheet and TRM refer to four GPIO instances that
> > are 0-based, GPIO0-3.
> > 
> 
> Thanks Matt,
> I think Anil labeled it as gpio1-4 due to hwmod naming convention, as you 
> can not have gpioo id = 0 (refer to arch/arm/mach-omap2/gpio.c).

Right, and that convention originally came from the assumption that
everything would be 1-based like OMAP3/4.
 
> But in case of DT we should simply follow TRM/Spec, as naming convention is 
> based on base-addr and not id, so your patch looks good me.

Yes, my biggest concern here was the coming frustration that the end
"user" or system integrator would have with these labels not matching
the docs that have been around for a year. It would be !sane to have
somebody look at a schematic and then write their dts with a value that
doesn't match the h/w. That would run counter to the fundamental
requirement that DT is a description of the hardware. The user led patch
was already the first example of that where the comments mentioned gpio1
in the pinmux data but the data referenced the gpio2 label.

-Matt

> > Signed-off-by: Matt Porter <mporter@ti.com>
> > ---
> >  arch/arm/boot/dts/am33xx.dtsi |    8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> > 
> > diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
> > index bb31bff..1369bfc 100644
> > --- a/arch/arm/boot/dts/am33xx.dtsi
> > +++ b/arch/arm/boot/dts/am33xx.dtsi
> > @@ -62,7 +62,7 @@
> >  			reg = <0x48200000 0x1000>;
> >  		};
> >  
> > -		gpio1: gpio@44e07000 {
> > +		gpio0: gpio@44e07000 {
> >  			compatible = "ti,omap4-gpio";
> >  			ti,hwmods = "gpio1";
> >  			gpio-controller;
> > @@ -74,7 +74,7 @@
> >  			interrupts = <96>;
> >  		};
> >  
> > -		gpio2: gpio@4804c000 {
> > +		gpio1: gpio@4804c000 {
> >  			compatible = "ti,omap4-gpio";
> >  			ti,hwmods = "gpio2";
> >  			gpio-controller;
> > @@ -86,7 +86,7 @@
> >  			interrupts = <98>;
> >  		};
> >  
> > -		gpio3: gpio@481ac000 {
> > +		gpio2: gpio@481ac000 {
> >  			compatible = "ti,omap4-gpio";
> >  			ti,hwmods = "gpio3";
> >  			gpio-controller;
> > @@ -98,7 +98,7 @@
> >  			interrupts = <32>;
> >  		};
> >  
> > -		gpio4: gpio@481ae000 {
> > +		gpio3: gpio@481ae000 {
> >  			compatible = "ti,omap4-gpio";
> >  			ti,hwmods = "gpio4";
> >  			gpio-controller;
> > -- 
> > 1.7.9.5
> > 
> > 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
