Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756513Ab2FNSch (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 14:32:37 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:48302 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755484Ab2FNScg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 14:32:36 -0400
Date: Thu, 14 Jun 2012 19:32:32 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        grant.likely@secretlab.ca, linus.walleij@stericsson.com, arnd@arndb.de,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH 08/14] mfd: Add IRQ domain support for the AB8500
Message-ID: <20120614183231.GA30185@sirena.org.uk>
References: <1339428307-3850-1-git-send-email-lee.jones@linaro.org>
 <1339428307-3850-9-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339428307-3850-9-git-send-email-lee.jones@linaro.org>
X-Cookie: Do not try this at home.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 11, 2012 at 04:25:01PM +0100, Lee Jones wrote:

> +	if (np) {
> +		ab8500->domain = irq_domain_add_linear(
> +			np, num_irqs, &ab8500_irq_ops, ab8500);
> +	}
> +	else {
> +		ab8500->domain = irq_domain_add_legacy(
> +			NULL, num_irqs, ab8500->irq_base,
> +			0, &ab8500_irq_ops, ab8500);
> +	}

This is odd, why are you forcing non-DT systems to use a legacy mapping?
The more usual approach is to use a legacy mapping if and only if a base
for the legacy range has been provided, otherwise the system will
needlessly fail to initialise the device...

> +	if (!(ab8500->irq_base || np)) {
> +		dev_info(&pdev->dev, "couldn't find irq-base and not doing DT boot\n");

...like this.  See regmap_irq for an example.
