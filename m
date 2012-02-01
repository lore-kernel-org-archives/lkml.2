Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755591Ab2BABjB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 20:39:01 -0500
Received: from mail.redfish-solutions.com ([66.232.79.143]:55116 "EHLO
	mail.redfish-solutions.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754186Ab2BABjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 20:39:00 -0500
Message-ID: <4F289792.3000503@redfish-solutions.com>
Date: Tue, 31 Jan 2012 18:38:26 -0700
From: Philip Prindeville <philipp@redfish-solutions.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Alessandro Zummo <a.zummo@towertech.it>,
        Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] net5501: platform driver for Soekris Engineering
 net5501 single-board computer
References: <1325323722-25930-1-git-send-email-philipp@redfish-solutions.com> <1327726939-20845-1-git-send-email-philipp@redfish-solutions.com> <20120131141908.2c4c8b13.akpm@linux-foundation.org>
In-Reply-To: <20120131141908.2c4c8b13.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/31/12 3:19 PM, Andrew Morton wrote:
> On Fri, 27 Jan 2012 22:02:19 -0700
> Philip Prindeville <philipp@redfish-solutions.com> wrote:
> 
>> ---
>> Trivial platform driver for Soekris Engineering net5501 single-board
>> computer. Probes well-known locations in ROM for BIOS signature to
>> confirm correct platform. Registers 1 LED and 1 GPIO-based button
>> (typically used for soft reset).
>>
>> ...
>>
>>  arch/x86/Kconfig                  |    6 ++
>>  arch/x86/platform/geode/Makefile  |    1 +
>>  arch/x86/platform/geode/net5501.c |  154 +++++++++++++++++++++++++++++++++++++
>>  drivers/leds/leds-net5501.c       |   97 -----------------------
> 
> Forgot to clean up the leftovers:
> 
> make[2]: *** No rule to make target `drivers/leds/leds-net5501.c', needed by `drivers/leds/leds-net5501.o'.  Stop.
> 
> Also, are you sure that the new Kconfig entry is sufficient?  The old
> driver had more dependencies (GPIO_CS5535 and LEDS_TRIGGERS) and
> selects LEDS_TRIGGER_DEFAULT_ON.  Should the new driver be doing such
> things?

Thanks for getting that.  Overlooked it.

The thing about the way the platform driver is now is it can wait until the subordinate modules get loaded and it will register the relevant devices then...

It's conceivable that one might want LEDs but not the reset button, or vice versa.

It might make sense to have the GPIO_CS5535 driver be selected, but also I'm good with the platform driver being statically linked in, and the LED or GPIO drivers being insmod'd.

I figure best to KISS and allow people to have as small a static kernel as they want, and then build up functionality with modules.

-Philip

> 
> 
> --- a/drivers/leds/Kconfig~net5501-platform-driver-for-soekris-engineering-net5501-single-board-computer-fix
> +++ a/drivers/leds/Kconfig
> @@ -89,16 +89,6 @@ config LEDS_NET48XX
>  	  This option enables support for the Soekris net4801 and net4826 error
>  	  LED.
>  
> -config LEDS_NET5501
> -	tristate "LED Support for Soekris net5501 series Error LED"
> -	depends on LEDS_TRIGGERS
> -	depends on X86 && GPIO_CS5535
> -	select LEDS_TRIGGER_DEFAULT_ON
> -	default n
> -	help
> -	  Add support for the Soekris net5501 board (detection, error led
> -	  and GPIO).
> -
>  config LEDS_FSG
>  	tristate "LED Support for the Freecom FSG-3"
>  	depends on LEDS_CLASS
> --- a/drivers/leds/Makefile~net5501-platform-driver-for-soekris-engineering-net5501-single-board-computer-fix
> +++ a/drivers/leds/Makefile
> @@ -14,7 +14,6 @@ obj-$(CONFIG_LEDS_MIKROTIK_RB532)	+= led
>  obj-$(CONFIG_LEDS_S3C24XX)		+= leds-s3c24xx.o
>  obj-$(CONFIG_LEDS_AMS_DELTA)		+= leds-ams-delta.o
>  obj-$(CONFIG_LEDS_NET48XX)		+= leds-net48xx.o
> -obj-$(CONFIG_LEDS_NET5501)		+= leds-net5501.o
>  obj-$(CONFIG_LEDS_WRAP)			+= leds-wrap.o
>  obj-$(CONFIG_LEDS_COBALT_QUBE)		+= leds-cobalt-qube.o
>  obj-$(CONFIG_LEDS_COBALT_RAQ)		+= leds-cobalt-raq.o
> _
> 
> 
> 

