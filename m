Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752019Ab2FLHXz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 03:23:55 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:61049 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458Ab2FLHXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 03:23:53 -0400
Message-ID: <4FD6EE85.2090207@linaro.org>
Date: Tue, 12 Jun 2012 08:23:49 +0100
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: Wolfram Sang <w.sang@pengutronix.de>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, arnd@arndb.de, grant.likely@secretlab.ca,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH 09/14] i2c: Add Device Tree support to the Nomadik I2C
 driver
References: <1339428307-3850-1-git-send-email-lee.jones@linaro.org> <1339428307-3850-10-git-send-email-lee.jones@linaro.org> <20120611190550.GK3887@pengutronix.de>
In-Reply-To: <20120611190550.GK3887@pengutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/12 20:05, Wolfram Sang wrote:
> On Mon, Jun 11, 2012 at 04:25:02PM +0100, Lee Jones wrote:
>> Here we move the i2c-nomadik's default settings into the driver
>> rather than specifying them from platform code. At the time of
>> this writing we only have one user, the u8500. As new users are
>> added, it is expected that they will be Device Tree compliant.
>> If this is the case, we will look up their initialisation values
>> by compatible entry, then apply them forthwith.
>>
>> Cc: linux-i2c@vger.kernel.org
>> Acked-by: Linus Walleij<linus.walleij@linaro.org>
>> Signed-off-by: Lee Jones<lee.jones@linaro.org>
>> ---
>>   drivers/i2c/busses/i2c-nomadik.c |   40 +++++++++++++++++++++++++++++++++++++-
>>   1 file changed, 39 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/i2c/busses/i2c-nomadik.c b/drivers/i2c/busses/i2c-nomadik.c
>> index a92440d..1ffdf67 100644
>> --- a/drivers/i2c/busses/i2c-nomadik.c
>> +++ b/drivers/i2c/busses/i2c-nomadik.c
>> @@ -23,6 +23,7 @@
>>   #include<linux/io.h>
>>   #include<linux/regulator/consumer.h>
>>   #include<linux/pm_runtime.h>
>> +#include<linux/of_device.h>
>>
>>   #include<plat/i2c.h>
>>
>> @@ -899,15 +900,51 @@ static const struct i2c_algorithm nmk_i2c_algo = {
>>   	.functionality	= nmk_i2c_functionality
>>   };
>>
>> +static struct nmk_i2c_controller u8500_i2c = {
>> +       /*
>> +        * slave data setup time, which is
>> +        * 250 ns,100ns,10ns which is 14,6,2
>> +        * respectively for a 48 Mhz
>> +        * i2c clock
>> +        */
>> +       .slsu           = 0xe,
>> +       /* Tx FIFO threshold */
>
> Please put these comments directly after the members they describe.
>
> And make sure you use tabs for indentation all over the patch instead of
> spaces. checkpatch.pl will help you to get the formal things right.

My apologies. This section of code was a direct copy and paste from 
platform code (arch/arm/mach-ux500/board-mop500.c). It must have lost 
some formatting en route. I'll make the changes you request and re-post.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
M: +44 77 88 633 515
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
