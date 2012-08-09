Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932410Ab2HIMjZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 08:39:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59143 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753741Ab2HIMjY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 08:39:24 -0400
Message-ID: <5023AF3A.9050206@redhat.com>
Date: Thu, 09 Aug 2012 09:38:18 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>
CC: David Rientjes <rientjes@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL for 3.6-rc1] media updates part 2
References: <5017F674.80404@redhat.com> <alpine.DEB.2.00.1208081526320.11542@chino.kir.corp.google.com> <5023A11C.50502@redhat.com> <5023A645.40308@redhat.com>
In-Reply-To: <5023A645.40308@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 09-08-2012 09:00, Hans de Goede escreveu:
> Hi,
> 
> My bad, sorry about this. Mauro's patch looks good.

Hmm...

menuconfig NEW_LEDS
	bool "LED Support"
	help
	  Say Y to enable Linux LED support.  This allows control of supported
	  LEDs from both userspace and optionally, by kernel events (triggers).

	  This is not related to standard keyboard LEDs which are controlled
	  via the input system.

if NEW_LEDS

config LEDS_CLASS
...


It seems that the patch also need to select or depend on NEW_LEDS.

> An alternative fix
> would be to #ifdefify the led code in the drivers themselves.

Yeah, that would work as well, although the code would look uglier.
IMHO, using select/depend is better.

Regards,
Mauro

> 
> Regards,
> 
> Hans
> 
> 
> On 08/09/2012 01:38 PM, Mauro Carvalho Chehab wrote:
>> Em 08-08-2012 19:28, David Rientjes escreveu:
>>> On Tue, 31 Jul 2012, Mauro Carvalho Chehab wrote:
>>>
>>>>         [media] radio-shark: New driver for the Griffin radioSHARK USB radio receiver
>>>
>>> This one gives me a build warning if CONFIG_LEDS_CLASS is disabled:
>>>
>>> ERROR: "led_classdev_register" [drivers/media/radio/shark2.ko] undefined!
>>> ERROR: "led_classdev_unregister" [drivers/media/radio/shark2.ko] undefined!
>>>
>>
>> Could you please test the enclosed patch?
>>
>> Thanks!
>> Mauro
>>
>> -
>>
>> [media] radio-shark: make sure LEDS_CLASS is selected
>>
>> As reported by David:
>>     > ERROR: "led_classdev_register" [drivers/media/radio/shark2.ko] undefined!
>>     > ERROR: "led_classdev_unregister" [drivers/media/radio/shark2.ko] undefined!
>>
>> Reported-by: Dadiv Rientjes <rientjes@google.com>
>> Cc: Hans de Goede <hdegoede@redhat.com>
>> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>>
>>
>> diff --git a/drivers/media/radio/Kconfig b/drivers/media/radio/Kconfig
>> index 8090b87..be68ec2 100644
>> --- a/drivers/media/radio/Kconfig
>> +++ b/drivers/media/radio/Kconfig
>> @@ -60,6 +60,7 @@ config RADIO_MAXIRADIO
>>   config RADIO_SHARK
>>       tristate "Griffin radioSHARK USB radio receiver"
>>       depends on USB && SND
>> +    select LEDS_CLASS
>>       ---help---
>>         Choose Y here if you have this radio receiver.
>>
>> @@ -77,6 +78,7 @@ config RADIO_SHARK
>>   config RADIO_SHARK2
>>       tristate "Griffin radioSHARK2 USB radio receiver"
>>       depends on USB
>> +    select LEDS_CLASS
>>       ---help---
>>         Choose Y here if you have this radio receiver.
>>
>>

