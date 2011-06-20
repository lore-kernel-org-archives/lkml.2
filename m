Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751714Ab1FTFRC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 01:17:02 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55384 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770Ab1FTFRB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 01:17:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=IrSu6Ad8QxSbLhrDLL7j/DmikGU9qq7oYOtPIqmSWhYHqYVR7BBs4ZJIY+8XAUYLtr
         mWZMTu4JqFuhYpxQyR3328QLkU7TIa8tNl+67+xRxlz4u0l3dU/eYv2+623AWHz3fznK
         yJztaNJ4xNWIA94b/2esbRayp6JcM3rEWutvY=
MIME-Version: 1.0
Reply-To: myungjoo.ham@gmail.com
In-Reply-To: <20110618150612.GA25163@sirena.org.uk>
References: <1308213003-6526-1-git-send-email-myungjoo.ham@samsung.com>
	<20110618150612.GA25163@sirena.org.uk>
Date: Mon, 20 Jun 2011 14:16:59 +0900
X-Google-Sender-Auth: jVBlegtsb_FP1I-_nYmttAorQSo
Message-ID: <BANLkTimHWJ=qgQOxQtBQd9u6-euf79PJTA@mail.gmail.com>
Subject: Re: [PATCH 1/2] Samsung SoC ADC: use regulator (VDD for ADC).
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-arm-kernel@lists.infradead.org, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        dg77.kim@samsung.com, kyungmin.park@samsung.com,
        Ben Dooks <ben-linux@fluff.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sun, Jun 19, 2011 at 12:06 AM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Thu, Jun 16, 2011 at 05:30:02PM +0900, MyungJoo Ham wrote:
>
>> +     adc->vdd = regulator_get(dev, S3C_ADC_REGULATOR_NAME);
>
> I'm not convinced that the #define for the name is terribly good style
> here, especially given that you actually call it vdd in the code.

Then, would it be fine to use as [ regulator_get(dev, "vdd"); ] ?

>
>> +     if (IS_ERR_OR_NULL(adc->vdd)) {
>> +             dev_dbg(dev, "operating without regulator %s.\n", S3C_ADC_REGULATOR_NAME);
>> +             adc->vdd = NULL; /* Do not control regulator */
>> +     }
>> +
>
> No, don't do this.  Just unconditionally assume the regulator is present
> if power is essential for use of the device.  The regulator API will
> stub out correctly if it's not in use to allow things to proceed and if
> vdd is genuinely not hooked up then the driver can't function.

This ADC driver is for every ADC from S3C24xx series to Exynos4 (and
its successors as well).
The regulator (VDD for ADC) is essential for the recent chips
(S5PC110, S5PV210, and Exynos4).
I was just worried about the old boards using the same ADC driver
(mach-s3c2410/mach-*.c, mach-s3c6410/mach-*.c, and so on) without
ADC-VDD regulators defined.

However, no s3c compliance defconfigs have ever used CONFIG_REGULATOR.
Thus, it seems that it's safe to enforce using "vdd" with regulators
in plat-samsung's ADC driver.
I'll proceed as you have commented.

>
>> +     if (adc->vdd)
>> +             regulator_enable(adc->vdd);
>
> You're not checking the return value here or anywhere else after the
> inital get().
>

Ok. I'll let it handle errors from regulator_enable.


Thank you!

- MyungJoo.
-- 
MyungJoo Ham (함명주), Ph.D.
Mobile Software Platform Lab,
Digital Media and Communications (DMC) Business
Samsung Electronics
cell: 82-10-6714-2858
