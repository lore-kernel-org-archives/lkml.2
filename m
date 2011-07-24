Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751850Ab1GXSts (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 14:49:48 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:55268 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627Ab1GXStl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 14:49:41 -0400
Date: Sun, 24 Jul 2011 19:49:34 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: ashishj3 <ashish.jangam@kpitcummins.com>
Cc: arnd@arndb.de, sameo@openedhand.com, linux-kernel@vger.kernel.org,
        Dajun <dajun.chen@diasemi.com>, linaro-dev@lists.linaro.org
Subject: Re: [PATCH 01/11] MFD: DA9052 MFD core module v2
Message-ID: <20110724184934.GA29931@sirena.org.uk>
References: <1309876620.960.169.camel@L-0532.kpit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309876620.960.169.camel@L-0532.kpit.com>
X-Cookie: Pass with care.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 05, 2011 at 08:07:00PM +0530, ashishj3 wrote:

> +int da9052_set_bits(struct da9052 *da9052, unsigned char reg,
> +		     unsigned char bit_mask)
> +{
> +	unsigned char val;
> +	int ret;
> +
> +	if (reg > DA9052_MAX_REG_CNT) {
> +		dev_err(da9052->dev, "invalid reg %x\n", reg);
> +		return -EINVAL;
> +	}
> +
> +	mutex_lock_interruptible(&da9052->io_lock);

Linus has now merged the regmap code (include/linux/regmap.h and
drivers/base/regmap) which means that your register I/O code should 
probably be redone in terms of that - it shoud factor a lot of code out
of the driver.
