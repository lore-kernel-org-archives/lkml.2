Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753709Ab1B1Lud (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 06:50:33 -0500
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:38240 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753100Ab1B1Luc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 06:50:32 -0500
Message-ID: <4D6B8C02.10402@ti.com>
Date: Mon, 28 Feb 2011 17:20:26 +0530
From: Shubhrajyoti <shubhrajyoti@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101208 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Kevin Hilman <khilman@ti.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] bh1780gli : Convert to dev pm ops
References: <1295346162-6800-1-git-send-email-shubhrajyoti@ti.com> <87tygx3jik.fsf@ti.com>
In-Reply-To: <87tygx3jik.fsf@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kevin,

On Tuesday 25 January 2011 06:08 AM, Kevin Hilman wrote:
> shubhrajyoti@ti.com writes:
>
>> From: Shubhrajyoti Datta<shubhrajyoti@ti.com>
>>
>> Signed-off-by: Shubhrajyoti Datta<shubhrajyoti@ti.com>
>> ---
>>   drivers/misc/bh1780gli.c |   20 ++++++++++----------
>>   1 files changed, 10 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/misc/bh1780gli.c b/drivers/misc/bh1780gli.c
>> index d5f3a3f..07224ae 100644
>> --- a/drivers/misc/bh1780gli.c
>> +++ b/drivers/misc/bh1780gli.c
>> @@ -196,10 +196,11 @@ static int __devexit bh1780_remove(struct i2c_client *client)
>>   }
>>
>>   #ifdef CONFIG_PM
>> -static int bh1780_suspend(struct i2c_client *client, pm_message_t mesg)
>> +static int bh1780_suspend(struct device *dev)
>>   {
>>   	struct bh1780_data *ddata;
>>   	int state, ret;
>> +	struct i2c_client *client = to_i2c_client(dev);
>>
>>   	ddata = i2c_get_clientdata(client);
>>   	state = bh1780_read(ddata, BH1780_REG_CONTROL, "CONTROL");
>> @@ -217,14 +218,14 @@ static int bh1780_suspend(struct i2c_client *client, pm_message_t mesg)
>>   	return 0;
>>   }
>>
>> -static int bh1780_resume(struct i2c_client *client)
>> +static int bh1780_resume(struct device *dev)
>>   {
>>   	struct bh1780_data *ddata;
>>   	int state, ret;
>> +	struct i2c_client *client = to_i2c_client(dev);
>>
>>   	ddata = i2c_get_clientdata(client);
>>   	state = ddata->power_state;
>> -
>>   	ret = bh1780_write(ddata, BH1780_REG_CONTROL, state,
>>   				"CONTROL");
>>
>> @@ -233,9 +234,7 @@ static int bh1780_resume(struct i2c_client *client)
>>
>>   	return 0;
>>   }
>> -#else
>> -#define bh1780_suspend NULL
>> -#define bh1780_resume NULL
>> +static SIMPLE_DEV_PM_OPS(bh1780_pm, bh1780_suspend, bh1780_resume);
> Rather, keep the #else here with a NULL pm_ops ptr so you don't need the
> #ifdef below.
>
> Kevin
I agree with the comment. Just sent a patch trying to address it.
>>   #endif /* CONFIG_PM */
>>
>>   static const struct i2c_device_id bh1780_id[] = {
>> @@ -247,11 +246,12 @@ static struct i2c_driver bh1780_driver = {
>>   	.probe		= bh1780_probe,
>>   	.remove		= bh1780_remove,
>>   	.id_table	= bh1780_id,
>> -	.suspend	= bh1780_suspend,
>> -	.resume		= bh1780_resume,
>>   	.driver = {
>> -		.name = "bh1780"
>> -	},
>> +		.name = "bh1780",
>> +#ifdef CONFIG_PM
>> +		.pm	=&bh1780_pm,
>> +#endif
>> +},
>>   };
>>
>>   static int __init bh1780_init(void)

