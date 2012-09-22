Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754211Ab2IVDxm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 23:53:42 -0400
Received: from mprc.pku.edu.cn ([162.105.203.9]:39517 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752597Ab2IVDxl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 23:53:41 -0400
From: guanxuetao@mprc.pku.edu.cn
Message-ID: <50847.162.105.203.8.1348282590.squirrel@mprc.pku.edu.cn>
In-Reply-To: <1347956633-15667-3-git-send-email-thierry.reding@avionic-design.de>
References: <1347956633-15667-1-git-send-email-thierry.reding@avionic-design.de>
    <1347956633-15667-3-git-send-email-thierry.reding@avionic-design.de>
Date: Sat, 22 Sep 2012 10:56:30 +0800 (CST)
Subject: Re: [PATCH v2 2/5] unicore32: pwm: Use module_platform_driver()
To: "Thierry Reding" <thierry.reding@avionic-design.de>
Cc: "Guan Xuetao" <gxt@mprc.pku.edu.cn>, "Qin Rui" <qinrui@mprc.pku.edu.cn>,
        linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.8-4.0.1.el5
MIME-Version: 1.0
Content-Type: text/plain;charset=GB2312
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Some of the boilerplate code can be eliminated by using this macro. The
> driver was previously registered with an arch_initcall(), so technically
> this is no longer the same, but when the driver is moved to the PWM
> framework, deferred probing will take care of any driver probe ordering
> issues.
>
> Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>

Tested-by: Qin Rui <qinrui@mprc.pku.edu.cn>
Acked-by: Guan Xuetao <gxt@mprc.pku.edu.cn>

Thanks & Regards,
Guan Xuetao

> ---
>  arch/unicore32/kernel/pwm.c | 21 +--------------------
>  1 file changed, 1 insertion(+), 20 deletions(-)
>
> diff --git a/arch/unicore32/kernel/pwm.c b/arch/unicore32/kernel/pwm.c
> index 885bbcd..012c54a 100644
> --- a/arch/unicore32/kernel/pwm.c
> +++ b/arch/unicore32/kernel/pwm.c
> @@ -254,25 +254,6 @@ static struct platform_driver puv3_pwm_driver = {
>  	.probe		= puv3_pwm_probe,
>  	.remove		= __devexit_p(pwm_remove),
>  };
> -
> -static int __init pwm_init(void)
> -{
> -	int ret = 0;
> -
> -	ret = platform_driver_register(&puv3_pwm_driver);
> -	if (ret) {
> -		printk(KERN_ERR "failed to register puv3_pwm_driver\n");
> -		return ret;
> -	}
> -
> -	return ret;
> -}
> -arch_initcall(pwm_init);
> -
> -static void __exit pwm_exit(void)
> -{
> -	platform_driver_unregister(&puv3_pwm_driver);
> -}
> -module_exit(pwm_exit);
> +module_platform_driver(puv3_pwm_driver);
>
>  MODULE_LICENSE("GPL v2");
> --
> 1.7.12
>

