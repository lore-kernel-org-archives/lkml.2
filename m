Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755075Ab2CAR1K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 12:27:10 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:47693 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754281Ab2CAR1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 12:27:08 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-1
Date: Thu, 01 Mar 2012 18:27:05 +0100
From: Karol Lewandowski <k.lewandowsk@samsung.com>
Subject: Re: [PATCH 3/3] [media] s5p-tv: Add initial DT-support for TV mixer
In-reply-to: <CAJuYYwSYtSzbxjtCBbXxHp33Zo+-4=YrA+LVZvOe=X8-c+vxJQ@mail.gmail.com>
To: Thomas Abraham <thomas.abraham@linaro.org>
Cc: t.stanislaws@samsung.com, m.szyprowski@samsung.com,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-samsung-soc@vger.kernel.org
Message-id: <4F4FB169.6030606@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111109 Icedove/8.0
References: <1330527107-21222-1-git-send-email-k.lewandowsk@samsung.com>
 <1330527107-21222-4-git-send-email-k.lewandowsk@samsung.com>
 <CAJuYYwSYtSzbxjtCBbXxHp33Zo+-4=YrA+LVZvOe=X8-c+vxJQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01.03.2012 04:18, Thomas Abraham wrote:

> On 29 February 2012 20:21, Karol Lewandowski <k.lewandowsk@samsung.com> wrote:
>> ---
>>  drivers/media/video/s5p-tv/mixer_drv.c |    9 +++++++++
>>  1 files changed, 9 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/media/video/s5p-tv/mixer_drv.c b/drivers/media/video/s5p-tv/mixer_drv.c
>> index a2c0c25..6bf4a9e 100644
>> --- a/drivers/media/video/s5p-tv/mixer_drv.c
>> +++ b/drivers/media/video/s5p-tv/mixer_drv.c
>> @@ -448,6 +448,14 @@ static int __devexit mxr_remove(struct platform_device *pdev)
>>        return 0;
>>  }
>>
>> +#ifdef CONFIG_OF
>> +static const struct of_device_id mxr_dt_match[] = {
>> +       { .compatible = "samsung,exynos4210-tvmixer" },
> 
> If the tvmixer module is also available in SoC's prior to Exynos4210,
> and if tvmixer in Exynos4210 is similar to tvmixer found on prior
> SoC's, the base version should indicate that. For instance, if the
> tvmixer started to appear from s5pv210 onwards, then the compatible
> value should be "samsung,s5pv210-tvmixer". The compatible string
> should indicate the base version.


Fair point, although I'm afraid that chosing "base" version might be
tricky sometimes (e.g. while g2d seems to be available on s5pv210 driver
itself have been tested only on s5pv310/exynos4210 - chosing s5pv210 as
base doesn't look like best idea.)

I'll resend fixed patches later.

Thank you very much for review!

Regards,
-- 
Karol Lewandowski | Samsung Poland R&D Center | Linux/Platform
