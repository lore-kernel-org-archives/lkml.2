Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475Ab1C2Ou2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 10:50:28 -0400
Received: from mprc.pku.edu.cn ([162.105.203.9]:59587 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750991Ab1C2Ou1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 10:50:27 -0400
From: "Guan Xuetao" <gxt@mprc.pku.edu.cn>
To: <a.zummo@towertech.it>, "john stultz" <johnstul@us.ibm.com>,
        "Thomas Gleixner" <tglx@linutronix.de>
Cc: "Arnd Bergmann" <arnd@arndb.de>, <linux-kernel@vger.kernel.org>,
        <rtc-linux@googlegroups.com>
References: 
In-Reply-To: 
Subject: RE: [PATCH] unicore32 rtc driver fix: cleanup irq_set_freq and irq_set_state
Date: Tue, 29 Mar 2011 22:49:12 +0800
Message-ID: <019901cbee20$78c93ed0$6a5bbc70$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AcvuH0Ye8MupKhvVQsiNdfhYLTAWSAAAG7vA
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While modifying my code, I found something error to the modification for drivers/rtc/rtc-s3c.c.
When cleanup irq_set_state,  s3c_rtc_setpie() is removed.
However, the function is still used inside the file.

Guan Xuetao

> -----Original Message-----
> From: Guan Xuetao [mailto:gxt@mprc.pku.edu.cn]
> Sent: Tuesday, March 29, 2011 10:44 PM
> To: 'a.zummo@towertech.it'; john stultz (johnstul@us.ibm.com); Thomas Gleixner (tglx@linutronix.de)
> Cc: Arnd Bergmann (arnd@arndb.de); 'Guan Xuetao' (gxt@mprc.pku.edu.cn); 'linux-kernel@vger.kernel.org'; 'rtc-
> linux@googlegroups.com'
> Subject: [PATCH] unicore32 rtc driver fix: cleanup irq_set_freq and irq_set_state
> 
> 
> Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
> ---
>  arch/unicore32/kernel/rtc.c |    9 ---------
>  1 files changed, 0 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/unicore32/kernel/rtc.c b/arch/unicore32/kernel/rtc.c
> index c5f0682..8cad70b 100644
> --- a/arch/unicore32/kernel/rtc.c
> +++ b/arch/unicore32/kernel/rtc.c
> @@ -88,11 +88,6 @@ static int puv3_rtc_setpie(struct device *dev, int enabled)
>  	return 0;
>  }
> 
> -static int puv3_rtc_setfreq(struct device *dev, int freq)
> -{
> -	return 0;
> -}
> -
>  /* Time read/write */
> 
>  static int puv3_rtc_gettime(struct device *dev, struct rtc_time *rtc_tm)
> @@ -214,8 +209,6 @@ static const struct rtc_class_ops puv3_rtcops = {
>  	.set_time	= puv3_rtc_settime,
>  	.read_alarm	= puv3_rtc_getalarm,
>  	.set_alarm	= puv3_rtc_setalarm,
> -	.irq_set_freq	= puv3_rtc_setfreq,
> -	.irq_set_state	= puv3_rtc_setpie,
>  	.proc	        = puv3_rtc_proc,
>  };
> 
> @@ -294,8 +287,6 @@ static int puv3_rtc_probe(struct platform_device *pdev)
> 
>  	puv3_rtc_enable(pdev, 1);
> 
> -	puv3_rtc_setfreq(&pdev->dev, 1);
> -
>  	/* register RTC and exit */
> 
>  	rtc = rtc_device_register("pkunity", &pdev->dev, &puv3_rtcops,
> --
> 1.6.2.2


