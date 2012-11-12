Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484Ab2KLOuo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 09:50:44 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:45020 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752979Ab2KLOun (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 09:50:43 -0500
Message-ID: <50A10CBC.1070102@ti.com>
Date: Mon, 12 Nov 2012 15:50:36 +0100
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121105 Thunderbird/16.0.1
MIME-Version: 1.0
To: <t-kristo@ti.com>
CC: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>,
        Thierry Reding <thierry.reding@avionic-design.de>
Subject: Re: [PATCH] MFD: twl-core: Fix chip ID for the twl6030-pwm module
References: <1351695277-8629-1-git-send-email-peter.ujfalusi@ti.com> <1351760981.8788.20.camel@sokoban>
In-Reply-To: <1351760981.8788.20.camel@sokoban>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,

On 11/01/2012 10:09 AM, Tero Kristo wrote:
> Acked-by: Tero Kristo <t-kristo@ti.com>

Can you take this patch for 3.7?

Thank you,
Péter

> 
> On Wed, 2012-10-31 at 15:54 +0100, Peter Ujfalusi wrote:
>> The correct chip id is 1 since the PWM module is on address 0x49. With the
>> current TWL6030_MODULE_ID1 the kernel will crash early since:
>> #define TWL6030_MODULE_ID1 0x0E
>> and
>> static struct twl_client twl_modules[4];
>>
>> Down in the stack we try to get the module by:
>> struct twl_client	*twl = &twl_modules[chip];
>>
>> Which obviously going to do nasty things.
>>
>> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
>> ---
>> Hi Samuel,
>>
>> Can you push this patch to 3.7?
>> Without this if the user enables the twl6030-pwm driver the kernel will not
>> going to boot on OMAP4.
>>
>> Thank you,
>> Peter
>>
>>  drivers/mfd/twl-core.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/mfd/twl-core.c b/drivers/mfd/twl-core.c
>> index 2624668..d7577cb 100644
>> --- a/drivers/mfd/twl-core.c
>> +++ b/drivers/mfd/twl-core.c
>> @@ -672,7 +672,7 @@ add_children(struct twl4030_platform_data *pdata, unsigned irq_base,
>>  	}
>>  
>>  	if (IS_ENABLED(CONFIG_PWM_TWL6030) && twl_class_is_6030()) {
>> -		child = add_child(TWL6030_MODULE_ID1, "twl6030-pwm", NULL, 0,
>> +		child = add_child(SUB_CHIP_ID1, "twl6030-pwm", NULL, 0,
>>  				  false, 0, 0);
>>  		if (IS_ERR(child))
>>  			return PTR_ERR(child);
> 
> 

