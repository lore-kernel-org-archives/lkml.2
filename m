Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751831Ab1FXC0f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 22:26:35 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:8741 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182Ab1FXC0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 22:26:34 -0400
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=UTF-8; format=flowed
X-AuditID: cbfee61a-b7c53ae000002dc1-f3-4e03f5d8b649
Date: Fri, 24 Jun 2011 11:26:41 +0900
From: Joonyoung Shim <jy0922.shim@samsung.com>
Subject: Re: [PATCH] INPUT:Add ABS_PRESSURE input event support for touchscreen
 driver
In-reply-to: <1308881738-6392-1-git-send-email-wdgvip@gmail.com>
To: Wu DaoGuang <wdgvip@gmail.com>
Cc: ben-linux@fluff.org, kgene.kim@samsung.com, dmitry.torokhov@gmail.com,
        wdgvip@gamil.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-input@vger.kernel.org
Message-id: <4E03F5E1.2020803@samsung.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.13)
 Gecko/20101207 Thunderbird/3.1.7
References: <1308881738-6392-1-git-send-email-wdgvip@gmail.com>
X-OriginalArrivalTime: 24 Jun 2011 02:25:48.0875 (UTC)
 FILETIME=[07D1A1B0:01CC3216]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-06-24 오전 11:15, Wu DaoGuang wrote:
> The touchscreen driver s3c2410_ts.c doesn't work well when using
> the tslib, an abstraction layer for touchscreen panel events.
> Tslib needs ABS_X ABS_Y and ABS_PRESSURE events to report, but only
> the former two the driver can provide.
>
> So this patch fixes the problem.
>
> Signed-off-by: Wu DaoGuang<wdgvip@gmail.com>
> ---
>   drivers/input/touchscreen/s3c2410_ts.c |    4 +++-
>   1 files changed, 3 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/input/touchscreen/s3c2410_ts.c b/drivers/input/touchscreen/s3c2410_ts.c
> index 8feb7f3..0cf4f12 100644
> --- a/drivers/input/touchscreen/s3c2410_ts.c
> +++ b/drivers/input/touchscreen/s3c2410_ts.c
> @@ -126,6 +126,7 @@ static void touch_timer_fire(unsigned long data)
>   			input_report_abs(ts.input, ABS_Y, ts.yp);
>
>   			input_report_key(ts.input, BTN_TOUCH, 1);
> +			input_report_abs(ts.input, ABS_PRESSURE, 1);
>   			input_sync(ts.input);
>
>   			ts.xp = 0;
> @@ -140,6 +141,7 @@ static void touch_timer_fire(unsigned long data)
>   		ts.count = 0;
>
>   		input_report_key(ts.input, BTN_TOUCH, 0);
> +		input_report_abs(ts.input, ABS_PRESSURE, 0);
>   		input_sync(ts.input);
>
>   		writel(WAIT4INT | INT_DOWN, ts.io + S3C2410_ADCTSC);
> @@ -318,7 +320,7 @@ static int __devinit s3c2410ts_probe(struct platform_device *pdev)
>   	ts.input->keybit[BIT_WORD(BTN_TOUCH)] = BIT_MASK(BTN_TOUCH);
>   	input_set_abs_params(ts.input, ABS_X, 0, 0x3FF, 0, 0);
>   	input_set_abs_params(ts.input, ABS_Y, 0, 0x3FF, 0, 0);
> -
> +	input_set_abs_params(ts.input, ABS_PRESSURE, 0, 1, 0, 0);
>   	ts.input->name = "S3C24XX TouchScreen";
>   	ts.input->id.bustype = BUS_HOST;
>   	ts.input->id.vendor = 0xDEAD;

This is already NAKed patch.

Please refer https://lkml.org/lkml/2010/11/9/270

Thanks.
