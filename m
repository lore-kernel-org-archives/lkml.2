Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932364Ab1JRMHv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 08:07:51 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:35420 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932332Ab1JRMHo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 08:07:44 -0400
MIME-Version: 1.0
In-Reply-To: <4E9D3999.1080802@cam.ac.uk>
References: <1318926486-10330-1-git-send-email-ricardo.ribalda@gmail.com>
 <1318926486-10330-2-git-send-email-ricardo.ribalda@gmail.com> <4E9D3999.1080802@cam.ac.uk>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Tue, 18 Oct 2011 14:07:04 +0200
Message-ID: <CAPybu_0_31N-v2h2oM3-yEod=gAu1dn2gG2mO2UFgDWNN9kQuQ@mail.gmail.com>
Subject: Re: [PATCH 1/5] input/cma3000_d0x: Support devices without pdata
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: dmitry.torokhov@gmail.com, sameo@linux.intel.com, peter.ujfalusi@ti.com,
        aghayal@codeaurora.org, david@hardeman.nu, Shubhrajyoti@ti.com,
        saaguirre@ti.com, hemanthv@ti.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Jonathan

 Thanks for your fast reply :)

> I'm not that familiar with DT yet, but surely there is a means to supplying
> the equivalent data?  I'd prefer to see that provided here as well.

If you check the file drivers/of/of_spi.c you can see that only reg,
spi-cpha, spi-cpol, spi-cs-high, spi-max-freq and irq is imported
straight from the DT, that is why I created the default configuration.

I can give it a second thought, but I think it wont hurt to have a
per-default configuration.

>> +
>>  struct cma3000_accl_data {
>>       const struct cma3000_bus_ops *bus_ops;
>>       const struct cma3000_platform_data *pdata;
>> @@ -283,19 +295,24 @@ EXPORT_SYMBOL(cma3000_resume);
>>  struct cma3000_accl_data *cma3000_init(struct device *dev, int irq,
>>                                      const struct cma3000_bus_ops *bops)
>>  {
>> -     const struct cma3000_platform_data *pdata = dev->platform_data;
>> +     const struct cma3000_platform_data *pdata;
> Leave this line alone....
>>       struct cma3000_accl_data *data;
>>       struct input_dev *input_dev;
>>       int rev;
>>       int error;
>>
>> +     if (!dev->platform_data) {
>> +             dev_info(dev, "platform data not found, using default\n");
>> +             pdata = &cma3000_default_pdata;
>> +     } else
>> +             pdata = dev->platform_data;
>> +
> and this becomes
>
> if (pdata == NULL) {
>        dev_info(dev, "platform data not found, using default\n");
>        pdata = &cma3000_default_pdata;
> }
>
>>       if (!pdata) {
>>               dev_err(dev, "platform data not found\n");
>>               error = -EINVAL;
>>               goto err_out;
>>       }
> This can't happen now so get rid of the test.
>>
>> -
>>       /* if no IRQ return error */
>>       if (irq == 0) {
>>               error = -EINVAL;
>
>

Ready on the new version of the patch.


 Thanks again



-- 
Ricardo Ribalda
