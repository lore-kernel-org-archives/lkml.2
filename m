Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752595Ab2KEP5y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 10:57:54 -0500
Received: from smtp-out-191.synserver.de ([212.40.185.191]:1125 "EHLO
	smtp-out-191.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108Ab2KEP5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 10:57:52 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 18037
Message-ID: <5097E201.7040008@metafoo.de>
Date: Mon, 05 Nov 2012 16:57:53 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.10) Gecko/20121027 Icedove/10.0.10
MIME-Version: 1.0
To: Lars Poeschel <larsi@wh2.tu-dresden.de>
CC: linus.walleij@linaro.org, poeschel@lemonage.de, sameo@linux.intel.com,
        linux-kernel@vger.kernel.org, jic23@cam.ac.uk, khali@linux-fr.org,
        ben-linux@fluff.org, w.sang@pengutronix.de, grant.likely@secretlab.ca,
        linux-iio@vger.kernel.org
Subject: Re: [PATCH v3 5/5] iio: adc: add viperboard adc driver
References: <1352126906-4560-1-git-send-email-larsi@wh2.tu-dresden.de> <1352126906-4560-5-git-send-email-larsi@wh2.tu-dresden.de>
In-Reply-To: <1352126906-4560-5-git-send-email-larsi@wh2.tu-dresden.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/2012 03:48 PM, Lars Poeschel wrote:
> From: Lars Poeschel <poeschel@lemonage.de>
> 
> This adds the mfd cell to use the adc part of the Nano River Technologies
> viperboard.
> 
> Signed-off-by: Lars Poeschel <poeschel@lemonage.de>

Looks good to me.

Reviewed-by: Lars-Peter Clausen <lars@metafoo.de>

If you happen to resend the series there is one tiny bit that could be
changed, but no need to resend the series just for this.

> ---
>  drivers/iio/adc/Kconfig          |    7 ++
>  drivers/iio/adc/Makefile         |    1 +
>  drivers/iio/adc/viperboard_adc.c |  181 ++++++++++++++++++++++++++++++++++++++
>  drivers/mfd/viperboard.c         |    3 +
>  include/linux/mfd/viperboard.h   |    1 +
>  5 files changed, 193 insertions(+)
>  create mode 100644 drivers/iio/adc/viperboard_adc.c
> 

> +
> +static int __devinit vprbrd_adc_probe(struct platform_device *pdev)
> +{
> +	struct vprbrd *vb = dev_get_drvdata(pdev->dev.parent);
> +	struct vprbrd_adc *adc;
> +	struct iio_dev *indio_dev;
> +	int ret;
> +
> +	/* registering iio */
> +	indio_dev = iio_device_alloc(sizeof(struct vprbrd_adc));

sizeof(*adc)

> +	if (!indio_dev) {
> +		dev_err(&pdev->dev, "failed allocating iio device\n");
> +		return -ENOMEM;
> +	}

