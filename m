Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753785Ab2GIUsq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 16:48:46 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:56680 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764Ab2GIUsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 16:48:45 -0400
Message-ID: <4FFB43A8.2070307@linaro.org>
Date: Mon, 09 Jul 2012 22:48:40 +0200
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>, sameo@linux.intel.com
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de
Subject: Re: [PATCH 1/1] mfd: ab8500: Clean-up the last two ab8500 related
 DT match tables
References: <1341578598-9307-1-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1341578598-9307-1-git-send-email-lee.jones@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sam,

I've just seen that you have a new for-next branch, but this patch is 
missing in it.

Just making sure you didn't miss it:

On 06/07/12 14:43, Lee Jones wrote:
> A patch was recently submitted to stop all ab8500 devices from
> being registered through Device Tree. Instead, only the db8500
> will be DT:ed and the rest will continue to be registered via
> the MFD API, as they always were.
>
> Two patches have recently been applied which enable Device Tree
> probing; one for rtc-ab8500 and the other for ponkey-ab8500.
> These two need to be removed to prevent double-probing these
> devices with Device Tree is enabled.
>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>   drivers/input/misc/ab8500-ponkey.c |    8 --------
>   drivers/rtc/rtc-ab8500.c           |    6 ------
>   2 files changed, 14 deletions(-)
>
> diff --git a/drivers/input/misc/ab8500-ponkey.c b/drivers/input/misc/ab8500-ponkey.c
> index 84ec691..5ceb23e 100644
> --- a/drivers/input/misc/ab8500-ponkey.c
> +++ b/drivers/input/misc/ab8500-ponkey.c
> @@ -132,18 +132,10 @@ static int __devexit ab8500_ponkey_remove(struct platform_device *pdev)
>   	return 0;
>   }
>
> -#ifdef CONFIG_OF
> -static const struct of_device_id ab8500_ponkey_match[] = {
> -	{ .compatible = "stericsson,ab8500-ponkey", },
> -	{}
> -};
> -#endif
> -
>   static struct platform_driver ab8500_ponkey_driver = {
>   	.driver		= {
>   		.name	= "ab8500-poweron-key",
>   		.owner	= THIS_MODULE,
> -		.of_match_table = of_match_ptr(ab8500_ponkey_match),
>   	},
>   	.probe		= ab8500_ponkey_probe,
>   	.remove		= __devexit_p(ab8500_ponkey_remove),
> diff --git a/drivers/rtc/rtc-ab8500.c b/drivers/rtc/rtc-ab8500.c
> index bf3c2f6..2e5970f 100644
> --- a/drivers/rtc/rtc-ab8500.c
> +++ b/drivers/rtc/rtc-ab8500.c
> @@ -462,16 +462,10 @@ static int __devexit ab8500_rtc_remove(struct platform_device *pdev)
>   	return 0;
>   }
>
> -static const struct of_device_id ab8500_rtc_match[] = {
> -	{ .compatible = "stericsson,ab8500-rtc", },
> -	{}
> -};
> -
>   static struct platform_driver ab8500_rtc_driver = {
>   	.driver = {
>   		.name = "ab8500-rtc",
>   		.owner = THIS_MODULE,
> -		.of_match_table = ab8500_rtc_match,
>   	},
>   	.probe	= ab8500_rtc_probe,
>   	.remove = __devexit_p(ab8500_rtc_remove),
>

Kind regards,
Lee

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
M: +44 77 88 633 515
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog


