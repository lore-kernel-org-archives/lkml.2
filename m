Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759755Ab1JGJ4n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 05:56:43 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:49978 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759736Ab1JGJ4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 05:56:41 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Eric Miao <eric.y.miao@gmail.com>
Subject: Re: [PATCH 08/26] ARM: pxa: move z2 to generic cpu_suspend
Date: Fri, 7 Oct 2011 11:56:38 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jason Chagas <jason.chagas@marvell.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>
References: <1317499438-14058-1-git-send-email-arnd@arndb.de> <1317499438-14058-9-git-send-email-arnd@arndb.de> <CAMPhdO-tz2HgBYQGOUW6hrA6fC=x+CQJ3dwbW_0AazFB=cjvbA@mail.gmail.com>
In-Reply-To: <CAMPhdO-tz2HgBYQGOUW6hrA6fC=x+CQJ3dwbW_0AazFB=cjvbA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201110071156.38283.arnd@arndb.de>
X-Provags-ID: V02:K0:hfHL1mLYZ19TpsqtpCLwYcJyIbQJDrWu0a1LMX7nObB
 brmBjppEqFTLLe49bgjJ5X7p6nQXauflxV90/VVZEzFyHKp3oZ
 b9Cbk6F9SOxAsIDt0q4yp77RIY1iAtetp9pWIk6sV9P33zulQq
 KVKF6FzlxYMMAGPvVQer/0Vqcg0KYwWck3P55wFjwAPzTmlpI2
 0Eo2EtNJkjhIAAN7NhuCTA4puhLwGF+YoxYpBjZjqGCj8EKT5B
 TZEw3pgqdZtGzJ1QRxXPSgpNdETRcGRIdN3TyAwwdqIn6fmTE4
 f+SOHHfNXumVLAdpF7t4OYWfQmDIztySPuolJt5s1okw4OgXrA
 x22AHaeRbkSSIPgo9JVY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 October 2011, Eric Miao wrote:
> commit 3f7961cbd3428c8639d42d1a51870466e4cbb0eb
> Author: Eric Miao <eric.y.miao@gmail.com>
> Date:   Sun Sep 11 17:19:11 2011 +0800
> 
>     ARM: pxa/z2: fix building error of pxa27x_cpu_suspend() no longer available
> 
>     Cc: Vasily Khoruzhick <anarsoul@gmail.com>
>     Signed-off-by: Eric Miao <eric.y.miao@gmail.com>
> 
> diff --git a/arch/arm/mach-pxa/z2.c b/arch/arm/mach-pxa/z2.c
> index 6c9275a..6fa4e74 100644
> --- a/arch/arm/mach-pxa/z2.c
> +++ b/arch/arm/mach-pxa/z2.c
> @@ -679,6 +679,8 @@ static inline void z2_pmic_init(void) {}
>  #endif
> 
>  #ifdef CONFIG_PM
> +extern void pxa27x_cpu_pm_enter(suspend_state_t state);
> +
>  static void z2_power_off(void)
>  {
>         /* We're using deep sleep as poweroff, so clear PSPR to ensure that

You really shouldn't have an extern declaration in a .c file. Otherwise
looks good to me.

	Arnd
