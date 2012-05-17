Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753749Ab2EQROz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 13:14:55 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:36493 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753163Ab2EQROx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 13:14:53 -0400
Date: Thu, 17 May 2012 19:14:44 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Rob Lee <rob.lee@linaro.org>
Cc: kernel@pengutronix.de, shawn.guo@linaro.org,
        u.kleine-koenig@pengutronix.de, richard.zhao@freescale.com,
        amit.kucheria@linaro.org, daniel.lezcano@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org, jj@chaosbits.net
Subject: Re: [PATCH v4 3/7] ARM: imx: clean and consolidate imx5 suspend and
 idle code
Message-ID: <20120517171444.GC30400@pengutronix.de>
References: <1337135616-8988-1-git-send-email-rob.lee@linaro.org>
 <1337135616-8988-4-git-send-email-rob.lee@linaro.org>
 <20120516173815.GV30400@pengutronix.de>
 <CAMXH7KFQvLC-tJRLR-3KqRZTY1=VG2me5HqLGzpo6Y4BnC2Dug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMXH7KFQvLC-tJRLR-3KqRZTY1=VG2me5HqLGzpo6Y4BnC2Dug@mail.gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 19:11:18 up 187 days, 58 min, 16 users,  load average: 1.00, 0.90,
 0.54
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2012 at 09:34:26AM -0500, Rob Lee wrote:
> On Wed, May 16, 2012 at 12:38 PM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> > Hi Robert,
> >
> > Overall this looks ok now, some comments inline.
> >
> >> +             return ret;
> >> +
> >> +     if (cpu_is_mx51())
> >> +             suspend_set_ops(&mx5_suspend_ops);
> >
> > Now this is called only in i.MX51 context, so you can skip the cpu_is
> >
> 
> After this patch series this is also called in i.MX53 context.  I'm
> not confident about the i.MX53 suspend/resume and would prefer to
> perform further testing and address issues with it in a separate patch
> series.

In this case there is also the possibility that you add a imx51_pm_init
in which you set the suspend_ops and call imx5_pm_init afterwards. The
cpu_is_macros a kind of deprecated. Instead we settled on calling
functions with the exact SoC name from the (dt-) board files and call
the more generic function from the SoC specific ones.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
