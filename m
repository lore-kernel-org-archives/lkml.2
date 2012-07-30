Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754346Ab2G3RGP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 13:06:15 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:17218 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754231Ab2G3RGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 13:06:14 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6788"; a="215972058"
Message-ID: <5016BF03.70805@codeaurora.org>
Date: Mon, 30 Jul 2012 10:06:11 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Venu Byravarasu <vbyravarasu@nvidia.com>
CC: "a.zummo@towertech.it" <a.zummo@towertech.it>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        "kyle.manna@fuel7.com" <kyle.manna@fuel7.com>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rtc: tps65910: Add RTC driver for TPS65910 PMIC RTC
References: <1343284519-30505-1-git-send-email-vbyravarasu@nvidia.com> <5016510B.9010202@codeaurora.org> <D958900912E20642BCBC71664EFECE3E6DDCAC4244@BGMAIL02.nvidia.com>
In-Reply-To: <D958900912E20642BCBC71664EFECE3E6DDCAC4244@BGMAIL02.nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/12 03:07, Venu Byravarasu wrote:
>
> +
> +static int __devinit tps65910_rtc_probe(struct platform_device *pdev)
> +{
> +	struct tps65910 *tps65910 = NULL;
> +	struct tps65910_rtc *tps_rtc = NULL;
> +	struct tps65910_board *pmic_plat_data;
> +	int ret = -EINVAL;
> +	int irq = 0;
> +	u32 rtc_reg;
>> It seems like all the above assignments are useless as they're
>> overwritten later in this function. Can you remove the assignments?
>>
> Some of the non-intelligent compilers/tools complain as variables 
> may get used uninitialized. Hence to avoid such complaints, initialized
> them to some default values.
> What harm do you see if I have local variables initialized during their declaration?

If you return early from a function and forget to give a variable a
value you actually want, you may use it pre-initialized with a bad
value. I would be surprised if a compiler complained about these ones
because they are simple assignments and they aren't under conditional
paths. If there is still a problem, you can use the uninitialized_var()
macro but I don't see why you would need to.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

