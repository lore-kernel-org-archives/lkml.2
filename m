Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911Ab1KUKuo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 05:50:44 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:12074 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754035Ab1KUKun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 05:50:43 -0500
X-AuditID: cbfee61a-b7c61ae0000027a6-15-4eca2d01fb45
From: Kukjin Kim <kgene.kim@samsung.com>
To: jhbird.choi@samsung.com, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org
Cc: "'Alessandro Zummo'" <a.zummo@towertech.it>, akpm@linux-foundation.org
References: <1320747253-9281-1-git-send-email-jhbird.choi@samsung.com>
In-reply-to: <1320747253-9281-1-git-send-email-jhbird.choi@samsung.com>
Subject: RE: [PATCH] driver/rtc/rtc-s3c: Fix driver clock enable/disable
 balance issues
Date: Mon, 21 Nov 2011 19:50:41 +0900
Message-id: <03e901cca83b$69a48bf0$3ceda3d0$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: AcyeAicZiHwS4IxSRSesfSdl3b5AKgKOKwuw
Content-language: ko
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

jhbird.choi@samsung.com wrote:
> 
> From: Jonghwan Choi <jhbird.choi@samsung.com>
> 
> If an error occurs after clock is enabled, it can become unbalanced.
> 
> Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>

Cc: stable@kernel.org
Acked-by: Kukjin Kim <kgene.kim@samsung.com>

(Cc'ed Andrew Morton)

Hi Andrew,

If you're ok with this, could you please pick this up in your tree?

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

> ---
>  drivers/rtc/rtc-s3c.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/rtc/rtc-s3c.c b/drivers/rtc/rtc-s3c.c
> index 7639ab9..5b979d9 100644
> --- a/drivers/rtc/rtc-s3c.c
> +++ b/drivers/rtc/rtc-s3c.c
> @@ -202,7 +202,6 @@ static int s3c_rtc_settime(struct device *dev, struct
rtc_time
> *tm)
>  	void __iomem *base = s3c_rtc_base;
>  	int year = tm->tm_year - 100;
> 
> -	clk_enable(rtc_clk);
>  	pr_debug("set time %04d.%02d.%02d %02d:%02d:%02d\n",
>  		 1900 + tm->tm_year, tm->tm_mon, tm->tm_mday,
>  		 tm->tm_hour, tm->tm_min, tm->tm_sec);
> @@ -214,6 +213,7 @@ static int s3c_rtc_settime(struct device *dev, struct
rtc_time
> *tm)
>  		return -EINVAL;
>  	}
> 
> +	clk_enable(rtc_clk);
>  	writeb(bin2bcd(tm->tm_sec),  base + S3C2410_RTCSEC);
>  	writeb(bin2bcd(tm->tm_min),  base + S3C2410_RTCMIN);
>  	writeb(bin2bcd(tm->tm_hour), base + S3C2410_RTCHOUR);
> --
> 1.7.1

