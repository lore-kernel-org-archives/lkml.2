Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933486Ab2GMR1T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 13:27:19 -0400
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:48648 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932277Ab2GMR1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 13:27:17 -0400
Date: Fri, 13 Jul 2012 10:27:04 -0700
From: Mike Turquette <mturquette@ti.com>
To: Rob Herring <robherring2@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: linux-next: manual merge of the clk tree with the arm-soc tree
Message-ID: <20120713172704.GO2772@gmail.com>
References: <20120713151451.b2ef97045ef2273ea15973c9@canb.auug.org.au>
 <50003A6F.5090008@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50003A6F.5090008@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20120713-10:10, Rob Herring wrote:
> 
> 
> On 07/13/2012 12:14 AM, Stephen Rothwell wrote:
> > Hi Mike,
> > 
> > Today's linux-next merge of the clk tree got a conflict in
> > drivers/clk/Makefile between commit 4a31bd28e86a ("ARM: nomadik: convert
> > to generic clock") from the arm-soc tree and commit 8d4d9f52081c ("clk:
> > add highbank clock support") from the clk tree.
> > 
> > Just context changes.  I fixed it up (see below) and can carry the fix as
> > necessary.
> > 
> > -- 
> > Cheers,
> > Stephen Rothwell                    sfr@canb.auug.org.au
> > 
> > diff --cc drivers/clk/Makefile
> > index 26b6b92,02ffdf6..0000000
> > --- a/drivers/clk/Makefile
> > +++ b/drivers/clk/Makefile
> > @@@ -3,6 -3,11 +3,12 @@@ obj-$(CONFIG_CLKDEV_LOOKUP)	+= clkdev.
> >   obj-$(CONFIG_COMMON_CLK)	+= clk.o clk-fixed-rate.o clk-gate.o \
> >   				   clk-mux.o clk-divider.o clk-fixed-factor.o
> >   # SoCs specific
> >  +obj-$(CONFIG_ARCH_NOMADIK)	+= clk-nomadik.o
> > + obj-$(CONFIG_ARCH_HIGHBANK)	+= clk-highbank.o
> >   obj-$(CONFIG_ARCH_MXS)		+= mxs/
> >   obj-$(CONFIG_PLAT_SPEAR)	+= spear/
> > + obj-$(CONFIG_ARCH_U300)		+= clk-u300.o
> > + obj-$(CONFIG_ARCH_INTEGRATOR)	+= versatile/
> 
> These should be sorted.
> 

Hi Rob,

Did something change in the arm-soc tree to resolve this conflict?
Nothing changed in clk-next.

Thanks,
Mike

> Rob
> 
> > + 
> > + # Chip specific
> > + obj-$(CONFIG_COMMON_CLK_WM831X) += clk-wm831x.o
