Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752344Ab2DRJyx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 05:54:53 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58309 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425Ab2DRJyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 05:54:52 -0400
Date: Wed, 18 Apr 2012 11:54:47 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Rob Lee <rob.lee@linaro.org>
Cc: kernel@pengutronix.de, shawn.guo@linaro.org, linaro-dev@lists.linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        patches@linaro.org
Subject: Re: [PATCH] ARM: imx: Fix imx5 idle logic bug
Message-ID: <20120418095447.GP3852@pengutronix.de>
References: <1334619468-25680-1-git-send-email-rob.lee@linaro.org>
 <20120417081025.GN20478@pengutronix.de>
 <CAMXH7KH6rdaUCsJxdj2pU0HrJ5ash5em2PMfyZHKTw+01Z=5nQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMXH7KH6rdaUCsJxdj2pU0HrJ5ash5em2PMfyZHKTw+01Z=5nQ@mail.gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 11:54:33 up 157 days, 17:41, 94 users,  load average: 1.10, 0.92,
 0.68
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2012 at 09:11:32AM -0500, Rob Lee wrote:
> On Tue, Apr 17, 2012 at 3:10 AM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> > On Mon, Apr 16, 2012 at 06:37:48PM -0500, Robert Lee wrote:
> >> The imx5_idle() check of the tzic_eanble_wake() return value uses
> >> incorrect (inverted) logic causing all attempt to idle to fail.
> >>
> >
> > Does this have influence on current kernels or does this only trigger
> > with your cpuidle patches?
> 
> This influences non-cpuidle kernels also as imx5_idle is what
> arm_pm_idle points to for imx51.

Ok, Applied this one for -rc then

Sascha

> 
> >
> > Sascha
> >
> >> Signed-off-by: Robert Lee <rob.lee@linaro.org>
> >> ---
> >>  arch/arm/mach-imx/mm-imx5.c |    2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/arch/arm/mach-imx/mm-imx5.c b/arch/arm/mach-imx/mm-imx5.c
> >> index 05250ae..e10f391 100644
> >> --- a/arch/arm/mach-imx/mm-imx5.c
> >> +++ b/arch/arm/mach-imx/mm-imx5.c
> >> @@ -35,7 +35,7 @@ static void imx5_idle(void)
> >>       }
> >>       clk_enable(gpc_dvfs_clk);
> >>       mx5_cpu_lp_set(WAIT_UNCLOCKED_POWER_OFF);
> >> -     if (tzic_enable_wake() != 0)
> >> +     if (!tzic_enable_wake())
> >>               cpu_do_idle();
> >>       clk_disable(gpc_dvfs_clk);
> >>  }
> >> --
> >> 1.7.10
> >>
> >>
> >> _______________________________________________
> >> linux-arm-kernel mailing list
> >> linux-arm-kernel@lists.infradead.org
> >> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> >>
> >
> > --
> > Pengutronix e.K.                           |                             |
> > Industrial Linux Solutions                 | http://www.pengutronix.de/  |
> > Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
> > Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
