Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965274Ab2EWP37 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 11:29:59 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:59196 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965162Ab2EWP34 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 11:29:56 -0400
MIME-Version: 1.0
In-Reply-To: <CAOMZO5DKLO5B7vbMKmXLfmR0zgVX5bVcxK22khTt=X71bL5tOQ@mail.gmail.com>
References: <CAOMZO5A-05jTYpEEPfnJvWpby1YJ1M7=KPn=zahbQrQOgbjR4g@mail.gmail.com>
	<201205221053.21792.marc@cpdesign.com.au>
	<CAOMZO5BCcFOktp9mqDCpnrVhbK6pwO1R3ZdiKPfawb=KLjzzWw@mail.gmail.com>
	<CAOMZO5DKsrXJoSSacwYFoHUw6pPWLWQnC3gS=6=3k6nvf6tggw@mail.gmail.com>
	<20120523084945.GA4085@opensource.wolfsonmicro.com>
	<CAOMZO5DKLO5B7vbMKmXLfmR0zgVX5bVcxK22khTt=X71bL5tOQ@mail.gmail.com>
Date: Wed, 23 May 2012 12:29:54 -0300
Message-ID: <CAOMZO5DSZkvSgH=urBQAkBa7WXEbiDzarikppyRS-BNXpwJkVg@mail.gmail.com>
Subject: Re: mc13xxx-core: kernel hangs after 'regmap_read'
From: Fabio Estevam <festevam@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: marc@cpdesign.com.au, Samuel Ortiz <sameo@linux.intel.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        =?UTF-8?Q?Philippe_R=C3=A9tornaz?= <philippe.retornaz@epfl.ch>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2012 at 11:18 AM, Fabio Estevam <festevam@gmail.com> wrote:

> Removing only the line that sets bits_per_word:
>
> --- a/drivers/mfd/mc13xxx-spi.c
> +++ b/drivers/mfd/mc13xxx-spi.c
> @@ -73,7 +73,6 @@ static int mc13xxx_spi_probe(struct spi_device *spi)
>
>        dev_set_drvdata(&spi->dev, mc13xxx);
>        spi->mode = SPI_MODE_0 | SPI_CS_HIGH;
> -       spi->bits_per_word = 32;
>
>        mc13xxx->dev = &spi->dev;
>        mutex_init(&mc13xxx->lock);
>
>
> , does allow the kernel to boot, but the mx13xxx driver is not probed anymore:

The reason for the mc13xxx not probing is because it tries to read the
mc13xxx version register and does not find a valid PMIC ID.

I did a dump of all the mc13xxx registers and all of them return the
same value of 0x810, which means we are not reading SPI correctly via
regmap.
