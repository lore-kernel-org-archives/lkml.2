Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757895Ab2IRKAP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 06:00:15 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:59028 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757868Ab2IRKAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 06:00:13 -0400
MIME-Version: 1.0
In-Reply-To: <D958900912E20642BCBC71664EFECE3E6DDEFB947B@BGMAIL02.nvidia.com>
References: <1347961843-9376-1-git-send-email-shubhrajyoti@ti.com>
	<1347961843-9376-7-git-send-email-shubhrajyoti@ti.com>
	<D958900912E20642BCBC71664EFECE3E6DDEFB947B@BGMAIL02.nvidia.com>
Date: Tue, 18 Sep 2012 15:30:10 +0530
Message-ID: <CAM=Q2cv8R8QUbV2UqNO+AbwgprAYxBtBjK=4rkHnqegGJWTdog@mail.gmail.com>
Subject: Re: [PATCHv2 6/6] media: Convert struct i2c_msg initialization to C99 format
From: Shubhrajyoti Datta <omaplinuxkernel@gmail.com>
To: Venu Byravarasu <vbyravarasu@nvidia.com>
Cc: Shubhrajyoti D <shubhrajyoti@ti.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "julia.lawall@lip6.fr" <julia.lawall@lip6.fr>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2012 at 3:26 PM, Venu Byravarasu <vbyravarasu@nvidia.com> wrote:
>> -----Original Message-----
>> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
>> owner@vger.kernel.org] On Behalf Of Shubhrajyoti D
>> Sent: Tuesday, September 18, 2012 3:21 PM
>> To: linux-media@vger.kernel.org
>> Cc: linux-kernel@vger.kernel.org; julia.lawall@lip6.fr; Shubhrajyoti D
>> Subject: [PATCHv2 6/6] media: Convert struct i2c_msg initialization to C99
>> format
>>
>>         Convert the struct i2c_msg initialization to C99 format. This makes
>>         maintaining and editing the code simpler. Also helps once other fields
>>         like transferred are added in future.
>>
>> Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>
>> ---
>>  drivers/media/i2c/msp3400-driver.c |   42
>> ++++++++++++++++++++++++++++++-----
>>  1 files changed, 36 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/media/i2c/msp3400-driver.c
>> b/drivers/media/i2c/msp3400-driver.c
>> index aeb22be..b8cef8d 100644
>> --- a/drivers/media/i2c/msp3400-driver.c
>> +++ b/drivers/media/i2c/msp3400-driver.c
>> @@ -119,12 +119,32 @@ int msp_reset(struct i2c_client *client)
>>       static u8 write[3]     = { I2C_MSP_DSP + 1, 0x00, 0x1e };
>>       u8 read[2];
>>       struct i2c_msg reset[2] = {
>> -             { client->addr, I2C_M_IGNORE_NAK, 3, reset_off },
>> -             { client->addr, I2C_M_IGNORE_NAK, 3, reset_on  },
>> +             {
>> +                     .addr = client->addr,
>> +                     .flags = I2C_M_IGNORE_NAK,
>> +                     .len = 3,
>> +                     .buf = reset_off
>> +             },
>> +             {
>> +                     .addr = client->addr,
>> +                     .flags = I2C_M_IGNORE_NAK,
>> +                     .len = 3,
>> +                     .buf = reset_on
>> +             },
>>       };
>>       struct i2c_msg test[2] = {
>> -             { client->addr, 0,        3, write },
>> -             { client->addr, I2C_M_RD, 2, read  },
>> +             {
>> +                     .addr = client->addr,
>> +                     .flags = 0,
>
> Does flags not contain 0 by default?
>

It does however I felt that 0 means write so letting it be explicit.

In case a removal is preferred that's doable too however felt it is
more readable this way.
