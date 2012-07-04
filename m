Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752213Ab2GDNBE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 09:01:04 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44943 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032Ab2GDNBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 09:01:00 -0400
Date: Wed, 4 Jul 2012 15:00:56 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Alex Courbot <acourbot@nvidia.com>
Cc: Thierry Reding <thierry.reding@avionic-design.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>
Subject: Re: [PATCH] pwm-backlight: add regulator and GPIO support
Message-ID: <20120704130056.GC30009@pengutronix.de>
References: <1340976167-27298-1-git-send-email-acourbot@nvidia.com>
 <20120704104840.GJ24458@pengutronix.de>
 <4FF43692.2040805@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FF43692.2040805@nvidia.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 14:26:05 up 11 days,  3:37, 73 users,  load average: 4.49, 18.06,
 11.55
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 04, 2012 at 09:26:58PM +0900, Alex Courbot wrote:
> Hi Sascha,
> 
> On 07/04/2012 07:48 PM, Sascha Hauer wrote:>> +
> >> +	pb->power_reg = devm_regulator_get(&pdev->dev, "power");
> >> +	if (IS_ERR(pb->power_reg))
> >> +		return PTR_ERR(pb->power_reg);
> >
> > This looses several resources allocated earlier, like the enable gpio
> > and the pwm. This is really bad here since I have no regulator specified
> > and devm_regulator_get returns with -EPROBE_DEFER. Next time the core
> > tries to probe the driver the driver bails out because the gpio and the
> > pwm is already requested.
> 
> That's very bad indeed. I assumed that the kernel would free
> devm-allocated resources after probe returned -EPROBE_DEFER,

It indeed does free devm allocated resources, but neither the gpio nor
the pwm are devm allocated.

Also please be aware that using a regulator in the pwm backlight will
instantly break all existing users. That's hardly your fault though.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
