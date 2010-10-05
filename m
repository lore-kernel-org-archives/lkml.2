Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755632Ab0JEVfW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 17:35:22 -0400
Received: from mail.perches.com ([173.55.12.10]:2674 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753098Ab0JEVfV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 17:35:21 -0400
Subject: Re: [PATCH v2] iio: light: Adding driver for ISL29018 ALS
From: Joe Perches <joe@perches.com>
To: rklein@nvidia.com
Cc: jic23@cam.ac.uk, achew@nvidia.com, olof@lixom.net,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org, ldewangan@nvidia.com
In-Reply-To: <1286313561-6456-1-git-send-email-rklein@nvidia.com>
References: <1286313561-6456-1-git-send-email-rklein@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 05 Oct 2010 14:35:17 -0700
Message-ID: <1286314517.2156.50.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-05 at 14:19 -0700, rklein@nvidia.com wrote:
> Adding support for the ISL 29018 ambient light and proximity sensor.

Trivial comments below.

> diff --git a/drivers/staging/iio/light/isl29018.c b/drivers/staging/iio/light/isl29018.c
[]
> +static int isl29018_set_range(struct i2c_client *client, unsigned long range,
> +		unsigned int *new_range)
> +{
> +	unsigned long supp_ranges[] = {1000, 4000, 16000, 64000};

static const

> +static int isl29018_set_resolution(struct i2c_client *client,
> +			unsigned long adcbit, unsigned int *conf_adc_bit)
> +{
> +	unsigned long supp_adcbit[] = {16, 12, 8, 4};

here too

> +static int isl29018_chip_init(struct i2c_client *client)
> +{
> +	struct isl29018_chip *chip = i2c_get_clientdata(client);
> +	int status;
> +	int i;
> +	int new_adc_bit;
> +	unsigned int new_range;
> +
> +	for (i = 0; i < ARRAY_SIZE(chip->reg_cache); i++)
> +		chip->reg_cache[i] = 0;

memset?


