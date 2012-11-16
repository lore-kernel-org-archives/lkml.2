Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191Ab2KPRck (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 12:32:40 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:59627 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665Ab2KPRcj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 12:32:39 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Shawn Guo <shawn.guo@linaro.org>, Fabio Estevam <festevam@gmail.com>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <20121116070543.GD2941@S2100-06.ap.freescale.net>
Cc: <rob.herring@calxeda.com>, <linux-kernel@vger.kernel.org>,
        Fabio Estevam <fabio.estevam@freescale.com>
References: <1348332895-26966-1-git-send-email-festevam@gmail.com>
 <20121116070543.GD2941@S2100-06.ap.freescale.net>
Message-ID: <20121116173234.7155.55790@nucleus>
User-Agent: alot/0.3.2+
Subject: Re: [PATCH] clk: mxs: Use a better name for the USB PHY clock
Date: Fri, 16 Nov 2012 09:32:34 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Shawn Guo (2012-11-15 23:05:45)
> On Sat, Sep 22, 2012 at 01:54:55PM -0300, Fabio Estevam wrote:
> > From: Fabio Estevam <fabio.estevam@freescale.com>
> > 
> > Use a better name for the USB PHY clock.
> > 
> > Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
> 
> Mike,
> 
> I was planning send a pull-request to you with all mxs clock patches
> collected for 3.8.  It turns out this is the only one I queued for
> this cycle.  I do not bother to send you a pull-request containing
> single patch, so can you please just apply it for 3.8?  Thanks.
> 

I've taken the patch into clk-next.  I added your S-O-B since this is a
one-patch pull request ;-)

Thanks,
Mike

