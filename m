Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755189Ab2JKH2a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 03:28:30 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:62120 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752905Ab2JKH23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 03:28:29 -0400
Date: Thu, 11 Oct 2012 08:28:24 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, arnd@arndb.de
Subject: Re: [PATCH 5/6] ARM: ux500: Enable SDI4 port on the u9540 when
 booting with Device Tree
Message-ID: <20121011072824.GQ9707@gmail.com>
References: <1349882335-6786-1-git-send-email-lee.jones@linaro.org>
 <1349882335-6786-6-git-send-email-lee.jones@linaro.org>
 <20121010190437.GU12801@game.jcrosoft.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20121010190437.GU12801@game.jcrosoft.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Oct 2012, Jean-Christophe PLAGNIOL-VILLARD wrote:

> On 16:18 Wed 10 Oct     , Lee Jones wrote:
> > Here we add the device node for the SDI4 (MMC) port to the u9540
> > Device Tree source file. This will allow successful probing of
> > the internal MMC storage device when booting with DT enabled.
> > 
> > Acked-by: Linus Walleij <linus.walleij@linaro.org>
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > ---
> >  arch/arm/boot/dts/u9540.dts |   12 +++++++++++-
> >  1 file changed, 11 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/arm/boot/dts/u9540.dts b/arch/arm/boot/dts/u9540.dts
> > index 28efe20..2dade76 100644
> > --- a/arch/arm/boot/dts/u9540.dts
> > +++ b/arch/arm/boot/dts/u9540.dts
> > @@ -21,7 +21,6 @@
> >  	};
> >  
> >  	soc-u9500 {
> > -
> why?

My OCD shining though. It's either this or I create a seperate patch
for it. I think sneaking it in here is better.

> >  		uart@80120000 {
> >  			status = "okay";
> >  		};
> > @@ -33,5 +32,16 @@
> >  		uart@80007000 {
> >  			status = "okay";
> >  		};
> > +
> > +		// On-board eMMC
> no c++ comment

Single line comments are perfectly valid in DTS(I) files.

See: Documentation/devicetree/booting-without-of.txt

> > +		sdi4_per2@80114000 {
> > +			arm,primecell-periphid = <0x10480180>;
> > +		        max-frequency = <50000000>;
> > +			bus-width = <8>;
> > +			mmc-cap-mmc-highspeed;
> > +			vmmc-supply = <&ab8500_ldo_aux2_reg>;
> you need add the pinctrl here

Pinctrl will come in time. We have a priority list.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
