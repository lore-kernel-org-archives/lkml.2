Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758042Ab2I1O32 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 10:29:28 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36574 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757673Ab2I1O31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 10:29:27 -0400
Date: Fri, 28 Sep 2012 15:29:24 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Fabio Estevam <fabio.estevam@freescale.com>
Cc: Fabio Estevam <festevam@gmail.com>, sameo@linux.intel.com,
        Marek Vasut <marex@denx.de>, ashish.jangam@kpitcummins.com,
        dchen@diasemi.com, arnd@arndb.de, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mfd: da9052-core:  Use regmap_irq_get_virq() and fix
 the probe
Message-ID: <20120928142924.GA22101@opensource.wolfsonmicro.com>
References: <1348797458-2562-1-git-send-email-festevam@gmail.com>
 <20120928104944.GB30869@opensource.wolfsonmicro.com>
 <5065B534.7040602@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5065B534.7040602@freescale.com>
X-Cookie: You will never know hunger.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 11:33:24AM -0300, Fabio Estevam wrote:

> Would you prefer the version below? If so, I can send it as v3:

> -	da9052->irq_base = regmap_irq_chip_get_base(da9052->irq_data);
> +	da9052->irq = regmap_irq_get_virq(da9052->irq_data, 0);

No, this doesn't support linear domains, if you're going to do this it'd
be better to just leave it as irq_base though as discussed that's not
ideal.  When I've done these conversions I've just done the virq
conversion at every use.
