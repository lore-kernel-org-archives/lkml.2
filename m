Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757953Ab1FVCsz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 22:48:55 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53665 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757737Ab1FVCsx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 22:48:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=D3eBaVZmlnCqNxaS72g4Ww3WVQ3Uj9wIMp9V7i5UblWhukhJ6tRlWVTsc7qGFiyQBm
         LragGR1MjYi2mx61ciQTa4zPTl8QM1O88p6mXrgZ+1Nlq+uXtIhuyQSmGoMQ8Zn+4+TE
         R9MsI2gLaUSE9OkOAX2UK2zgxolMFADieyeSw=
MIME-Version: 1.0
Reply-To: myungjoo.ham@gmail.com
In-Reply-To: <20110621104357.GE22177@opensource.wolfsonmicro.com>
References: <20110620101737.GA31864@opensource.wolfsonmicro.com>
	<1308621527-2457-1-git-send-email-myungjoo.ham@samsung.com>
	<1308621527-2457-2-git-send-email-myungjoo.ham@samsung.com>
	<20110621104357.GE22177@opensource.wolfsonmicro.com>
Date: Wed, 22 Jun 2011 11:40:46 +0900
X-Google-Sender-Auth: dIlbkfq64I1IDRVxxh6XSfxRLZo
Message-ID: <BANLkTinQYV8FJsy+5_sU8sTBhYPC7AQPow@mail.gmail.com>
Subject: Re: [PATCH v2 1/5] Samsung SoC ADC: use regulator (VDD for ADC).
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>,
        Kyungmin Park <kyungmin.park@samsung.com>, dg77.kim@samsung.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 21, 2011 at 7:43 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Tue, Jun 21, 2011 at 10:58:43AM +0900, MyungJoo Ham wrote:
>
>> +     ret = regulator_enable(adc->vdd);
>> +     if (!ret)
>> +             goto err_ioremap;
>> +
>
> This test looks the wrong way round?  regulator_enable() should return 0
> on success but this will treat that as an error.

Whoops.. thanks for pointing that out!

>
>>  static int s3c_adc_resume(struct platform_device *pdev)
>>  {
>>       struct adc_device *adc = platform_get_drvdata(pdev);
>> +     int ret;
>>
>> +     ret = regulator_enable(adc->vdd);
>>       clk_enable(adc->clk);
>>       enable_irq(adc->irq);
>>
>>       writel(adc->prescale | S3C2410_ADCCON_PRSCEN,
>>              adc->regs + S3C2410_ADCCON);
>>
>> -     return 0;
>> +     return ret;
>
> Seems better to return as soon as we notice the error, no point in
> starting anything else up if we don't have power.
>

Ok. I see.



-- 
MyungJoo Ham (함명주), Ph.D.
Mobile Software Platform Lab,
Digital Media and Communications (DMC) Business
Samsung Electronics
cell: 82-10-6714-2858
