Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965118Ab2JCRgJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 13:36:09 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45274 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964779Ab2JCRgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 13:36:07 -0400
Date: Wed, 3 Oct 2012 18:36:04 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Fabio Estevam <festevam@gmail.com>
Cc: sameo@linux.intel.com, ashish.jangam@kpitcummins.com, dchen@diasemi.com,
        arnd@arndb.de, kernel@pengutronix.de, dmitry.torokhov@gmail.com,
        linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: [RFC 1/3] mfd: da9052-core: Use regmap_irq_get_virq() and fix
 the probe
Message-ID: <20121003173603.GG4360@opensource.wolfsonmicro.com>
References: <1349284019-31571-1-git-send-email-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349284019-31571-1-git-send-email-festevam@gmail.com>
X-Cookie: You look tired.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 03, 2012 at 02:06:57PM -0300, Fabio Estevam wrote:

> +	/* Allocate a virtual IRQ domain to distribute to the regmap domains */
> +	da9052->virq = irq_domain_add_linear(NULL, ARRAY_SIZE(da9052_irqs),
> +						&da9052_domain_ops, da9052);
> +	if (!da9052->virq) {
> +		ret = -EINVAL;
> +		goto regmap_err;
> +	}

I still don't understand what on earth this is doing, as far as I can
tell there's only one domain in the device so you're not distrubting
anything between domains and there's as many interrupts in this domain
as there are in the domain allocated by regmap which is even odder.

There doesn't seem to be anything about this driver that's unusual, why
does it need this weird code?