> Shawn
> 
> > ---
> >  .../devicetree/bindings/clock/imx23-clock.txt      |    2 +-
> >  .../devicetree/bindings/clock/imx28-clock.txt      |    4 ++--
> >  drivers/clk/mxs/clk-imx23.c                        |    6 +++---
> >  drivers/clk/mxs/clk-imx28.c                        |   10 +++++-----
> >  4 files changed, 11 insertions(+), 11 deletions(-)
> > 
> > diff --git a/Documentation/devicetree/bindings/clock/imx23-clock.txt b/Documentation/devicetree/bindings/clock/imx23-clock.txt
> > index a0b867e..baadbb1 100644
> > --- a/Documentation/devicetree/bindings/clock/imx23-clock.txt
> > +++ b/Documentation/devicetree/bindings/clock/imx23-clock.txt
> > @@ -52,7 +52,7 @@ clocks and IDs.
> >       lcdif           38
> >       etm             39
> >       usb             40
> > -     usb_pwr         41
> > +     usb_phy         41
> >  
> >  Examples:
> >  
> > diff --git a/Documentation/devicetree/bindings/clock/imx28-clock.txt b/Documentation/devicetree/bindings/clock/imx28-clock.txt
> > index aa2af28..52a49a4 100644
> > --- a/Documentation/devicetree/bindings/clock/imx28-clock.txt
> > +++ b/Documentation/devicetree/bindings/clock/imx28-clock.txt
> > @@ -73,8 +73,8 @@ clocks and IDs.
> >       can1            59
> >       usb0            60
> >       usb1            61
> > -     usb0_pwr        62
> > -     usb1_pwr        63
> > +     usb0_phy        62
> > +     usb1_phy        63
> >       enet_out        64
> >  
> >  Examples:
> > diff --git a/drivers/clk/mxs/clk-imx23.c b/drivers/clk/mxs/clk-imx23.c
> > index f00dffb..8dd476e 100644
> > --- a/drivers/clk/mxs/clk-imx23.c
> > +++ b/drivers/clk/mxs/clk-imx23.c
> > @@ -85,7 +85,7 @@ enum imx23_clk {
> >       cpu_xtal, hbus, xbus, lcdif_div, ssp_div, gpmi_div, emi_pll,
> >       emi_xtal, etm_div, saif_div, clk32k_div, rtc, adc, spdif_div,
> >       clk32k, dri, pwm, filt, uart, ssp, gpmi, spdif, emi, saif,
> > -     lcdif, etm, usb, usb_pwr,
> > +     lcdif, etm, usb, usb_phy,
> >       clk_max
> >  };
> >  
> > @@ -143,8 +143,8 @@ int __init mx23_clocks_init(void)
> >       clks[saif] = mxs_clk_gate("saif", "saif_div", SAIF, 31);
> >       clks[lcdif] = mxs_clk_gate("lcdif", "lcdif_div", PIX, 31);
> >       clks[etm] = mxs_clk_gate("etm", "etm_div", ETM, 31);
> > -     clks[usb] = mxs_clk_gate("usb", "usb_pwr", DIGCTRL, 2);
> > -     clks[usb_pwr] = clk_register_gate(NULL, "usb_pwr", "pll", 0, PLLCTRL0, 18, 0, &mxs_lock);
> > +     clks[usb] = mxs_clk_gate("usb", "usb_phy", DIGCTRL, 2);
> > +     clks[usb_phy] = clk_register_gate(NULL, "usb_phy", "pll", 0, PLLCTRL0, 18, 0, &mxs_lock);
> >  
> >       for (i = 0; i < ARRAY_SIZE(clks); i++)
> >               if (IS_ERR(clks[i])) {
> > diff --git a/drivers/clk/mxs/clk-imx28.c b/drivers/clk/mxs/clk-imx28.c
> > index 42978f1b..db3af08 100644
> > --- a/drivers/clk/mxs/clk-imx28.c
> > +++ b/drivers/clk/mxs/clk-imx28.c
> > @@ -140,7 +140,7 @@ enum imx28_clk {
> >       emi_xtal, lcdif_div, etm_div, ptp, saif0_div, saif1_div,
> >       clk32k_div, rtc, lradc, spdif_div, clk32k, pwm, uart, ssp0,
> >       ssp1, ssp2, ssp3, gpmi, spdif, emi, saif0, saif1, lcdif, etm,
> > -     fec, can0, can1, usb0, usb1, usb0_pwr, usb1_pwr, enet_out,
> > +     fec, can0, can1, usb0, usb1, usb0_phy, usb1_phy, enet_out,
> >       clk_max
> >  };
> >  
> > @@ -218,10 +218,10 @@ int __init mx28_clocks_init(void)
> >       clks[fec] = mxs_clk_gate("fec", "hbus", ENET, 30);
> >       clks[can0] = mxs_clk_gate("can0", "ref_xtal", FLEXCAN, 30);
> >       clks[can1] = mxs_clk_gate("can1", "ref_xtal", FLEXCAN, 28);
> > -     clks[usb0] = mxs_clk_gate("usb0", "usb0_pwr", DIGCTRL, 2);
> > -     clks[usb1] = mxs_clk_gate("usb1", "usb1_pwr", DIGCTRL, 16);
> > -     clks[usb0_pwr] = clk_register_gate(NULL, "usb0_pwr", "pll0", 0, PLL0CTRL0, 18, 0, &mxs_lock);
> > -     clks[usb1_pwr] = clk_register_gate(NULL, "usb1_pwr", "pll1", 0, PLL1CTRL0, 18, 0, &mxs_lock);
> > +     clks[usb0] = mxs_clk_gate("usb0", "usb0_phy", DIGCTRL, 2);
> > +     clks[usb1] = mxs_clk_gate("usb1", "usb1_phy", DIGCTRL, 16);
> > +     clks[usb0_phy] = clk_register_gate(NULL, "usb0_phy", "pll0", 0, PLL0CTRL0, 18, 0, &mxs_lock);
> > +     clks[usb1_phy] = clk_register_gate(NULL, "usb1_phy", "pll1", 0, PLL1CTRL0, 18, 0, &mxs_lock);
> >       clks[enet_out] = clk_register_gate(NULL, "enet_out", "pll2", 0, ENET, 18, 0, &mxs_lock);
> >  
> >       for (i = 0; i < ARRAY_SIZE(clks); i++)
> > -- 
> > 1.7.9.5
> >
