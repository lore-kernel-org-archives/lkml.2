Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757377Ab1KPRNR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 12:13:17 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:37544 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753217Ab1KPRNQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 12:13:16 -0500
MIME-Version: 1.0
In-Reply-To: <1321434819-23678-4-git-send-email-lars@metafoo.de>
References: <1321434819-23678-1-git-send-email-lars@metafoo.de> <1321434819-23678-4-git-send-email-lars@metafoo.de>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 16 Nov 2011 10:12:54 -0700
X-Google-Sender-Auth: VmvDIvCeDHFQ4DXvna2wa_RIlQI
Message-ID: <CACxGe6tz0ppZj=a_e4rkgNxzhQ4MSCtXKXGk_dPov80QDU4MCg@mail.gmail.com>
Subject: Re: [PATCH 3/5] SPI: Add helper macro for spi_driver boilerplate
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Jean Delvare <khali@linux-fr.org>,
        Jonathan Cameron <jic23@kernel.org>,
        Michael Hennerich <Michael.Hennerich@analog.com>,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, spi-devel-general@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 16, 2011 at 2:13 AM, Lars-Peter Clausen <lars@metafoo.de> wrote:
> This patch introduces the module_spi_driver macro which is a convenience macro
> for SPI driver modules similar to module_platform_driver. It is intended to be
> used by drivers which init/exit section does nothing but register/unregister
> the SPI driver. By using this macro it is possible to eliminate a few lines of
> boilerplate code per SPI driver.
>
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>

Acked-by: Grant Likely <grant.likely@secretlab.ca>

> ---
>  include/linux/spi/spi.h |   11 +++++++++++
>  1 files changed, 11 insertions(+), 0 deletions(-)
>
> diff --git a/include/linux/spi/spi.h b/include/linux/spi/spi.h
> index bb4f5fb..176fce9 100644
> --- a/include/linux/spi/spi.h
> +++ b/include/linux/spi/spi.h
> @@ -200,6 +200,17 @@ static inline void spi_unregister_driver(struct spi_driver *sdrv)
>                driver_unregister(&sdrv->driver);
>  }
>
> +/**
> + * module_spi_driver() - Helper macro for registering a SPI driver
> + * @__spi_driver: spi_driver struct
> + *
> + * Helper macro for SPI drivers which do not do anything special in module
> + * init/exit. This eliminates a lot of boilerplate. Each module may only
> + * use this macro once, and calling it replaces module_init() and module_exit()
> + */
> +#define module_spi_driver(__spi_driver) \
> +       module_driver(__spi_driver, spi_register_driver, \
> +                       spi_unregister_driver)
>
>  /**
>  * struct spi_master - interface to SPI master controller
> --
> 1.7.7.1
>
>
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
