Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753455Ab2LaHOu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2012 02:14:50 -0500
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:52481 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752943Ab2LaHOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2012 02:14:49 -0500
Message-ID: <50E13BBA.1000801@metafoo.de>
Date: Mon, 31 Dec 2012 08:16:10 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Icedove/3.0.11
MIME-Version: 1.0
To: Yuanhan Liu <yuanhan.liu@linux.intel.com>
CC: linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Jonathan Cameron <jic23@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] staging:iio:adis16260: select IIO_ADIS_LIB to fix build
 error
References: <1356932195-31437-1-git-send-email-yuanhan.liu@linux.intel.com>
In-Reply-To: <1356932195-31437-1-git-send-email-yuanhan.liu@linux.intel.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/31/2012 06:36 AM, Yuanhan Liu wrote:
> Commit 9d5e9fdf turned the code to use adis library, so it depends on
> adis lib. But it forgot to select it at Kconfig file. Thus if adis is
> not enabled, it will produce following build errros(catched by Fengguang's
> 0-DAY kernel build testing system):
>   ERROR: "adis_initial_startup" [drivers/staging/iio/gyro/adis16260.ko] undefined!
>   ERROR: "adis_init" [drivers/staging/iio/gyro/adis16260.ko] undefined!
>   ERROR: "adis_write_reg" [drivers/staging/iio/gyro/adis16260.ko] undefined!
>   ERROR: "adis_read_reg" [drivers/staging/iio/gyro/adis16260.ko] undefined!
>   ERROR: "adis_single_conversion" [drivers/staging/iio/gyro/adis16260.ko] undefined!
> 
> Selecting IIO_ADIS_LIB at Kconfig file fixes this issue.
> 
> Reported-by: Fengguang Wu <fengguang.wu@intel.com>
> Cc: Lars-Peter Clausen <lars@metafoo.de>
> Cc: Jonathan Cameron <jic23@kernel.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>

Hi,

Thanks. But I already sent a similar patch some time ago. See
http://www.spinics.net/lists/linux-iio/msg07128.html

- Lars

> ---
>  drivers/staging/iio/gyro/Kconfig |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/staging/iio/gyro/Kconfig b/drivers/staging/iio/gyro/Kconfig
> index ea295b2..476207a 100644
> --- a/drivers/staging/iio/gyro/Kconfig
> +++ b/drivers/staging/iio/gyro/Kconfig
> @@ -27,6 +27,7 @@ config ADIS16130
>  config ADIS16260
>  	tristate "Analog Devices ADIS16260 Digital Gyroscope Sensor SPI driver"
>  	depends on SPI
> +	select IIO_ADIS_LIB
>  	select IIO_TRIGGER if IIO_BUFFER
>  	select IIO_SW_RING if IIO_BUFFER
>  	help

