Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532Ab2GVT2Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 15:28:16 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:42226 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416Ab2GVT2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 15:28:15 -0400
Message-ID: <500C5445.3090900@kernel.org>
Date: Sun, 22 Jul 2012 20:28:05 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Devendra Naga <develkernel412222@gmail.com>
CC: Jonathan Cameron <jic23@cam.ac.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] staging/iio: use module_platform_driver macro
References: <1342860895-19401-1-git-send-email-develkernel412222@gmail.com>
In-Reply-To: <1342860895-19401-1-git-send-email-develkernel412222@gmail.com>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/21/2012 09:54 AM, Devendra Naga wrote:
> the code which under _init and _exit does only the platform_driver_register
> and platform_driver_unregister, and nothing else,
> so its better to use the module_platform_driver macro rather duplicating
> its implementation
> 
> Signed-off-by: Devendra Naga <develkernel412222@gmail.com>
Thanks.

Queued this up for when I resume sending pull requests to Greg
post merge window.
> ---
> 
>  drivers/staging/iio/iio_hwmon.c |   12 +-----------
>  1 file changed, 1 insertion(+), 11 deletions(-)
> 
> diff --git a/drivers/staging/iio/iio_hwmon.c b/drivers/staging/iio/iio_hwmon.c
> index 27d27ec..4bb017a 100644
> --- a/drivers/staging/iio/iio_hwmon.c
> +++ b/drivers/staging/iio/iio_hwmon.c
> @@ -215,17 +215,7 @@ static struct platform_driver __refdata iio_hwmon_driver = {
>  	.remove = __devexit_p(iio_hwmon_remove),
>  };
>  
> -static int iio_inkern_init(void)
> -{
> -	return platform_driver_register(&iio_hwmon_driver);
> -}
> -module_init(iio_inkern_init);
> -
> -static void iio_inkern_exit(void)
> -{
> -	platform_driver_unregister(&iio_hwmon_driver);
> -}
> -module_exit(iio_inkern_exit);
> +module_platform_driver(iio_hwmon_driver);
>  
>  MODULE_AUTHOR("Jonathan Cameron <jic23@cam.ac.uk>");
>  MODULE_DESCRIPTION("IIO to hwmon driver");
> 
