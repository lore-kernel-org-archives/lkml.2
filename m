Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753161Ab2DGUce (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2012 16:32:34 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:34458 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584Ab2DGUcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2012 16:32:32 -0400
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <4F8089A9.6080704@raumfeld.com>
References: <1333777207-4151-1-git-send-email-olof@lixom.net>
	<20120407070206.GA17623@core.coreip.homeip.net>
	<4F8089A9.6080704@raumfeld.com>
Date: Sat, 7 Apr 2012 13:32:31 -0700
Message-ID: <CAOesGMiPZ0so-ZN0HCHHhw16oPWWgfVD5t--wKSvEUtzQx94CA@mail.gmail.com>
Subject: Re: [PATCH] Input: eeti_ts: Mark as CONFIG_BROKEN
From: Olof Johansson <olof@lixom.net>
To: Sven Neumann <s.neumann@raumfeld.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Daniel Mack <daniel@caiaq.de>,
        Daniel Mack <zonque@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 7, 2012 at 11:38 AM, Sven Neumann <s.neumann@raumfeld.com> wrote:
> Hi,
>
>
> On 07.04.12 09:02, Dmitry Torokhov wrote:
>>
>> On Fri, Apr 06, 2012 at 10:40:07PM -0700, Olof Johansson wrote:
>>>
>>> This seems to have been broken since 2010, so obviously noone actually
>>> cares about the driver:
>>>
>>> make[4]: *** [drivers/input/touchscreen/eeti_ts.o] Error 1
>>> drivers/input/touchscreen/eeti_ts.c: In function 'eeti_ts_irq_active':
>>> drivers/input/touchscreen/eeti_ts.c:65:2: error: implicit declaration of
>>> function 'irq_to_gpio' [-Werror=implicit-function-declaration]
>>>
>>> irq_to_gpio isn't available on most platforms today, so the driver
>>> will need some rework by someone who has hardware access and can test
>>> (to make sure that, for example, switching to level interrupts and just
>>> keep taking them while there's more to process works).
>>>
>>> I guess it could just be scheduled for removal, but let's start with
>>> marking it CONFIG_BROKEN.
>>
>>
>> Well, it probably works quite well on arches that do have irq_to_gpio(),
>> let's ask Daniel and Sven if they still have this hardware and if they
>> can try the patch below that implements what you suggested.
>
>
> This hardware is still in use and we also still follow kernel development
> and try to update our customer devices to recent kernel versions regularly.
> Currently we are at 3.1.10 and the touchscreen works well with that. I'll
> try to update to a more recent kernel next week and will try your patch.

Ah, you're right, and this was my bad. Looks like this change was
introduced in 3.2 and broke this and one more driver (ezx-pcap):

Author:     Haojian Zhuang <haojian.zhuang@marvell.com>
AuthorDate: Mon Oct 10 16:03:51 2011 +0800
Commit:     Haojian Zhuang <haojian.zhuang@marvell.com>
CommitDate: Mon Nov 14 21:07:59 2011 +0800

    ARM: pxa: rename gpio_to_irq and irq_to_gpio

    Avoid to define gpio_to_irq() and irq_to_gpio() for potential name
    confliction since multiple architecture will be built together.

    Signed-off-by: Haojian Zhuang <haojian.zhuang@marvell.com>


Haojian, I think it was probably premature to do the multiplatform
change like that, since it means that a PXA-only kernel has no mapping
from irq_to_gpio to pxa_irq_to_gpio. Can you please address this as a
fix for 3.4?


Thanks,

-Olof
