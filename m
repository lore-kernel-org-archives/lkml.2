Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755030Ab1JYHjB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 03:39:01 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:41912 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754062Ab1JYHi6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 03:38:58 -0400
MIME-Version: 1.0
In-Reply-To: <20111024213104.GA4394@ponder.secretlab.ca>
References: <1319487676-27181-1-git-send-email-ricardo.ribalda@gmail.com>
 <1319487676-27181-2-git-send-email-ricardo.ribalda@gmail.com> <20111024213104.GA4394@ponder.secretlab.ca>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Tue, 25 Oct 2011 09:38:18 +0200
Message-ID: <CAPybu_3EPJYd1EdzgF1oF6_k8u5nr4Kx1zmdPRXNZ_zcACrUEw@mail.gmail.com>
Subject: Re: [PATCHv4 1/6] input/cma3000_d0x: Support devices without pdata
To: Grant Likely <grant.likely@secretlab.ca>
Cc: dmitry.torokhov@gmail.com, sameo@linux.intel.com, peter.ujfalusi@ti.com,
        jic23@cam.ac.uk, aghayal@codeaurora.org, david@hardeman.nu,
        Shubhrajyoti@ti.com, saaguirre@ti.com, hemanthv@ti.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Grant

>> ---
>
> Drop this line, git cuts everything below a '---' line from the commit text.

Done, thanks

>
> This binding needs documentation before it can be merged.

Documentation/input/cma3000_d0x.txt is the right place ?

>
> No of_device_id match table to match against compatible values?

I think it is not needed, the device will be matched against the
driver cma3000_d0x_spi.c and AFAIK on the spi/i2c devices you dont
need the device_id match. But you know much more about this :).  Can
you point me to a example where a spi driver uses of_device-id match.

>
>> +
>>  struct cma3000_accl_data *cma3000_init(struct device *dev, int irq,
>>                                      const struct cma3000_bus_ops *bops)
>>  {
>> -     const struct cma3000_platform_data *pdata = dev->platform_data;
>> +     struct cma3000_platform_data *pdata;
>>       struct cma3000_accl_data *data;
>>       struct input_dev *input_dev;
>>       int rev;
>>       int error;
>>
>> -     if (!pdata) {
>> -             dev_err(dev, "platform data not found\n");
>> -             error = -EINVAL;
>> -             goto err_out;
>> -     }
>> -
>> -
>>       /* if no IRQ return error */
>>       if (irq == 0) {
>>               error = -EINVAL;
>> @@ -309,10 +357,26 @@ struct cma3000_accl_data *cma3000_init(struct device *dev, int irq,
>>               goto err_free_mem;
>>       }
>>
>> +     /*Init platform data*/
>> +     if (dev->platform_data != NULL) {
>> +             memcpy(&data->pdata, dev->platform_data, sizeof(data->pdata));
>> +     } else {
>> +             memcpy(&data->pdata, &cma3000_default_pdata,
>> +                             sizeof(data->pdata));
>> +             #ifdef CONFIG_OF
>> +             if (dev->of_node != NULL)
>> +                     cma3000_get_pdata_of(dev, data);
>> +              else
>> +                     dev_info(dev, "platform data not found, using default\n");
>> +             #else
>> +             dev_info(dev, "platform data not found, using default\n");
>> +             #endif
>> +     }
>> +     pdata = &data->pdata;
>> +
>>       data->dev = dev;
>>       data->input_dev = input_dev;
>>       data->bus_ops = bops;
>> -     data->pdata = pdata;
>>       data->irq = irq;
>>       mutex_init(&data->mutex);
>>
>> --
>> 1.7.7
>>
>



-- 
Ricardo Ribalda
