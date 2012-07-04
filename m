Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932353Ab2GDU0x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 16:26:53 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59806 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755651Ab2GDU0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 16:26:50 -0400
Date: Wed, 4 Jul 2012 22:26:44 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Alex Courbot <acourbot@nvidia.com>
Cc: Thierry Reding <thierry.reding@avionic-design.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>
Subject: Re: [PATCH] pwm-backlight: add regulator and GPIO support
Message-ID: <20120704202644.GG30009@pengutronix.de>
References: <1340976167-27298-1-git-send-email-acourbot@nvidia.com>
 <20120704104840.GJ24458@pengutronix.de>
 <4FF43692.2040805@nvidia.com>
 <20120704130056.GC30009@pengutronix.de>
 <4FF45DDF.9000306@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FF45DDF.9000306@nvidia.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 22:25:53 up 11 days, 11:37, 40 users,  load average: 9.55, 10.16,
 6.66
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 05, 2012 at 12:14:39AM +0900, Alex Courbot wrote:
> On Wed 04 Jul 2012 10:00:56 PM JST, Sascha Hauer wrote:
> >>That's very bad indeed. I assumed that the kernel would free
> >>devm-allocated resources after probe returned -EPROBE_DEFER,
> >
> >It indeed does free devm allocated resources, but neither the gpio nor
> >the pwm are devm allocated.
> 
> As far as I can tell the gpio is allocated through devm as well:
> 
> > +		ret = devm_gpio_request_one(&pdev->dev, data->enable_gpio,
> > +				GPIOF_OUT_INIT_HIGH, "backlight_enable");

You're right. For the GPIO it's ok the way it is.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
