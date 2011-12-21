Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629Ab1LULZo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 06:25:44 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:24634 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176Ab1LULZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 06:25:40 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6566"; a="146499549"
Message-ID: <4EF1C230.6060005@codeaurora.org>
Date: Wed, 21 Dec 2011 16:55:36 +0530
From: Sujit Reddy Thumma <sthumma@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Dmitry Antipov <dmitry.antipov@linaro.org>
CC: linaro-dev@lists.linaro.org, patches@linaro.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mmc: use usleep_range() in mmc_delay()
References: <4EF18310.6080801@linaro.org>
In-Reply-To: <4EF18310.6080801@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21/2011 12:26 PM, Dmitry Antipov wrote:
>  From f447d78db65c6675e69466e8ed08364ff065ac08 Mon Sep 17 00:00:00 2001
> From: Dmitry Antipov <dmitry.antipov@linaro.org>
> Date: Wed, 21 Dec 2011 10:51:03 +0400
> Subject: [PATCH] mmc: use usleep_range() in mmc_delay()
>
> ---
> drivers/mmc/core/core.h | 8 ++------
> 1 files changed, 2 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/mmc/core/core.h b/drivers/mmc/core/core.h
> index 14664f1..a77851e 100644
> --- a/drivers/mmc/core/core.h
> +++ b/drivers/mmc/core/core.h
> @@ -47,12 +47,8 @@ void mmc_power_off(struct mmc_host *host);
>
> static inline void mmc_delay(unsigned int ms)
> {
> - if (ms < 1000 / HZ) {
> - cond_resched();
> - mdelay(ms);
> - } else {
> - msleep(ms);
> - }
> + unsigned long us = ms * USEC_PER_MSEC;
> + usleep_range(us, us + 1000);

I have posted similar patch some time back. 
http://comments.gmane.org/gmane.linux.ports.arm.msm/2119.

Would you like to comment on that?

Thanks,
Sujit

> }
>
> void mmc_rescan(struct work_struct *work);

