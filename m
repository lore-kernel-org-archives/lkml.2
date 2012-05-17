Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933492Ab2EQQoU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 12:44:20 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40607 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933414Ab2EQQoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 12:44:18 -0400
Date: Thu, 17 May 2012 18:44:12 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Rob Lee <rob.lee@linaro.org>
Cc: kernel@pengutronix.de, shawn.guo@linaro.org,
        u.kleine-koenig@pengutronix.de, richard.zhao@freescale.com,
        amit.kucheria@linaro.org, daniel.lezcano@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org, jj@chaosbits.net
Subject: Re: [PATCH v4 4/7] ARM: imx: Enable imx53 low power idle
Message-ID: <20120517164412.GB30400@pengutronix.de>
References: <1337135616-8988-1-git-send-email-rob.lee@linaro.org>
 <1337135616-8988-5-git-send-email-rob.lee@linaro.org>
 <20120516174740.GW30400@pengutronix.de>
 <CAMXH7KGBK=FkggQxJBaNZ-CZDQm=bV9ZtuB3Yf6vykR5FULA8A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMXH7KGBK=FkggQxJBaNZ-CZDQm=bV9ZtuB3Yf6vykR5FULA8A@mail.gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 18:41:33 up 187 days, 28 min, 16 users,  load average: 0.00, 0.01,
 0.05
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2012 at 09:46:21AM -0500, Rob Lee wrote:
> On Wed, May 16, 2012 at 12:47 PM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> >>
> >> +void __init imx5_init_late(void)
> >> +{
> >> +     imx5_pm_init();
> >> +}
> >> +
> >>  void __init imx51_init_late(void)
> >>  {
> >>       mx51_neon_fixup();
> >> -     imx5_pm_init();
> >> +     imx5_init_late();
> >>  }
> >
> > Where would you add i.MX53 specific code above? Hint: imx5_init_late is
> > the wrong function name.
> 
> I added imx5_init_late for late_init functionality that is common
> among all imx5.  For example, in the future imx50 may use it as well.
> But I can remove this and repeat the imx5_pm_init() calls for each
> platform if you prefer that.

The point is that the init_late callback should have a imx53_* name,
otherwise if you call it imx5_* there is no place to add imx53 only
functionality. You can always call imx5 specific things from imx53
context, but not the other way round.

Sascha


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
