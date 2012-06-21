Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932665Ab2FUJzV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 05:55:21 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:53447 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759212Ab2FUJzT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 05:55:19 -0400
MIME-Version: 1.0
In-Reply-To: <1339678763-14509-1-git-send-email-aletes.xgr@gmail.com>
References: <1339678763-14509-1-git-send-email-aletes.xgr@gmail.com>
Date: Thu, 21 Jun 2012 11:49:13 +0200
Message-ID: <CAMSQXEHOtgk7wRRqOdpMaTvpxFd1Cpom=BG65GheY6Z4p2Jc3A@mail.gmail.com>
Subject: Re: [PATCH] SPI: at25: Parse dt settings
From: Ivo Sieben <meltedpianoman@gmail.com>
To: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Chris Wright <chrisw@sous-sol.org>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Roland Stigge <stigge@antcom.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2012/6/14 Alexandre Pereira da Silva <aletes.xgr@gmail.com>:
> @@ -305,25 +305,54 @@ static ssize_t at25_mem_write(struct memory_accessor *mem, const char *buf,
> +       if (!spi->dev.platform_data) {
> +               if (np) {
> +                       u32 val;
> +
> +                       memset(&chip, 0, sizeof(chip));
> +                       strncpy(chip.name, np->name, 10);
> +
> +                       err = of_property_read_u32(np, "at25,byte-len", &val);
> +                       if (err) {
> +                               dev_dbg(&spi->dev, "invalid chip dt description\n");
> +                               goto fail;
> +                       }
> +                       chip.byte_len = val;
> +
> +                       err = of_property_read_u32(np, "at25,addr-mode", &val);
> +                       if (err) {
> +                               dev_dbg(&spi->dev, "invalid chip dt description\n");
> +                               goto fail;
> +                       }
> +                       chip.flags = (u16)val;
> +
> +                       err = of_property_read_u32(np, "at25,page-size", &val);
> +                       if (err) {
> +                               dev_dbg(&spi->dev, "invalid chip dt description\n");
> +                               goto fail;
> +                       }
> +                       chip.page_size = (u16)val;
> +               } else {
> +                       dev_dbg(&spi->dev, "no chip description\n");
> +                       err = -ENODEV;
> +                       goto fail;
> +               }
> +       } else
> +               chip = *(struct spi_eeprom *)spi->dev.platform_data;

One small remark:
In case of platform_data, the "if (!chip)" check has been removed and
is now only handled in the device tree initialization.
Maybe add this check to the platform initialization as well:

} else {
        if (!spi->dev.platform_data) {
                dev_dbg(&spi->dev, "no chip description\n");
                err = -ENODEV;
                goto fail;
        }
        chip =  *(struct spi_eeprom *)spi->dev.platform_data;
}

Furthermore looks good to me...
(Note: I am not familiar with device trees, so I cannot judge that
part of this patch)

Regards,
Ivo Sieben
