Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605Ab2ECGkB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 02:40:01 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44695 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356Ab2ECGkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 02:40:00 -0400
Date: Thu, 3 May 2012 08:39:56 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Rob Lee <rob.lee@linaro.org>
Cc: kernel@pengutronix.de, shawn.guo@linaro.org, amit.kucheria@linaro.org,
        daniel.lezcano@linaro.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        patches@linaro.org, jj@chaosbits.net
Subject: Re: [PATCH v2 2/3] ARM: imx: Add imx5 cpuidle driver
Message-ID: <20120503063956.GE4141@pengutronix.de>
References: <1335924760-796-1-git-send-email-rob.lee@linaro.org>
 <1335924760-796-3-git-send-email-rob.lee@linaro.org>
 <20120502073331.GS4141@pengutronix.de>
 <CAMXH7KE1jao1p5ZQ1aw8p7qzOQUftck22QTMKJ1oGwiPhY=FMA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMXH7KE1jao1p5ZQ1aw8p7qzOQUftck22QTMKJ1oGwiPhY=FMA@mail.gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:38:28 up 172 days, 14:25, 37 users,  load average: 0.00, 0.02,
 0.05
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2012 at 03:11:35PM -0500, Rob Lee wrote:
> Sascha,
> 
> >>       mxc_iomux_v3_init(MX51_IO_ADDRESS(MX51_IOMUXC_BASE_ADDR));
> >>       mxc_arch_reset_init(MX51_IO_ADDRESS(MX51_WDOG1_BASE_ADDR));
> >> -     arm_pm_idle = imx5_idle;
> >> +     arm_pm_idle = (void *)imx5_idle;
> >
> > I don't like this. It will cover all warnings when the prototype of
> > arm_pm_idle changes in future. Better add a static void imx5_idle
> > which calls a static int imx5_do_idle, then you have an idle function
> > which returns an int.
> >
> 
> What about using the following:
> 
> arm_pm_idle =  (void (*)(void))imx5_idle;
> 
> This will give warnings if arm_pm_idle prototype changes.

This surely works but will look suspicious for people looking at the
code.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
