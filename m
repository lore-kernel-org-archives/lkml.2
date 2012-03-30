Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760594Ab2C3JvK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 05:51:10 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53459 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760577Ab2C3JvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 05:51:03 -0400
Date: Fri, 30 Mar 2012 11:50:24 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        kernel@pengutronix.de, Andrew Victor <linux@maxim.org.za>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Russell King <linux@arm.linux.org.uk>, Sekhar Nori <nsekhar@ti.com>,
        Kevin Hilman <khilman@ti.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Lennert Buytenhek <kernel@wantstofly.org>,
        Nicolas Pitre <nico@fluxnic.net>, Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Tony Lindgren <tony@atomide.com>, Barry Song <baohua.song@csr.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        linux-arm-kernel@lists.infradead.org,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-samsung-soc@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH 03/17] ARM: mark const init data with __initconst instead
 of __initdata
Message-ID: <20120330095024.GS15647@pengutronix.de>
References: <20120329211131.GA31250@pengutronix.de>
 <1333055554-31300-3-git-send-email-u.kleine-koenig@pengutronix.de>
 <20120330061134.GD3254@S2101-09.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120330061134.GD3254@S2101-09.ap.freescale.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Shawn,

On Fri, Mar 30, 2012 at 02:11:36PM +0800, Shawn Guo wrote:
> On Thu, Mar 29, 2012 at 11:12:20PM +0200, Uwe Kleine-König wrote:
> ...
> > diff --git a/arch/arm/mach-imx/imx51-dt.c b/arch/arm/mach-imx/imx51-dt.c
> > index 5cca573..7e00748 100644
> > --- a/arch/arm/mach-imx/imx51-dt.c
> > +++ b/arch/arm/mach-imx/imx51-dt.c
> > @@ -102,7 +102,7 @@ static struct sys_timer imx51_timer = {
> >  	.init = imx51_timer_init,
> >  };
> >  
> > -static const char *imx51_dt_board_compat[] __initdata = {
> > +static const char *imx51_dt_board_compat[] __initconst = {
> >  	"fsl,imx51-babbage",
> >  	"fsl,imx51",
> >  	NULL
> 
>   CC      arch/arm/mach-imx/imx51-dt.o
> arch/arm/mach-imx/imx51-dt.c:105:20: error: imx51_dt_board_compat causes a section type conflict
> make[2]: *** [arch/arm/mach-imx/imx51-dt.o] Error 1
> 
> I do not understand why though.
that's because the strings are constant, but the array is not. The fix
is:

-static const char *imx51_dt_board_compat[] __initconst = {
+static const char *const imx51_dt_board_compat[] __initconst = {

or keeping __initdata.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
