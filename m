Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751819Ab0DLMiL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 08:38:11 -0400
Received: from mail-gx0-f217.google.com ([209.85.217.217]:37268 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462Ab0DLMiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 08:38:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=JpphYBN4sdughf6er2A5dMZ2TPkR0izkargzvqEavBUbVA7Eb9wKEPGk8+BzEvxqtz
         PiZSGHOfqiWUzvAZVLo4eRRX2vTi7UoDrGsUDGyakvugWM1vZnbI+qDvYnksV3+gsdGE
         pScQYVvF/eBicoTU6QdOuU0RDaedIrQlCvLbE=
Message-ID: <4BC31427.3000200@boichat.ch>
Date: Mon, 12 Apr 2010 20:37:59 +0800
From: Nicolas Boichat <nicolas@boichat.ch>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100313 Thunderbird/3.0.3
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: "Justin P. Mattock" <justinmattock@gmail.com>,
       linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] [PATCH]BUG FIX: hwmon applesmc.c add iMac9,  1 and
 MacBookPro2, 2 to fix bug 14429
References: <1271022202-4348-1-git-send-email-justinmattock@gmail.com> <20100412094541.21910420@hyperion.delvare>
In-Reply-To: <20100412094541.21910420@hyperion.delvare>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean,

On 04/12/2010 03:45 PM, Jean Delvare wrote:
> Hi Justin,
>
> On Sun, 11 Apr 2010 14:43:22 -0700, Justin P. Mattock wrote:
>> This patch adds the iMac9,1 and the MacBookPro2,2
>> temperature sensors to hwmon applesmc.c to fix bug entry:
>> https://bugzilla.kernel.org/show_bug.cgi?id=14429
>
> Nicely filled under component IA64, no surprise I didn't see it. I've
> just fixed it.
>
>> Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
>> ---
>>   drivers/hwmon/applesmc.c |   18 ++++++++++++++++++
>>   1 files changed, 18 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/hwmon/applesmc.c b/drivers/hwmon/applesmc.c
>> index c1605b5..5e762ac 100644
>> --- a/drivers/hwmon/applesmc.c
>> +++ b/drivers/hwmon/applesmc.c
>> @@ -142,6 +142,12 @@ static const char *temperature_sensors_sets[][41] = {
>>   	  "TM1S", "TM2P", "TM2S", "TM3S", "TM8P", "TM8S", "TM9P", "TM9S",
>>   	  "TN0C", "TN0D", "TN0H", "TS0C", "Tp0C", "Tp1C", "Tv0S", "Tv1S",
>>   	  NULL },
>> +/* Set 17: iMac9,1 */
>> +	{ "TA0P", "TC0D", "TC0H", "TC0P", "TG0D", "TG0H", "TH0P", "TL0P",
>> +	  "TN0D", "TN0H", "TN0P", "TO0P", "Tm0P", "Tp0P", NULL },
>> +/* Set 18: MacBookPro2,2 */
>> +	{ "TB0T", "TC0D", "TC0P", "TG0H", "TG0P", "TG0T", "TM0P", "TTF0",
>> +	  "Th0H", "Th1H", "Tm0P", "Ts0P", NULL },
>>   };
>>
>>   /* List of keys used to read/write fan speeds */
>> @@ -1350,6 +1356,10 @@ static __initdata struct dmi_match_data applesmc_dmi_data[] = {
>>   	{ .accelerometer = 1, .light = 1, .temperature_set = 15 },
>>   /* MacPro3,1: temperature set 16 */
>>   	{ .accelerometer = 0, .light = 0, .temperature_set = 16 },
>> +/* iMac9,1: light sensor only, temperature set 17 */
>> +	{ .accelerometer = 0, .light = 0, .temperature_set = 17 },
>> +/* MacBookPro2,2: accelerometer, backlight and temperature set 18 */
>> +	{ .accelerometer = 1, .light = 1, .temperature_set = 18 },
>>   };
>>
>>   /* Note that DMI_MATCH(...,"MacBook") will match "MacBookPro1,1".
>> @@ -1375,6 +1385,10 @@ static __initdata struct dmi_system_id applesmc_whitelist[] = {
>>   	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
>>   	  DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro3") },
>>   		&applesmc_dmi_data[9]},
>> +	{ applesmc_dmi_match, "Apple MacBookPro2,2", {

I would put spaces in the name, to be consistent with the rest of the 
list, that is: "Apple MacBook Pro 2,2".

>> +	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple Computer, Inc."),
>> +	  DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro2,2") },
>> +		&applesmc_dmi_data[18]},
>>   	{ applesmc_dmi_match, "Apple MacBook Pro", {
>>   	  DMI_MATCH(DMI_BOARD_VENDOR,"Apple"),
>>   	  DMI_MATCH(DMI_PRODUCT_NAME,"MacBookPro") },
>> @@ -1415,6 +1429,10 @@ static __initdata struct dmi_system_id applesmc_whitelist[] = {
>>   	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
>>   	  DMI_MATCH(DMI_PRODUCT_NAME, "MacPro") },
>>   		&applesmc_dmi_data[4]},
>> +	{ applesmc_dmi_match, "Apple iMac9,1", {

Same here: "Apple iMac 9,1".

>> +	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple Inc."),
>> +	  DMI_MATCH(DMI_PRODUCT_NAME, "iMac9,1") },
>> +		&applesmc_dmi_data[17]},
>>   	{ applesmc_dmi_match, "Apple iMac 8", {
>>   	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
>>   	  DMI_MATCH(DMI_PRODUCT_NAME, "iMac8") },
>
> Patch applied, queued for 2.6.34, thanks.
>
> Nicolas, as the maintainer of this driver, I would like to get your
> ack, at least.

Apart from that, it looks fine to me, I haven't compiled nor tested it 
though (I don't own any Apple hardware anymore, maybe I should remove 
myself from the maintainer list...).

Acked-by: Nicolas Boichat <nicolas@boichat.ch>

Regards,

Nicolas
