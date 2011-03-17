Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754198Ab1CQRY6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 13:24:58 -0400
Received: from mail1.nippynetworks.com ([91.220.24.129]:58191 "EHLO
	mail1.nippynetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566Ab1CQRY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 13:24:57 -0400
Message-ID: <4D8243E7.7030309@wildgooses.com>
Date: Thu, 17 Mar 2011 17:24:55 +0000
From: Ed W <lists@wildgooses.com>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.15) Gecko/20110303 Lightning/1.0b2 Thunderbird/3.1.9
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: Andres Salomon <dilinger@queued.net>, rpurdie@rpsys.net,
        linux-geode@lists.infradead.org, const@mimas.ru,
        linux-kernel@vger.kernel.org
Subject: Re: Feedback please: [PATCH] leds: New PCEngines Alix LED driver
 using gpio interface
References: <4D81D7FD.1040602@wildgooses.com> <20110317084328.41831b4c@debxo> <AANLkTikga=zrNgfsuN4=8tCfZz0n7vkk6i0xW-zj6zSD@mail.gmail.com>
In-Reply-To: <AANLkTikga=zrNgfsuN4=8tCfZz0n7vkk6i0xW-zj6zSD@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/03/2011 16:08, Grant Likely wrote:
> Actually, it looks like with your changes this isn't even a driver
> anymore.  It is merely code to register a device on a specific
> platform.  Is there any other alix-specific initialization code in the
> kernel?  If so, you should consider relocating the device registration
> with the rest of the alix setup code.

Agreed.  I confess that I don't understand the linux driver structure
enough to shift the code further though

What I observe is that there is a lot of arch specific setup for ARM,
etc, however, this is not currently done at all for x86 (which is Alix),
so at the moment this would seem to sit slightly awkwardly with current
x86 arch code?

Instead I found leds-net5501.c, which is for a very similar platform to
the Alix (not quite similar enough that I could combine the files) and I
used that as my prototype for this driver.

I think given that we already have a similar driver in the leds area
which does platform alike setup, this gives some justification for doing
the same with the Alix leds?  Additionally if we ever find we need Alix
specific setup code then the code is ready to be used as is by the
platform code?


>>> -module_init(alix_led_init);
>>> -module_exit(alix_led_exit);
>>> +arch_initcall(alix_init);
>>
>> Why is this arch_initcall rather than module_init?   If possible, it
>> would be good to have an unload hook as well.
> 
> Yes, unless you've got specific ordering constraints this should
> definitely be module_init().

I'm out of my depth here.  I would be very happy to resubmit either way?

However, is there not a potential ordering issue if leds-alix2 is loaded
*before* leds-gpio? Is this not the reason for making it an arch_initcall?

Also the same code is used in leds-5501.c - would you like me to submit
a patch to change that also (if you confirm it should become a
module_init call?).

Thanks for final confirmation on this and I will quickly resubmit the patch?

Ed W
