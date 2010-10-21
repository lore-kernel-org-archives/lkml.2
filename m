Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757690Ab0JUQAz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 12:00:55 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57463 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750881Ab0JUQAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 12:00:54 -0400
Date: Thu, 21 Oct 2010 09:00:09 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: rklein@nvidia.com, Anton Vorontsov <cbouatmailru@gmail.com>,
        achew@nvidia.com, olof@lixom.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] POWER: Add gpio charger driver
Message-ID: <20101021160008.GD9447@opensource.wolfsonmicro.com>
References: <1287663957-30099-1-git-send-email-lars@metafoo.de>
 <1287676501-23254-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287676501-23254-1-git-send-email-lars@metafoo.de>
X-Cookie: You're at the end of the road again.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 21, 2010 at 05:55:01PM +0200, Lars-Peter Clausen wrote:

> +	irq = gpio_to_irq(pdata->gpio);
> +	if (irq > 0) {
> +		ret = request_irq(irq, gpio_charger_irq,
> +				IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING,
> +				dev_name(&pdev->dev), charger);
> +		if (ret)
> +			dev_warn(&pdev->dev, "Failed to request irq: %d\n", ret);

It would be good to handle IRQs that can sleep (like those on I2C GPIO
expanders) here - either always use a threaded IRQ handler (probably
won't hurt here) or use one if the IRQ can sleep.
