Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757365Ab1KPRMo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 12:12:44 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:35591 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753349Ab1KPRMn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 12:12:43 -0500
MIME-Version: 1.0
In-Reply-To: <1321434819-23678-3-git-send-email-lars@metafoo.de>
References: <1321434819-23678-1-git-send-email-lars@metafoo.de> <1321434819-23678-3-git-send-email-lars@metafoo.de>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 16 Nov 2011 10:12:20 -0700
X-Google-Sender-Auth: kUXu3AUmp4gm11o_SWuU67WbLH4
Message-ID: <CACxGe6toOFjOdP7-oZ4O2J=g2U+Y+aWOUzHDoCaX6goAs6zKsQ@mail.gmail.com>
Subject: Re: [PATCH 2/5] I2C: Add helper macro for i2c_driver boilerplate
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
> This patch introduces the module_i2c_driver macro which is a convenience macro
> for I2C driver modules similar to module_platform_driver. It is intended to be
> used by drivers which init/exit section does nothing but register/unregister
> the I2C driver. By using this macro it is possible to eliminate a few lines of
> boilerplate code per I2C driver.
>
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>

Acked-by: Grant Likely <grant.likely@secretlab.ca>

> ---
>  include/linux/i2c.h |   13 +++++++++++++
>  1 files changed, 13 insertions(+), 0 deletions(-)
>
> diff --git a/include/linux/i2c.h b/include/linux/i2c.h
> index a81bf6d..7e92854 100644
> --- a/include/linux/i2c.h
> +++ b/include/linux/i2c.h
> @@ -485,6 +485,19 @@ static inline int i2c_adapter_id(struct i2c_adapter *adap)
>  {
>        return adap->nr;
>  }
> +
> +/**
> + * module_i2c_driver() - Helper macro for registering a I2C driver
> + * @__i2c_driver: i2c_driver struct
> + *
> + * Helper macro for I2C drivers which do not do anything special in module
> + * init/exit. This eliminates a lot of boilerplate. Each module may only
> + * use this macro once, and calling it replaces module_init() and module_exit()
> + */
> +#define module_i2c_driver(__i2c_driver) \
> +       module_driver(__i2c_driver, i2c_add_driver, \
> +                       i2c_del_driver)
> +
>  #endif /* I2C */
>  #endif /* __KERNEL__ */
>
> --
> 1.7.7.1
>
>
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
