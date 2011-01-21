Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753659Ab1AUAQf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 19:16:35 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:49449 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752946Ab1AUAQe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 19:16:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Oj5qCoyh/Xn5Rf/pqGlIacpLEE3yDX8z0dSobs5FdDBH/qmuBE4a5gcV1idPSvyb0T
         qPQy0FssAaIRWamgu60r2Wfbip9+Ofj1r7h+gKdEOamApKbw+ISHUTMkjIfOE3zC18r5
         jh6sPRSz3Qmc5hO9TYObQi67srKD86HBbkAR4=
MIME-Version: 1.0
In-Reply-To: <1295560051-4054-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1295560051-4054-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Date: Fri, 21 Jan 2011 09:16:32 +0900
X-Google-Sender-Auth: d3xhvVPkx8hsql5x8M8hz3SSlo0
Message-ID: <AANLkTikj4MntQj+YN=D+8W=6XtcMbh3OVKS_b4tP-2dq@mail.gmail.com>
Subject: Re: [PATCH] mfd: Staticise non-exported symbols in MAX8998 driver
From: Kyungmin Park <kyungmin.park@samsung.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Kyungmin Park <kyungmin.park@samsung.com>

On Fri, Jan 21, 2011 at 6:47 AM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> No need to have them in the global namespace and sparse complains.
>
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/max8998.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/mfd/max8998.c b/drivers/mfd/max8998.c
> index bbfe867..c002142 100644
> --- a/drivers/mfd/max8998.c
> +++ b/drivers/mfd/max8998.c
> @@ -233,7 +233,7 @@ struct max8998_reg_dump {
>        u8      val;
>  };
>  #define SAVE_ITEM(x)   { .addr = (x), .val = 0x0, }
> -struct max8998_reg_dump max8998_dump[] = {
> +static struct max8998_reg_dump max8998_dump[] = {
>        SAVE_ITEM(MAX8998_REG_IRQM1),
>        SAVE_ITEM(MAX8998_REG_IRQM2),
>        SAVE_ITEM(MAX8998_REG_IRQM3),
> @@ -298,7 +298,7 @@ static int max8998_restore(struct device *dev)
>        return 0;
>  }
>
> -const struct dev_pm_ops max8998_pm = {
> +static const struct dev_pm_ops max8998_pm = {
>        .suspend = max8998_suspend,
>        .resume = max8998_resume,
>        .freeze = max8998_freeze,
> --
> 1.7.2.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
