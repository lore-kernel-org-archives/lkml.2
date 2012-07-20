Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753402Ab2GTRFe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 13:05:34 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:45153 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753122Ab2GTRFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 13:05:33 -0400
MIME-Version: 1.0
In-Reply-To: <1342803648-15929-1-git-send-email-develkernel412222@gmail.com>
References: <1342803648-15929-1-git-send-email-develkernel412222@gmail.com>
Date: Fri, 20 Jul 2012 22:50:33 +0545
Message-ID: <CA+C2MxQ2RtU+FgubB-gLXQ31eWyPu+mKPmKK17pEzxWooAFc7A@mail.gmail.com>
Subject: Re: [PATCH] staging/android: use module_platform_driver
From: Devendra Naga <develkernel412222@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Axel Lin <axel.lin@gmail.com>,
        =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
        Tracey Dent <tdent48227@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: Devendra Naga <develkernel412222@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

oops forgot to add LKML,

On Fri, Jul 20, 2012 at 10:45 PM, Devendra Naga
<develkernel412222@gmail.com> wrote:
>
> as the init and exit functions just do a platform_driver_register and
> platform_driver_unregister, and nothing else, so its better to
> use the module_platform_driver macro rather replicating its implementation
>
> Signed-off-by: Devendra Naga <develkernel412222@gmail.com>
> ---
>  drivers/staging/android/timed_gpio.c |   13 +------------
>  1 file changed, 1 insertion(+), 12 deletions(-)
>
> diff --git a/drivers/staging/android/timed_gpio.c
> b/drivers/staging/android/timed_gpio.c
> index 45c522c..e814514 100644
> --- a/drivers/staging/android/timed_gpio.c
> +++ b/drivers/staging/android/timed_gpio.c
> @@ -161,18 +161,7 @@ static struct platform_driver timed_gpio_driver = {
>         },
>  };
>
> -static int __init timed_gpio_init(void)
> -{
> -       return platform_driver_register(&timed_gpio_driver);
> -}
> -
> -static void __exit timed_gpio_exit(void)
> -{
> -       platform_driver_unregister(&timed_gpio_driver);
> -}
> -
> -module_init(timed_gpio_init);
> -module_exit(timed_gpio_exit);
> +module_platform_driver(timed_gpio_driver);
>
>  MODULE_AUTHOR("Mike Lockwood <lockwood@android.com>");
>  MODULE_DESCRIPTION("timed gpio driver");
> --
> 1.7.9.5
>
