Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756629Ab1CRSc3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 14:32:29 -0400
Received: from mail1.nippynetworks.com ([91.220.24.129]:41999 "EHLO
	mail1.nippynetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753937Ab1CRScX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 14:32:23 -0400
Message-ID: <4D83A535.4090806@wildgooses.com>
Date: Fri, 18 Mar 2011 18:32:21 +0000
From: Ed W <lists@wildgooses.com>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.15) Gecko/20110303 Lightning/1.0b2 Thunderbird/3.1.9
MIME-Version: 1.0
To: grant.likely@secretlab.ca, dilinger@queued.net
CC: linux-geode@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] leds: New PCEngines Alix LED driver using gpio interface
References: <20110317181757.GM9597@angua.secretlab.ca> <1300471949-29366-1-git-send-email-kernel@wildgooses.com>
In-Reply-To: <1300471949-29366-1-git-send-email-kernel@wildgooses.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Thanks for "mentoring" me over this.  I appreciate that this
consumes your valuable time

I have reposted what I hope is close to the correct code for this new
driver.  I'm somewhat apprehensive, so to draw attention to the things I
have most likely "done wrong":


> :000000 100644 0000000... bc1b3b3... A	arch/x86/platform/geode/alix_leds.c

...

> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index d5ed94d..b16ab56 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -2094,6 +2094,15 @@ config OLPC_OPENFIRMWARE_DT
>  	default y if OLPC_OPENFIRMWARE && PROC_DEVICETREE
>  	select OF_PROMTREE
>  
> +config ALIX_LEDS
> +	bool "PCEngines ALIX.2/.3 LED Support"
> +	select GPIOLIB
> +	depends on LEDS_CLASS
> +	depends on LEDS_GPIO_PLATFORM && GPIO_CS5535
> +	---help---
> +	  This option enables support for the PCEngines ALIX.2 and ALIX.3 LEDs.
> +	  You have to set alix-leds.force=1 for boards with Award BIOS.
> +
>  endif # X86_32


Driver and KConfig show this being specifically a driver for the Alix
LEDs rather than being a general Alix plaform initialisation module?

I was unsure if the trend was to have one module which initialised all
Alix platform stuff (whatever it needs), or to split by function?
Looking at other platform modules they seem to be somewhat fine grained
so I went with a specific "ALIX Led Module" approach?


Additionally I am unsure how strictly to set dependencies for my module?
 It clearly requires all the LED_GPIO_PLATFORM, GPIO_CS5535 dependencies
to do anything, but equally it doesn't seem to *break* anything if those
dependencies aren't compiled in?  Listing all the dependencies seems to
make it hard for users to find the option to enable it since it's not
even listed in menuconfig until your deps are met?  Please correct me as
to what level of deps should be listed?


On the topic of dependencies, Andres has changed cs5535-gpio.c to depend
on a new module cs5535-mfd - however, apart from the commit log message
this is not obvious to see?  OK, I'm an idiot, but it took me most of
this afternoon to understand why my GPIOs stopped working after moving
to 2.6.38?  Q: Should the new -mfd module be listed as a dep of -gpio?
Or perhaps -gpio should "select" -mfd? At least it would be helpful to
list the dependency in the Kconfig message?

Happy to submit a change - please advise on what (if anything) would be
the best solution?


Many thanks for your help and guidance so far

Ed W
