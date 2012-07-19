Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752078Ab2GSPgW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 11:36:22 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:45993 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942Ab2GSPgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 11:36:18 -0400
Message-ID: <5008296C.5070709@gmail.com>
Date: Thu, 19 Jul 2012 17:36:12 +0200
From: Daniel Mack <zonque@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Sven Neumann <s.neumann@raumfeld.com>, Olof Johansson <olof@lixom.net>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: eeti_ts: Mark as CONFIG_BROKEN
References: <1333777207-4151-1-git-send-email-olof@lixom.net> <20120407070206.GA17623@core.coreip.homeip.net> <4F8089A9.6080704@raumfeld.com> <20120503043651.GA11830@core.coreip.homeip.net> <20120713070102.GA2223@core.coreip.homeip.net> <500561AF.9090901@gmail.com>
In-Reply-To: <500561AF.9090901@gmail.com>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17.07.2012 14:59, Daniel Mack wrote:
> On 13.07.2012 09:01, Dmitry Torokhov wrote:
>> On Wed, May 02, 2012 at 09:36:51PM -0700, Dmitry Torokhov wrote:
>>> Hi Sven,
>>>
>>> On Sat, Apr 07, 2012 at 08:38:33PM +0200, Sven Neumann wrote:
>>>> Hi,
>>>>
>>>> On 07.04.12 09:02, Dmitry Torokhov wrote:
>>>>> On Fri, Apr 06, 2012 at 10:40:07PM -0700, Olof Johansson wrote:
>>>>>> This seems to have been broken since 2010, so obviously noone actually
>>>>>> cares about the driver:
>>>>>>
>>>>>> make[4]: *** [drivers/input/touchscreen/eeti_ts.o] Error 1
>>>>>> drivers/input/touchscreen/eeti_ts.c: In function 'eeti_ts_irq_active':
>>>>>> drivers/input/touchscreen/eeti_ts.c:65:2: error: implicit declaration of function 'irq_to_gpio' [-Werror=implicit-function-declaration]
>>>>>>
>>>>>> irq_to_gpio isn't available on most platforms today, so the driver
>>>>>> will need some rework by someone who has hardware access and can test
>>>>>> (to make sure that, for example, switching to level interrupts and just
>>>>>> keep taking them while there's more to process works).
>>>>>>
>>>>>> I guess it could just be scheduled for removal, but let's start with
>>>>>> marking it CONFIG_BROKEN.
>>>>>
>>>>> Well, it probably works quite well on arches that do have irq_to_gpio(),
>>>>> let's ask Daniel and Sven if they still have this hardware and if they
>>>>> can try the patch below that implements what you suggested.
>>>>
>>>> This hardware is still in use and we also still follow kernel
>>>> development and try to update our customer devices to recent kernel
>>>> versions regularly. Currently we are at 3.1.10 and the touchscreen
>>>> works well with that. I'll try to update to a more recent kernel
>>>> next week and will try your patch.
>>>>
>>>
>>> Did you have a chance to test the patch?
>>
>> *ping*
>>
>> It would be nice to get driver in mainline compile [and work] again...
> 
> We gave that patch a quick try today and it doesn't seem to work. We
> don't get any events from the touch screen anymore. We need to debug
> this further, hopefully by the end of this week.
> 
> If there's anything obvious in the setup of the threaded IRQ handler,
> please let us know. Otherwise, I'll get back once I have a fixed version
> of the patch.

Ok, finally I found some time. In general, the patch works fine. The
only detail I had to amend was the irqflags, which were changed from
IRQF_TRIGGER_RISING/IRQF_TRIGGER_FALLING to
IRQF_TRIGGER_HIGH/IRQF_TRIGGER_LOW, which doesn't work as the PXA can't
deal with level-based IRQs. Changing this back to RISING/FALLING makes
the driver work again.

With that correction, feel free to add my Acked-by:/Tested-by:

Thanks and sorry again for the slow response.

Daniel
