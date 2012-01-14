Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452Ab2ANJWp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jan 2012 04:22:45 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:57779 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752140Ab2ANJWn convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jan 2012 04:22:43 -0500
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <20120113141019.1fc1439e.akpm@linux-foundation.org>
References: <1326442521.5482.1.camel@phoenix> <20120113141019.1fc1439e.akpm@linux-foundation.org>
From: Axel Lin <axel.lin@gmail.com>
Date: Sat, 14 Jan 2012 17:22:20 +0800
Message-ID: <CAF+7xW=qATBpVy-wG6+Joq+LB19TmM6qJUxoOV0U7R8omLVrxw@mail.gmail.com>
Subject: Re: [PATCH] backlight: Fix the logic to set bits in adp8860_bl and
 adp8870_bl drivers
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
        Michael Hennerich <michael.hennerich@analog.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        device-drivers-devel@blackfin.uclinux.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> diff --git a/drivers/video/backlight/adp8860_bl.c b/drivers/video/backlight/adp8860_bl.c
>> index 66bc74d..378276c 100644
>> --- a/drivers/video/backlight/adp8860_bl.c
>> +++ b/drivers/video/backlight/adp8860_bl.c
>> @@ -146,7 +146,7 @@ static int adp8860_set_bits(struct i2c_client *client, int reg, uint8_t bit_mask
>>
>>       ret = adp8860_read(client, reg, &reg_val);
>>
>> -     if (!ret && ((reg_val & bit_mask) == 0)) {
>> +     if (!ret && ((reg_val & bit_mask) != bit_mask)) {
>>               reg_val |= bit_mask;
>>               ret = adp8860_write(client, reg, reg_val);
>>       }
>> diff --git a/drivers/video/backlight/adp8870_bl.c b/drivers/video/backlight/adp8870_bl.c
>> index 6c68a68..6735059 100644
>> --- a/drivers/video/backlight/adp8870_bl.c
>> +++ b/drivers/video/backlight/adp8870_bl.c
>> @@ -160,7 +160,7 @@ static int adp8870_set_bits(struct i2c_client *client, int reg, uint8_t bit_mask
>>
>>       ret = adp8870_read(client, reg, &reg_val);
>>
>> -     if (!ret && ((reg_val & bit_mask) == 0)) {
>> +     if (!ret && ((reg_val & bit_mask) != bit_mask)) {
>>               reg_val |= bit_mask;
>>               ret = adp8870_write(client, reg, reg_val);
>>       }
>
> This patch is applicable to 3.2.x, but I don't know whether to route it
> to -stable becasue you didn't tell me what effect the patch has :(
>

It's because I don't have this hardware.
I just found the bug while reading the code.

I was thinking I should CC stable, but since the code is there for a long time
and I don't know any complains of the bug. So I didn't CC stable.

Michael, do you see any user-visible effects of the bug?

Thanks,
Axel
