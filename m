Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758818Ab2EJMll (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 08:41:41 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47368 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755596Ab2EJMli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 08:41:38 -0400
Date: Thu, 10 May 2012 14:41:30 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Rob Lee <rob.lee@linaro.org>
Cc: kernel@pengutronix.de, shawn.guo@linaro.org, amit.kucheria@linaro.org,
        daniel.lezcano@linaro.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        patches@linaro.org, jj@chaosbits.net
Subject: Re: [PATCH v3 2/3] ARM: imx: Add imx5 cpuidle driver
Message-ID: <20120510124130.GS27341@pengutronix.de>
References: <1336425407-20308-1-git-send-email-rob.lee@linaro.org>
 <1336425407-20308-3-git-send-email-rob.lee@linaro.org>
 <20120509080214.GJ27341@pengutronix.de>
 <CAMXH7KF7eznzF7AzM_JzwJ1jOm-1J4biqd=PvKMSa=ex8YFQrA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMXH7KF7eznzF7AzM_JzwJ1jOm-1J4biqd=PvKMSa=ex8YFQrA@mail.gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 14:33:10 up 179 days, 20:20, 97 users,  load average: 0.05, 0.06,
 0.05
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2012 at 09:27:02AM -0500, Rob Lee wrote:
> Sascha,
> 
> >
> > This clk_get should go away here and be moved somewhere to
> > initialization. Also, if getting this clock fails we can still
> > do regular cpu_do_idle. Additionally, if clk_get fails, we'll
> > have a ERR_PTR value in gpc_dvfs_clk in which case the
> > gpc_dvfs_clk == NULL won't trigger next time you are here and
> > then you'll enable a nonexisting clock below.
> >
> 
> Agree.  I'd prefer to enable this clock during intialization and just
> leave it running.  It is supposed to be a very low power clock and I
> couldn't measuring any power difference with and without it being
> enabled

Ok, even better.

> >
> > I wonder why you don't add the default ARM_CPUIDLE_WFI_STATE_PWR state.
> > The above is something different, right? It has a greater exit latency
> > than ARM_CPUIDLE_WFI_STATE_PWR, so why don't we add it here aswell?
> 
> Yes and no.  Yes this is a different state but no, it doesn't have a
> significantly greater exit latency, or at least a large enough exit
> latency to warrant an extra state in my opinion.  According to the
> i.MX5 documentation, the extra exit time beyond basic WFI required for
> the  "WAIT_UNCLOCKED_POWER_OFF" state is 500ns (this is due to a
> difference in i.MX5 hardware implementation compared to all other ARM
> platforms).  In reality, it did require a few more microseconds to
> perform in my testing just based on the extra register writes in
> mx5_cpu_lp_set().  I'd like to clean up mx5_cpu_lp_set() and add a
> global variable to track the previous state and to just exit out if
> the new state is the same as the old.

Do you think it's worth it? You buy skipping the read with an additional
test.

> I could do this cleanup as part of this patchset if you prefer that.

Yes please. Cleanups before adding new features is always a good reason
to apply a patch series ;)

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
