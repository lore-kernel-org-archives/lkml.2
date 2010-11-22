Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156Ab0KVQ7B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 11:59:01 -0500
Received: from slowhand.arndnet.de ([88.198.19.76]:53222 "EHLO mail.unitix.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752167Ab0KVQ67 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 11:58:59 -0500
Message-ID: <4CEAA151.7050404@arndnet.de>
Date: Mon, 22 Nov 2010 17:58:57 +0100
From: Arnd Hannemann <arnd@arndnet.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.15) Gecko/20101027 Lightning/1.0b1 Thunderbird/3.0.10
MIME-Version: 1.0
To: "Berg, Johannes" <johannes.berg@intel.com>
CC: Michal Hocko <mhocko@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: 5ada28bf76752 causes compilation error if !CONFIG_LEDS_CLASS
References: <20101116142027.GC19247@tiehlicka.suse.cz> <C5C86A19469DAE48AAAD0E5F3716E44501D41A7DC2@irsmsx504.ger.corp.intel.com> <20101118082454.GC15928@tiehlicka.suse.cz> <C5C86A19469DAE48AAAD0E5F3716E44501D41ECB46@irsmsx504.ger.corp.intel.com>
In-Reply-To: <C5C86A19469DAE48AAAD0E5F3716E44501D41ECB46@irsmsx504.ger.corp.intel.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 18.11.2010 17:52, schrieb Berg, Johannes:
>>>> it seems that your patch (5ada28bf76752e33dce3d807bf0dfbe6d1b943ad)
>>>> causes the following compilatation error:
>>>>   LD      .tmp_vmlinux1
>>>> drivers/built-in.o: In function `led_trigger_set':
>>>> drivers/leds/led-triggers.c:116: undefined reference to
>>>> `led_brightness_set'
>>>> make[1]: *** [.tmp_vmlinux1] Error 1
>>>>
>>>> AFAICS, led_brightness_set is defined in drivers/leds/led-class.c
>> which
>>>> is compiled only if CONFIG_LEDS_CLASS is configured which is not my
>>>> case (after make oldconfig with all default values from 37-rc1).
>>>>
>>>> I am not sure what is the right solution whether
>> CONFIG_LEDS_TRIGGERS
>>>> should depend on CONFIG_LEDS_CLASS or the patch should be reverted.
>>>>
>>>> My config is attached, if somebody need it.
>>>
>>> Hmm, we did find that, and I made a patch to fix up the Kconfig, that
>> apparently hasn't made it in? Bit confused now.
>>
>> Does this mean that I should enable CONFIG_LEDS_CLASS to work around
>> the issue for this moment?
> 
> I think that'd be easiest, yes.

I also ran into this today.
Any updates or pointer to the patch?

Regards,
Arnd
