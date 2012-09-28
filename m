Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757430Ab2I1Kts (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 06:49:48 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52120 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754747Ab2I1Ktr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 06:49:47 -0400
Date: Fri, 28 Sep 2012 11:49:44 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Fabio Estevam <festevam@gmail.com>
Cc: sameo@linux.intel.com, marex@denx.de, ashish.jangam@kpitcummins.com,
        dchen@diasemi.com, arnd@arndb.de, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: [PATCH v2] mfd: da9052-core:  Use regmap_irq_get_virq() and fix
 the probe
Message-ID: <20120928104944.GB30869@opensource.wolfsonmicro.com>
References: <1348797458-2562-1-git-send-email-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348797458-2562-1-git-send-email-festevam@gmail.com>
X-Cookie: Excellent day to have a rotten day.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2012 at 10:57:38PM -0300, Fabio Estevam wrote:

> -	da9052->irq_base = regmap_irq_chip_get_base(da9052->irq_data);
> +	da9052->irq = regmap_irq_get_virq(da9052->irq_data, DA9052_IRQ_ADC_EOM);
>  
> -	ret = request_threaded_irq(DA9052_IRQ_ADC_EOM, NULL, da9052_auxadc_irq,
> +	if (da9052->irq < 0) {
> +		ret = da9052->irq;
> +		dev_err(da9052->dev, "regmap_irq_get_virq failed: %d\n", ret);
> +		goto regmap_err;
> +	}
> +
> +	ret = request_threaded_irq(da9052->irq, NULL, da9052_auxadc_irq,

This will fix the problem but the usage of da9052->irq here is very odd,
normally that'd be the primary IRQ for the device but this is actually
just the interrupt for the ADC.

Otherwise

Reviwed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
