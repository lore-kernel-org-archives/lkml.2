Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241Ab2IXLLq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 07:11:46 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:33922 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877Ab2IXLLo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 07:11:44 -0400
MIME-Version: 1.0
In-Reply-To: <505FB01C.4060905@gmail.com>
References: <1348296014.12906.2.camel@phoenix> <505FB01C.4060905@gmail.com>
From: Bryan Wu <bryan.wu@canonical.com>
Date: Mon, 24 Sep 2012 19:11:22 +0800
X-Google-Sender-Auth: tLT9TjiJdqbvtQcD1q5E4ecfhBc
Message-ID: <CAK5ve-+eHrp7wW5fotjpa2bcN8HkzLdV1VPHJUTGHjtkpYunRg@mail.gmail.com>
Subject: Re: [PATCH] leds: lm3642: Use regmap_update_bits() in lm3642_chip_init()
To: gshark <gshark.jeong@gmail.com>
Cc: Axel Lin <axel.lin@ingics.com>, Richard Purdie <rpurdie@rpsys.net>,
        linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=EUC-KR
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2012 at 8:58 AM, gshark <gshark.jeong@gmail.com> wrote:
> 2012년 09월 22일 15:40, Axel Lin 쓴 글:
>
>> Use regmap_update_bits() to replace regmap_read() + regmap_write().
>> With this patch, we only show the error message when regmap_update_bits()
>> fails.
>
>     Looks good..You're right.  Thank you Alex.
>>
>>
>> Signed-off-by: Axel Lin <axel.lin@ingics.com>
>
>     Acked-by: G.Shark Jeong<gshark.jeong@gmail.com>
>

Thanks, applied to my for-next.

-Bryan


>> ---
>>   drivers/leds/leds-lm3642.c |   15 +++------------
>>   1 file changed, 3 insertions(+), 12 deletions(-)
>>
>> diff --git a/drivers/leds/leds-lm3642.c b/drivers/leds/leds-lm3642.c
>> index 924853b..3285006 100644
>> --- a/drivers/leds/leds-lm3642.c
>> +++ b/drivers/leds/leds-lm3642.c
>> @@ -95,23 +95,14 @@ struct lm3642_chip_data {
>>   /* chip initialize */
>>   static int __devinit lm3642_chip_init(struct lm3642_chip_data *chip)
>>   {
>> -       unsigned int reg_val;
>>         int ret;
>>         struct lm3642_platform_data *pdata = chip->pdata;
>>         /* set enable register */
>> -       ret = regmap_read(chip->regmap, REG_ENABLE, &reg_val);
>> +       ret = regmap_update_bits(chip->regmap, REG_ENABLE,
>> EX_PIN_ENABLE_MASK,
>> +                                pdata->tx_pin);
>>         if (ret < 0)
>> -               goto out;
>> -
>> -       reg_val &= (~EX_PIN_ENABLE_MASK);
>> -       reg_val |= pdata->tx_pin;
>> -       ret = regmap_write(chip->regmap, REG_ENABLE, reg_val);
>> -       if (ret < 0)
>> -               goto out;
>> -
>> -out:
>> -       dev_err(chip->dev, "Failed to read REG_ENABLE Register\n");
>> +               dev_err(chip->dev, "Failed to update REG_ENABLE
>> Register\n");
>>         return ret;
>>   }
>>
>
>



-- 
Bryan Wu <bryan.wu@canonical.com>
Kernel Developer    +86.186-168-78255 Mobile
Canonical Ltd.      www.canonical.com
Ubuntu - Linux for human beings | www.ubuntu.com
