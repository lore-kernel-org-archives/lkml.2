Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042Ab1JSWif (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 18:38:35 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43253 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751012Ab1JSWie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 18:38:34 -0400
Date: Wed, 19 Oct 2011 23:38:32 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ashish Jangam <ashish.jangam@kpitcummins.com>
Cc: "arnd@arndb.de" <arnd@arndb.de>,
        "sameo@openedhand.com" <sameo@openedhand.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dajun <dajun.chen@diasemi.com>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>
Subject: Re: [PATCH 1/11] MFD: DA9052 MFD core module v8
Message-ID: <20111019223831.GA10573@opensource.wolfsonmicro.com>
References: <1319033356.17688.32.camel@dhruva>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319033356.17688.32.camel@dhruva>
X-Cookie: Long life is in store for you.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 19, 2011 at 07:39:16PM +0530, Ashish Jangam wrote:

> +static struct regmap_config da9052_regmap_config = {
> +	.reg_bits = 8,
> +	.val_bits = 8,
> +};
> +
> +static int da9052_spi_probe(struct spi_device *spi)

So, as I think I mentioned last time based on the previous non-regmap
versions of the patch I don't expect this to work at all.  You should
use the read_mask and/or write_mask options to set the flag bits you
need to indicated if this is a read or write.
