Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757491Ab1JCT5R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 15:57:17 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46723 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755887Ab1JCT5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 15:57:11 -0400
Date: Mon, 3 Oct 2011 20:57:09 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: Add driver for gpio-controlled regulators
Message-ID: <20111003195708.GS3731@opensource.wolfsonmicro.com>
References: <201110032111.57958.heiko@sntech.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201110032111.57958.heiko@sntech.de>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 03, 2011 at 09:11:57PM +0200, Heiko Stübner wrote:
> This patch adds support for regulators that can be controlled via gpios.

> Examples for such regulators are the TI-tps65024x voltage regulators
> with 4 fixed and 1 runtime-switchable voltage regulators
> or the TI-bq240XX charger regulators.

What's the difference between this and the patch you posted on Friday?

> +	drvdata->gpios = kmalloc(config->nr_gpios * sizeof(int), GFP_KERNEL);

calloc.

> +		/* set output direction without changing state
> +		 * to prevent glitch
> +		 */
> +		drvdata->is_enabled = config->enabled_at_boot;
> +		ret = drvdata->is_enabled ?
> +				config->enable_high : !config->enable_high;

I'm fairly sure this could be written more cleanly.

> +	drvdata->nr_gpios = config->nr_gpios;
> +	for (ptr = 0; ptr < drvdata->nr_gpios; ptr++) {
> +		ret = gpio_request(config->gpios[ptr], config->supply_name);
> +		if (ret) {
> +			dev_err(&pdev->dev,
> +			   "Could not obtain regulator setting GPIO %d: %d\n",
> +						config->gpios[ptr], ret);
> +			goto err_stategpio;
> +		}

This might be easier written using gpio_request_array().
