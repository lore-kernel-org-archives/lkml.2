Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757Ab2GEGrs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 02:47:48 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41322 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539Ab2GEGrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 02:47:47 -0400
Date: Thu, 5 Jul 2012 08:47:42 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Alex Courbot <acourbot@nvidia.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>
Subject: Re: [PATCH] pwm-backlight: add regulator and GPIO support
Message-ID: <20120705064742.GL30009@pengutronix.de>
References: <1340976167-27298-1-git-send-email-acourbot@nvidia.com>
 <20120704104840.GJ24458@pengutronix.de>
 <4FF43692.2040805@nvidia.com>
 <20120704130056.GC30009@pengutronix.de>
 <4FF45DDF.9000306@nvidia.com>
 <20120704152451.GA7333@sirena.org.uk>
 <4FF4FDC0.8020405@nvidia.com>
 <20120705062011.GI30009@pengutronix.de>
 <4FF53368.6090805@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FF53368.6090805@nvidia.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:26:09 up 11 days, 21:37, 35 users,  load average: 0.10, 0.09,
 0.16
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 05, 2012 at 03:25:44PM +0900, Alex Courbot wrote:
> On 07/05/2012 03:20 PM, Sascha Hauer wrote:
> >>Oh, that is a mistake of mine then. Driver probe should continue if
> >>no regulator is declared (but should fail if some other error
> >>occured). I want to maintain backward compatibility with current
> >>users of the driver, so regulator/gpio specification should be
> >>optional.
> >
> >I think the only way doing this is to add a flag to platform_data. I
> >don't know if that's accepted though.
> 
> I thought about just checking if devm_get_regulator returned -ENODEV
> and happily continue if that was the case, assuming no regulator was
> declared.

And that's the problem. The get_regulator won't return -ENODEV. It will
return -EPROBE_DEFER which tells you nothing about whether a regulator
will ever be available or not.

Having a flag in platform data would be fine with me, but I know other
people think differently.

BTW in devicetree this flag implicitely exists with the power-supply
property. The regulator core could look if a power-supply property
is given and

- if it is given, a regulator is mandatory and the core either
  returns the regulator or -EPROBE_DEFER if it cannot find one.
- If it is not given, there is no regulator and the core could either
  return a special error code or a dummy regulator.

Right now the regulator core will just return -EPROBE_DEFER in both
cases. This could easily be changed in the regulator core.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
