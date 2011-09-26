Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753162Ab1IZJ4O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 05:56:14 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45510 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753021Ab1IZJ4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 05:56:12 -0400
Date: Mon, 26 Sep 2011 10:56:11 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: ashishj3 <ashish.jangam@kpitcummins.com>
Cc: sameo@openedhand.com, linux-kernel@vger.kernel.org,
        Dajun <dajun.chen@diasemi.com>, linaro-dev@lists.linaro.org,
        arnd@arndb.de
Subject: Re: [PATCH 01/11] MFD: DA9052/53 MFD core module v6
Message-ID: <20110926095611.GA15452@opensource.wolfsonmicro.com>
References: <1316435596.344.132.camel@L-0761.kpit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316435596.344.132.camel@L-0761.kpit.com>
X-Cookie: Chess tonight.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 19, 2011 at 06:03:16PM +0530, ashishj3 wrote:
> The DA9052/53 is a highly integrated PMIC subsystem with supply domain flexibility
> to support wide range of high performance application.
> 
> It provides voltage regulators, GPIO controller, Touch Screen, RTC, Battery
> control and other functionality.

So, this looks good.  However...

> +static struct regmap_config da9052_regmap_config = {
> +	.reg_bits = 8,
> +	.val_bits = 8,
> +};
> +
> +static int da9052_spi_probe(struct spi_device *spi)

...having reviewed previous versions of your driver I believe you need
to set either or both of read_flag_mask or write_flag_mask your regmap
config (these have been added in -next) - previous versions of your
driver had code which was trying to bodge this in, you've removed this
code but not added any use of the generic facility so I rather suspect
that currently the driver doesn't work with SPI.

Samuel, as a fix will depend on -next regmap I guess it makes sense for
me to apply this if a new version is provided before the next merge
window?
