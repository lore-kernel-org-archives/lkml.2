Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752540Ab1HZLcb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 07:32:31 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60532 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073Ab1HZLc3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 07:32:29 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.OSX.2.00.1108262117070.267@ibook.local>
References: <alpine.DEB.2.00.1105282010370.16617@ayla.of.borg>
	<alpine.OSX.2.00.1106011300550.199@ibook.intranet>
	<20110605062702.GA2034@cynthia.pants.nu>
	<CAMuHMdXVt5+nCaCSH3+z0fsL+vhOOTgbKsOAses8OudT-1OZGQ@mail.gmail.com>
	<alpine.OSX.2.00.1108102007430.203@ibook.local>
	<CAMuHMdXgeHtOB_3u6G6N9E4vaq=sJY-9NtF68XAnxhspMgRyGg@mail.gmail.com>
	<alpine.OSX.2.00.1108262117070.267@ibook.local>
Date: Fri, 26 Aug 2011 13:32:28 +0200
X-Google-Sender-Auth: bOllMA_jh_94DM7FfpGDYfllNkI
Message-ID: <CAMuHMdVz40_HyFpgttGmUO_DBM58vgOhEq3YGzJ0tUM+k9B26w@mail.gmail.com>
Subject: Re: m68k: Convert to genirq (WIP)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Finn Thain <fthain@telegraphics.com.au>
Cc: Brad Boyer <flar@allandria.com>, "Linux/m68k" <linux-m68k@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 26, 2011 at 13:21, Finn Thain <fthain@telegraphics.com.au> wrote:
> On Fri, 26 Aug 2011, Geert Uytterhoeven wrote:
>> On Wed, Aug 10, 2011 at 12:53, Finn Thain <fthain@telegraphics.com.au> wrote:
>> >> via1_irq
>> >>     OSS_IRQLEV_VIA1 = IRQ_AUTO_6 (on oss)       conflict: psc_irq
>> >>
>> >>     IRQ_AUTO_1                                  conflict: iop_ism_irq
>>
>> >> iop_ism_irq
>> >>     OSS_IRQLEV_IOPISM = 1 = IRQ_AUTO_1 (on oss) conflict: via1_irq
>> >
>> > via1_irq is remapped to IRQ_AUTO_6 on OSS.
>>
>> According to via_register_interrupts(), it requests both:
>>
>>         if (via_alt_mapping) {
>>                 if (request_irq(IRQ_AUTO_1, via1_irq, 0, "software",
>>                                 (void *)via1))
>>                         pr_err("Couldn't register %s interrupt\n", "software");
>>                 if (request_irq(IRQ_AUTO_6, via1_irq, 0, "via1", (void *)via1))
>>                         pr_err("Couldn't register %s interrupt\n", "via1");
>>         } else {
>>                 if (request_irq(IRQ_AUTO_1, via1_irq, 0, "via1", (void *)via1))
>>                         pr_err("Couldn't register %s interrupt\n", "via1");
>>         }
>>
>> Hence IRQ_AUTO_1 must be shared and we cannot use an optimized chain
>> handler for via1_irq()
>
> I'm pretty sure that the "software" request_irq can be removed. It has
> come up before --
> http://marc.info/?l=linux-mac68k&m=110973724208746&w=2
>
> Maybe Brad can shed some light on this (?)
>
> I've just cloned and built your m68k-genirq branch. I will run some tests.

Thanks!

>> nor iop_ism_irq().
>
> via_register_interrupts() is not called on OSS.

You're right, I missed that.

>> This is the only remaining conflict I see.

Good, I'll convert them all to chain handlers.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
