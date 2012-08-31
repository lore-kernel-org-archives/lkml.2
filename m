Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753003Ab2HaNH2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 09:07:28 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50091 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448Ab2HaNH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 09:07:27 -0400
Date: Fri, 31 Aug 2012 15:07:23 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org,
        HACHIMI Samir <shachimi@adeneo-embedded.com>,
        thierry.reding@avionic-design.de, linux-kernel@vger.kernel.org,
        =?iso-8859-15?Q?Beno=EEt_Th=E9baudeau?= 
	<benoit.thebaudeau@advansee.com>
Subject: Re: [PATCH 8/9] ARM i.MX53: Add pwms to dtsi
Message-ID: <20120831130723.GS26594@pengutronix.de>
References: <1346154504-5623-1-git-send-email-s.hauer@pengutronix.de>
 <1346154504-5623-9-git-send-email-s.hauer@pengutronix.de>
 <20120830223219.GF3613@r65073-Latitude-D630>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120830223219.GF3613@r65073-Latitude-D630>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 15:05:43 up 69 days,  4:17, 85 users,  load average: 0.43, 0.37,
 0.46
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 31, 2012 at 06:32:20AM +0800, Shawn Guo wrote:
> On Tue, Aug 28, 2012 at 01:48:23PM +0200, Sascha Hauer wrote:
> > Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> > 
> > Conflicts:
> > 	arch/arm/mach-imx/clk-imx51-imx53.c
> 
> Yeah, I know you have sorted out conflicts :)

:)

> 
> > ---
> >  arch/arm/boot/dts/imx53.dtsi        |   14 ++++++++++++++
> >  arch/arm/mach-imx/clk-imx51-imx53.c |    4 ++++
> >  2 files changed, 18 insertions(+)
> > 
> > diff --git a/arch/arm/boot/dts/imx53.dtsi b/arch/arm/boot/dts/imx53.dtsi
> > index cd37165..7ec17e4 100644
> > --- a/arch/arm/boot/dts/imx53.dtsi
> > +++ b/arch/arm/boot/dts/imx53.dtsi
> > @@ -189,6 +189,20 @@
> >  				status = "disabled";
> >  			};
> >  
> > +			pwm1: pwm@53fb4000 {
> > +				#pwm-cells = <3>;
> 
> pwm-cells should be 2?

Yes, right. We have a patch internally that allows us to pass a
'inverted' flag to the pwm, hence I accidently have 3 here.

> >  	clk_register_clkdev(clk[ssi1_ipg_gate], NULL, "63fcc000.ssi");
> >  	clk_register_clkdev(clk[ssi2_ipg_gate], NULL, "50014000.ssi");
> >  	clk_register_clkdev(clk[ssi3_ipg_gate], NULL, "63fd0000.ssi");
> > +	clk_register_clkdev(clk[pwm1_ipg_gate], "ipg", "53fb4000.pwm");
> > +	clk_register_clkdev(clk[pwm1_hf_gate], "per", "53fb4000.pwm");
> > +	clk_register_clkdev(clk[pwm2_ipg_gate], "ipg", "53fb8000.pwm");
> > +	clk_register_clkdev(clk[pwm2_hf_gate], "per", "53fb8000.pwm");
> 
> It should be in a separate patch?

Should it? Surely I can do this, I had the feeling though that it
belongs together.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
