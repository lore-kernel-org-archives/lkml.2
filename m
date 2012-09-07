Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833Ab2IGR0U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 13:26:20 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59373 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088Ab2IGR0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 13:26:17 -0400
Date: Fri, 7 Sep 2012 19:26:12 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Shawn Guo <shawn.guo@linaro.org>, linux-arm-kernel@lists.infradead.org,
        HACHIMI Samir <shachimi@adeneo-embedded.com>,
        linux-kernel@vger.kernel.org,
        =?iso-8859-15?Q?Beno=EEt_Th=E9baudeau?= 
	<benoit.thebaudeau@advansee.com>
Subject: Re: [PATCH 8/9] ARM i.MX53: Add pwms to dtsi
Message-ID: <20120907172612.GU26594@pengutronix.de>
References: <1346154504-5623-1-git-send-email-s.hauer@pengutronix.de>
 <1346154504-5623-9-git-send-email-s.hauer@pengutronix.de>
 <20120830223219.GF3613@r65073-Latitude-D630>
 <20120831130723.GS26594@pengutronix.de>
 <20120907132955.GH29340@avionic-0098.mockup.avionic-design.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120907132955.GH29340@avionic-0098.mockup.avionic-design.de>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 19:14:18 up 76 days,  8:25, 42 users,  load average: 1.37, 1.32,
 1.23
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 07, 2012 at 03:29:55PM +0200, Thierry Reding wrote:
> On Fri, Aug 31, 2012 at 03:07:23PM +0200, Sascha Hauer wrote:
> > On Fri, Aug 31, 2012 at 06:32:20AM +0800, Shawn Guo wrote:
> > > On Tue, Aug 28, 2012 at 01:48:23PM +0200, Sascha Hauer wrote:
> [...]
> > > >  arch/arm/boot/dts/imx53.dtsi        |   14 ++++++++++++++
> > > >  arch/arm/mach-imx/clk-imx51-imx53.c |    4 ++++
> > > >  2 files changed, 18 insertions(+)
> > > > 
> > > > diff --git a/arch/arm/boot/dts/imx53.dtsi b/arch/arm/boot/dts/imx53.dtsi
> > > > index cd37165..7ec17e4 100644
> > > > --- a/arch/arm/boot/dts/imx53.dtsi
> > > > +++ b/arch/arm/boot/dts/imx53.dtsi
> > > > @@ -189,6 +189,20 @@
> > > >  				status = "disabled";
> > > >  			};
> > > >  
> > > > +			pwm1: pwm@53fb4000 {
> > > > +				#pwm-cells = <3>;
> > > 
> > > pwm-cells should be 2?
> > 
> > Yes, right. We have a patch internally that allows us to pass a
> > 'inverted' flag to the pwm, hence I accidently have 3 here.
> 
> There are patches in for-next that add support for setting the PWM
> polarity, though there's currently no support for specifying it via a
> third cell in the specifier. Would you mind sharing the patches that add
> this?

Yes, will do. I was afraid this leads to some discussion, so I skipped
them so far.

The basic idea was that the third cell is for flags from which bit0 set
means 'inverted'. We currently implemented this i.MX specific, but if
you think this is acceptable it's propably a good idea to implement this
in a generic manner.

Sascha



-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
