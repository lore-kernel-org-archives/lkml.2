Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755152Ab1IGRrT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 13:47:19 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38755 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752698Ab1IGRrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 13:47:18 -0400
Date: Wed, 7 Sep 2011 10:47:14 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: linux-kernel@vger.kernel.org, Michael.Hennerich@analog.com,
        linux-iio@vger.kernel.org
Subject: Re: [PATCH 2/6] regmap: Add a magic bus type to handle quirks of
 analog devices ADIS sensors.
Message-ID: <20110907174713.GG2906@opensource.wolfsonmicro.com>
References: <4E679770.4090008@cam.ac.uk>
 <1315412387-5765-3-git-send-email-jic23@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315412387-5765-3-git-send-email-jic23@cam.ac.uk>
X-Cookie: Cold hands, no gloves.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 07, 2011 at 05:19:43PM +0100, Jonathan Cameron wrote:
> These devices look like 8 bit registers for writes and 16 bit registers for
> reads.  As you might imagine this causes some 'issues' hence this regmap
> bus implementation claims they are always 16bit and does the mangling to
> make the writes work.
> ---

You've not signed this off.  To be honest I'm not terribly happy about
pushing this into the regmap core code; if we start needing to do stuff
like this we should expose the bus interface.

> +
> +static int regmap_spi_write(struct device *dev, const void *data, size_t count)
> +{
> +/* Now this only works for 8 bit addresss 16 bit register first byte of data
> + * is the lower address, second two the value */
> +	struct spi_device *spi = to_spi_device(dev);
> +	int ret;

Indentation.

> +static struct regmap_bus regmap_spi_adi = {
> +	.write = regmap_spi_write,
> +	.read = regmap_spi_read,
> +};

You want to implement the gather write too if you can.
