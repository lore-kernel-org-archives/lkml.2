Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356Ab1HNOeb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 10:34:31 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:41005 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753168Ab1HNOe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 10:34:29 -0400
Date: Sun, 14 Aug 2011 15:34:01 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Kenneth Heitke <kheitke@codeaurora.org>
Cc: davidb@codeaurora.org, bryanh@codeaurora.org,
        linux-arm-msm@vger.kernel.org, Sagar Dharia <sdharia@codeaurora.org>,
        rdunlap@xenotime.net, rmk+kernel@arm.linux.org.uk,
        john.stultz@linaro.org, arnd@arndb.de, akpm@linux-foundation.org,
        ohad@wizery.com, gregkh@suse.de, stefanr@s5r6.in-berlin.de,
        lethal@linux-sh.org, linville@tuxdriver.com, zajec5@gmail.com,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] slimbus: Linux driver framework for SLIMbus.
Message-ID: <20110814143401.GA25504@sirena.org.uk>
References: <1313019091-15354-1-git-send-email-kheitke@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313019091-15354-1-git-send-email-kheitke@codeaurora.org>
X-Cookie: To make an enemy, do someone a favor.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 10, 2011 at 05:31:28PM -0600, Kenneth Heitke wrote:

> SLIMbus (Serial Low Power Interchip Media Bus) is a specification
> developed by MIPI (Mobile Industry Processor Interface) alliance.

Please CC me on any future spins of this patch.

> Signed-off-by: Sagar Dharia <sdharia@codeaurora.org>

You ought to sign off the patch as well as you're part of the chain for
it getting into the kernel.

> +#ifdef CONFIG_PM_SLEEP
> +static int slim_legacy_suspend(struct device *dev, pm_message_t mesg)
> +{
> +	struct slim_device *slim_dev = NULL;

Why have legacy stuff in a newly implemented subsystem?

> +static int slim_drv_probe(struct device *dev)
> +{
> +	const struct slim_driver *sdrv = to_slim_driver(dev->driver);
> +
> +	if (sdrv->probe)
> +		return sdrv->probe(to_slim_device(dev));
> +	return -ENODEV;
> +}

Why all the -ENODEVs if there's no function?  I'd expect that if there's
nothing to do it should be possible to omit functions from drivers.

> +int slim_driver_register(struct slim_driver *drv)
> +{
> +	drv->driver.bus = &slimbus_type;
> +	if (drv->probe)
> +		drv->driver.probe = slim_drv_probe;

Modifying the driver structure seems icky, why is this needed?  Other
bus types appear to manage without.

> +static u16 slim_slicecodefromsize(u32 req)
> +{
> +	u8 codetosize[8] = {1, 2, 3, 4, 6, 8, 12, 16};
> +	if (req >= 8)
> +		return 0;

ARRAY_SIZE()?  I guess the table should be static too.
