Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757015Ab0JTDCo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 23:02:44 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:56456 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756757Ab0JTDCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 23:02:43 -0400
Date: Wed, 20 Oct 2010 04:02:35 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: rklein@nvidia.com
Cc: cboutatmailru@gmail.com, achew@nvidia.com, olof@lixom.net,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] power: bq24617: Adding initial charger support
Message-ID: <20101020030235.GA25392@sirena.org.uk>
References: <1287541031-17409-1-git-send-email-rklein@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287541031-17409-1-git-send-email-rklein@nvidia.com>
X-Cookie: The Moral Majority is neither.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 19, 2010 at 07:17:11PM -0700, rklein@nvidia.com wrote:
> From: Rhyland Klein <rklein@nvidia.com>
> 
> Initial checkin adding basic support for the TI BQ24617 battery charger on the
> Nvidia Tegra architecture.

Why is this driver dependant on the CPU?  I can't see anything in the
code that makes it so.

> +	if (old_status != -1 &&
> +		old_status != new_status) {
> +		dev_dbg(&chip->pdev->dev,
> +			"%s: %i -> %i\n", __func__, old_status,
> +			new_status);
> +		kobject_uevent(&chip->power_supply.dev->kobj, KOBJ_CHANGE);

power_supply_changed().

> +static irqreturn_t bq24617_irq_switch(int irq, void *devid)
> +{
> +	struct bq24617_info *chip = devid;
> +
> +	schedule_work(&chip->ac_work);
> +
> +	return IRQ_HANDLED;
> +}

You're looking for a threaded IRQ handler here - use
request_threaded_irq() with no primary handler.
