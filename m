Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752290Ab2DBKUP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 06:20:15 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:1282 "EHLO sjogate2.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751840Ab2DBKUO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 06:20:14 -0400
Message-ID: <4F797D4D.3060703@atmel.com>
Date: Mon, 02 Apr 2012 12:19:57 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120310 Thunderbird/11.0
MIME-Version: 1.0
To: Sergei Shtylyov <sshtylyov@mvista.com>
CC: linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        plagnioj@jcrosoft.com, ludovic.desroches@atmel.com,
        linux-kernel@vger.kernel.org, arnd@arndb.de, olof@lixom.net
Subject: Re: [PATCH 03/12] ARM: at91/USB host: specify and handle properly
 vbus_pin_active_low
References: <cover.1333026637.git.nicolas.ferre@atmel.com> <ce442f466ded5a4c75a0fc15700dc14fe60b91d8.1333026637.git.nicolas.ferre@atmel.com> <4F777C6F.2070603@mvista.com>
In-Reply-To: <4F777C6F.2070603@mvista.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31/2012 11:51 PM, Sergei Shtylyov :
> Hello.
> 
> On 29-03-2012 17:27, Nicolas Ferre wrote:
> 
>> Due to an error while handling vbus_pin_active_low in ohci-at91 driver,
>> the specification of this property was not good in devices/board files.
> 
>> Signed-off-by: Nicolas Ferre<nicolas.ferre@atmel.com>
>> Acked-by: Jean-Christophe PLAGNIOL-VILLARD<plagnioj@jcrosoft.com>
>> Cc: stable<stable@vger.kernel.org>          [3.2+]
>> ---
>>   arch/arm/mach-at91/at91sam9263_devices.c |    3 ++-
>>   arch/arm/mach-at91/at91sam9g45_devices.c |    6 ++++--
>>   arch/arm/mach-at91/board-sam9263ek.c     |    1 +
>>   arch/arm/mach-at91/board-sam9m10g45ek.c  |    1 +
>>   4 files changed, 8 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/arm/mach-at91/at91sam9263_devices.c
>> b/arch/arm/mach-at91/at91sam9263_devices.c
>> index 53688c4..5cdca89d 100644
>> --- a/arch/arm/mach-at91/at91sam9263_devices.c
>> +++ b/arch/arm/mach-at91/at91sam9263_devices.c
>> @@ -72,7 +72,8 @@ void __init at91_add_device_usbh(struct
>> at91_usbh_data *data)
>>       /* Enable VBus control for UHP ports */
>>       for (i = 0; i<  data->ports; i++) {
>>           if (gpio_is_valid(data->vbus_pin[i]))
>> -            at91_set_gpio_output(data->vbus_pin[i], 0);
>> +            at91_set_gpio_output(data->vbus_pin[i],
>> +                         data->vbus_pin_active_low[i] ^ 0);
> 
>    Note that XOR with 0 is a nop, left operand doesn't change its value.

Sure I will correct that.

Thanks, best regards,
-- 
Nicolas Ferre
