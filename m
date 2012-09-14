Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759341Ab2INJXn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 05:23:43 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:34136 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759327Ab2INJXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 05:23:40 -0400
Date: Fri, 14 Sep 2012 10:23:35 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de
Subject: Re: [PATCH 06/19] ARM: ux500: Add nodes for the MSP into the HREF
 Device Tree
Message-ID: <20120914092332.GL3374@gmail.com>
References: <1347016499-29354-1-git-send-email-lee.jones@linaro.org>
 <1347016499-29354-7-git-send-email-lee.jones@linaro.org>
 <CACRpkdbs9_hLB9c7WbWeR_6+Le4Svzc9Y5wTNVebOiRDB-o33g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdbs9_hLB9c7WbWeR_6+Le4Svzc9Y5wTNVebOiRDB-o33g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2012 at 02:53:45AM -0700, Linus Walleij wrote:
> On Fri, Sep 7, 2012 at 1:14 PM, Lee Jones <lee.jones@linaro.org> wrote:
> 
> > This patch enables the two important MSP devices for ST-Ericsson's
> > hardware reference development board.
> >
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > ---
> >  arch/arm/boot/dts/hrefv60plus.dts |    8 ++++++++
> >  1 file changed, 8 insertions(+)
> >
> > diff --git a/arch/arm/boot/dts/hrefv60plus.dts b/arch/arm/boot/dts/hrefv60plus.dts
> > index 62b2ac1..4f0aee8 100644
> > --- a/arch/arm/boot/dts/hrefv60plus.dts
> > +++ b/arch/arm/boot/dts/hrefv60plus.dts
> > @@ -77,5 +77,13 @@
> >
> >                         status = "okay";
> >                 };
> > +
> > +               msp1: msp@80124000 {
> > +                       status = "okay";
> > +               };
> > +
> > +               msp3: msp@80125000 {
> > +                       status = "okay";
> > +               };
> >         };
> >  };
> 
> Does this really "enable" the MSPs as the title claims?

Yes they do.

> Aren's there any kind of bindings needed, not even a
> register base?

All that information is in the "disabled" node contained in .dtsi file.

+               msp0: msp@80123000 {
+                       compatible = "stericsson,ux500-msp-i2s";
+                       reg = <0x80123000 0x1000>;
+                       interrupts = <0 31 0x4>;
+                       v-ape-supply = <&db8500_vape_reg>;
+                       status = "disabled";

Then this patch "enable"s it (as the title suggests). :)

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
