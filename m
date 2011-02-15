Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917Ab1BOAWZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 19:22:25 -0500
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:35849 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753819Ab1BOAWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 19:22:20 -0500
Message-ID: <4D59C725.20408@metafoo.de>
Date: Tue, 15 Feb 2011 01:21:57 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101226 Icedove/3.0.11
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
CC: Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] leds: make *struct gpio_led_platform_data.leds const
References: <1295430466-3250-1-git-send-email-u.kleine-koenig@pengutronix.de> <20110214195802.GI13279@pengutronix.de>
In-Reply-To: <20110214195802.GI13279@pengutronix.de>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14/2011 08:58 PM, Uwe Kleine-König wrote:
> Hello Richard,
> 
> On Wed, Jan 19, 2011 at 10:47:46AM +0100, Uwe Kleine-König wrote:
>> ... and fix a typo.
>>
>> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> ping
> 

Andrew Morton merges patches for the LED subsystem these days, so adding him to Cc.


>> ---
>>  drivers/leds/leds-net5501.c |    2 +-
>>  include/linux/leds.h        |    4 ++--
>>  2 files changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/leds/leds-net5501.c b/drivers/leds/leds-net5501.c
>> index 1739557..7e764b8 100644
>> --- a/drivers/leds/leds-net5501.c
>> +++ b/drivers/leds/leds-net5501.c
>> @@ -19,7 +19,7 @@
>>  
>>  #include <asm/geode.h>
>>  
>> -static struct gpio_led net5501_leds[] = {
>> +static const struct gpio_led net5501_leds[] = {
>>  	{
>>  		.name = "error",
>>  		.gpio = 6,
>> diff --git a/include/linux/leds.h b/include/linux/leds.h
>> index 0f19df9..383811d 100644
>> --- a/include/linux/leds.h
>> +++ b/include/linux/leds.h
>> @@ -194,11 +194,11 @@ struct gpio_led {
>>  
>>  struct gpio_led_platform_data {
>>  	int 		num_leds;
>> -	struct gpio_led *leds;
>> +	const struct gpio_led *leds;
>>  
>>  #define GPIO_LED_NO_BLINK_LOW	0	/* No blink GPIO state low */
>>  #define GPIO_LED_NO_BLINK_HIGH	1	/* No blink GPIO state high */
>> -#define GPIO_LED_BLINK		2	/* Plase, blink */
>> +#define GPIO_LED_BLINK		2	/* Please, blink */
>>  	int		(*gpio_blink_set)(unsigned gpio, int state,
>>  					unsigned long *delay_on,
>>  					unsigned long *delay_off);
>> -- 
>> 1.7.2.3
>>
>>
> 

