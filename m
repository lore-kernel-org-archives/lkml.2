Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933063Ab2EWCFh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 22:05:37 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:33372 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933018Ab2EWCFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 22:05:36 -0400
MIME-Version: 1.0
In-Reply-To: <CAOMZO5BCcFOktp9mqDCpnrVhbK6pwO1R3ZdiKPfawb=KLjzzWw@mail.gmail.com>
References: <CAOMZO5A-05jTYpEEPfnJvWpby1YJ1M7=KPn=zahbQrQOgbjR4g@mail.gmail.com>
	<201205221053.21792.marc@cpdesign.com.au>
	<CAOMZO5BCcFOktp9mqDCpnrVhbK6pwO1R3ZdiKPfawb=KLjzzWw@mail.gmail.com>
Date: Tue, 22 May 2012 23:05:35 -0300
Message-ID: <CAOMZO5DKsrXJoSSacwYFoHUw6pPWLWQnC3gS=6=3k6nvf6tggw@mail.gmail.com>
Subject: Re: mc13xxx-core: kernel hangs after 'regmap_read'
From: Fabio Estevam <festevam@gmail.com>
To: marc@cpdesign.com.au
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        =?UTF-8?Q?Philippe_R=C3=A9tornaz?= <philippe.retornaz@epfl.ch>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2012 at 10:12 PM, Fabio Estevam <festevam@gmail.com> wrote:

> The sequence that shows the problem is:
>
> mc13xxx_spi_probe
> mc13xxx_common_init
> mc13xxx_identify
> mc13xxx_reg_read
> regmap_read (kernel hangs)

If I do the following:

--- a/drivers/mfd/mc13xxx-spi.c
+++ b/drivers/mfd/mc13xxx-spi.c
@@ -72,8 +72,6 @@ static int mc13xxx_spi_probe(struct spi_device *spi)
                return -ENOMEM;

        dev_set_drvdata(&spi->dev, mc13xxx);
-       spi->mode = SPI_MODE_0 | SPI_CS_HIGH;
-       spi->bits_per_word = 32;

        mc13xxx->dev = &spi->dev;
        mutex_init(&mc13xxx->lock);

Then this allows the kernel to boot at least (of course the mc13xxx
probe will fail in this case).

Mark,

Should the spi->mode and spi->bits_per_word be passed differently?

Maybe via "struct regmap_config" ?
