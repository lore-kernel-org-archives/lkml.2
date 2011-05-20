Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935515Ab1ETKCr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 06:02:47 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46037 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934699Ab1ETKCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 06:02:45 -0400
Date: Fri, 20 May 2011 12:02:42 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, kernel@pengutronix.de,
        linux-arm-kernel@lists.infradead.org, patches@linaro.org
Subject: Re: [PATCH 0/4] add gpio driver gpio-mxs
Message-ID: <20110520100242.GA10403@pengutronix.de>
References: <1305885089-27343-1-git-send-email-shawn.guo@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305885089-27343-1-git-send-email-shawn.guo@linaro.org>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 11:57:25 up  3:37,  6 users,  load average: 0.02, 0.07, 0.04
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:219:66ff:fe5b:d076
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Shawn,

On Fri, May 20, 2011 at 05:51:25PM +0800, Shawn Guo wrote:
> The patch set is to move Freescale MXS gpio driver from mach-mxs
> into drivers/gpio.  Different from u300 gpio driver that all gpio
> ports are registered as one device, gpio-mxs expects every single
> port is a gpio device.
> 
> The first 3 patches are just to ease review and can be squashed into
> the last one.
> 
> Shawn Guo (4):
>       gpio: gpio-mxs: add file gpio-mxs.c
>       gpio: gpio-mxs: drop mach-specific accessors
>       gpio: gpio-mxs: remove gpio port definition and registration
>       gpio: gpio-mxs: add gpio driver for Freescale MXS architecture

Your series should be bisectible. So please either:

- Add the driver the way you want it (no need to modify a new file in
  four steps)
- atomically switch to the new driver
- remove old driver

or:

- work on old file until it's suitable for drivers/gpio
- move old file to drivers/gpio and adjust the makefiles in one step.


There may be different variations on this depending on the actual code,
but whatever you do, each step should be able to compile and working.


Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
