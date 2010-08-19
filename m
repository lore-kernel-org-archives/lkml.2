Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751163Ab0HSFIn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 01:08:43 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57753 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967Ab0HSFIk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 01:08:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=JtC9KWEnkxt4Z6u+tvt66su2o+UrXRmIJF3QpxAUHxqdCqRw3h2lfi0AZqvt4OCDYe
         vCdWZOePofNed2YqEjPzx73jYRir0Wv2giiO2khmLZ6WDjTJLAs+ErRYxO+NWkZsUsCn
         Tj5TwYj03ybjVeuK4X/IOjKBc0mculWI/bPZQ=
MIME-Version: 1.0
In-Reply-To: <20100802035422.GA2883@july>
References: <20100802035422.GA2883@july>
Date: Thu, 19 Aug 2010 14:08:39 +0900
X-Google-Sender-Auth: HOsAlAvlEFAHu-UlV5NbtbgKCY4
Message-ID: <AANLkTimkd5HLs7EyCX3--VO8fyJhXCBG-KMuG9wr0ZZk@mail.gmail.com>
Subject: Re: [PATCH] MFD: LP3974 PMIC support
From: Kyungmin Park <kmpark@infradead.org>
To: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>
Cc: m.szyprowski@samsung.com, broonie@opensource.wolfsonmicro.com,
        jy0922.shim@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Any comments? I hope it's included the 2.6.36 if possible.

Thank you,
Kyungmin Park

On Mon, Aug 2, 2010 at 12:54 PM, Kyungmin Park <kmpark@infradead.org> wrote:
> From: Kyungmin Park <kyungmin.park@samsung.com>
>
> LP3974 PMIC support. It has same functionality with max8998.
>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index db63d40..50383b1 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -303,6 +303,18 @@ config MFD_MAX8998
>          accessing the device, additional drivers must be enabled in order
>          to use the functionality of the device.
>
> +config MFD_LP3974
> +       bool "National Semiconductor LP3974 PMIC Support"
> +       depends on I2C=y
> +       select MFD_CORE
> +       select MFD_MAX8998
> +       help
> +         Say yes here to support for National Semiconductor LP3974. This is
> +         a Power Management IC. This driver provies common support for
> +         accessing the device, additional drivers must be enabled in order
> +         to use the functionality of the device.
> +         Note that it has same functionality with max8998.
> +
>  config MFD_WM8400
>        tristate "Support Wolfson Microelectronics WM8400"
>        select MFD_CORE
> diff --git a/drivers/mfd/max8998.c b/drivers/mfd/max8998.c
> index 0d68de2..cea9f48 100644
> --- a/drivers/mfd/max8998.c
> +++ b/drivers/mfd/max8998.c
> @@ -30,6 +30,11 @@
>  #include <linux/mfd/max8998.h>
>  #include <linux/mfd/max8998-private.h>
>
> +enum max8998_type {
> +       TYPE_MAX8998,
> +       TYPE_LP3974,
> +};
> +
>  static struct mfd_cell max8998_devs[] = {
>        {
>                .name = "max8998-pmic",
> @@ -127,8 +132,8 @@ static int max8998_i2c_remove(struct i2c_client *i2c)
>  }
>
>  static const struct i2c_device_id max8998_i2c_id[] = {
> -       { "max8998", 0 },
> -       { }
> +       { "max8998", TYPE_MAX8998 },
> +       { "lp3974", TYPE_LP3974 },
>  };
>  MODULE_DEVICE_TABLE(i2c, max8998_i2c_id);
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
