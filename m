Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751977Ab2GEGUU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 02:20:20 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55810 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869Ab2GEGUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 02:20:17 -0400
Date: Thu, 5 Jul 2012 08:20:11 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Alex Courbot <acourbot@nvidia.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>
Subject: Re: [PATCH] pwm-backlight: add regulator and GPIO support
Message-ID: <20120705062011.GI30009@pengutronix.de>
References: <1340976167-27298-1-git-send-email-acourbot@nvidia.com>
 <20120704104840.GJ24458@pengutronix.de>
 <4FF43692.2040805@nvidia.com>
 <20120704130056.GC30009@pengutronix.de>
 <4FF45DDF.9000306@nvidia.com>
 <20120704152451.GA7333@sirena.org.uk>
 <4FF4FDC0.8020405@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FF4FDC0.8020405@nvidia.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:18:48 up 11 days, 21:30, 35 users,  load average: 0.19, 0.23,
 0.23
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 05, 2012 at 11:36:48AM +0900, Alex Courbot wrote:
> On 07/05/2012 12:24 AM, Mark Brown wrote:
> >On Thu, Jul 05, 2012 at 12:14:39AM +0900, Alex Courbot wrote:
> >>On Wed 04 Jul 2012 10:00:56 PM JST, Sascha Hauer wrote:
> >
> >>>Also please be aware that using a regulator in the pwm backlight will
> >>>instantly break all existing users. That's hardly your fault though.
> >
> >>Sorry, I don't see why. Could you elaborate on this?
> >
> >All existing machines will start failing during probe as they won't be
> >able to find the regulator - you should ideally make sure everyone in
> >mainline gets an appropriate regulator set up.
> 
> Oh, that is a mistake of mine then. Driver probe should continue if
> no regulator is declared (but should fail if some other error
> occured). I want to maintain backward compatibility with current
> users of the driver, so regulator/gpio specification should be
> optional.

I think the only way doing this is to add a flag to platform_data. I
don't know if that's accepted though.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
