Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932945Ab0JVAIi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 20:08:38 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:47580 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315Ab0JVAIh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 20:08:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:from:date:message-id
         :subject:to:cc:content-type:content-transfer-encoding;
        b=l3qDG/Vc8vvd1hwsY2m3yFRtVH5Vj6DFz87I0IPT3Xo6fTPkhgIGEnHkV3wv0G0+NQ
         YfyfMfK6fkCoBiRqA0EPZ1A0E83IAUTkzY6Xlvof+qRvErVRki46p2DAEmGYNWtcOMOp
         ELXlVD+/lWn7FgksrEhjCQLzvsDQJC76fg5cY=
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <20101021225834.GF11685@sortiz-mobl>
References: <1287565604.7849.4.camel@mola> <20101021225834.GF11685@sortiz-mobl>
From: Axel Lin <axel.lin@gmail.com>
Date: Fri, 22 Oct 2010 08:08:16 +0800
Message-ID: <AANLkTimcQCp+2a59T81niJPGMUX8fE50Us_+Hw_c+JQo@mail.gmail.com>
Subject: Re: [PATCH] mfd: max8998 cleanups
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/10/22 Samuel Ortiz <sameo@linux.intel.com>:
> Hi Axel,
>
> On Wed, Oct 20, 2010 at 05:06:44PM +0800, Axel Lin wrote:
>> This patch includes below fixes:
>> 1. i2c_smbus_write_byte_data() returns zero or negative value,
>>    therefore no need to check if ret is greater than zero or not.
>> 2. Properly free irq and unregister max8998->rtc device in
>>    max8998_i2c_probe() error path and max8998_i2c_remove().
> The fixes make sense, I'd appreciate to get 2 separate patches for them
> though.
>
Ok. I will resend with 2 separate patches.

Regards,
Axel

> Cheers,
> Samuel.
>
>
>> Signed-off-by: Axel Lin <axel.lin@gmail.com>
>> ---
>>  drivers/mfd/max8998.c |    6 ++++--
>>  1 files changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/mfd/max8998.c b/drivers/mfd/max8998.c
>> index a720f41..bb9977b 100644
>> --- a/drivers/mfd/max8998.c
>> +++ b/drivers/mfd/max8998.c
>> @@ -110,8 +110,6 @@ int max8998_update_reg(struct i2c_client *i2c, u8 reg, u8 val, u8 mask)
>>               u8 old_val = ret & 0xff;
>>               u8 new_val = (val & mask) | (old_val & (~mask));
>>               ret = i2c_smbus_write_byte_data(i2c, reg, new_val);
>> -             if (ret >= 0)
>> -                     ret = 0;
>>       }
>>       mutex_unlock(&max8998->iolock);
>>       return ret;
>> @@ -155,6 +153,8 @@ static int max8998_i2c_probe(struct i2c_client *i2c,
>>
>>  err:
>>       mfd_remove_devices(max8998->dev);
>> +     max8998_irq_exit(max8998);
>> +     i2c_unregister_device(max8998->rtc);
>>       kfree(max8998);
>>       return ret;
>>  }
>> @@ -164,6 +164,8 @@ static int max8998_i2c_remove(struct i2c_client *i2c)
>>       struct max8998_dev *max8998 = i2c_get_clientdata(i2c);
>>
>>       mfd_remove_devices(max8998->dev);
>> +     max8998_irq_exit(max8998);
>> +     i2c_unregister_device(max8998->rtc);
>>       kfree(max8998);
>>
>>       return 0;
>> --
>> 1.7.2
>>
>>
>>
>
> --
> Intel Open Source Technology Centre
> http://oss.intel.com/
>
