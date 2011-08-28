Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751474Ab1H1Hxa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Aug 2011 03:53:30 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:60478 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284Ab1H1HxX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Aug 2011 03:53:23 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.OSX.2.00.1108271506320.190@ibook.local>
References: <CAMuHMdUZe0Y55ZPee+umJdEsmY5X-EB-KoC-w-SGEtbPMAcf3g@mail.gmail.com>
	<alpine.OSX.2.00.1108271506320.190@ibook.local>
Date: Sun, 28 Aug 2011 09:53:22 +0200
X-Google-Sender-Auth: I_X2PJN28eJV8q_ByFZlCuQIRs4
Message-ID: <CAMuHMdXk6_1CO8mvfNtbjf3V0Awh=zFYOcrpbUe2-pZkL5knxQ@mail.gmail.com>
Subject: Re: m68k: [v5] Convert to genirq (WIP)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Finn Thain <fthain@telegraphics.com.au>
Cc: "Linux/m68k" <linux-m68k@vger.kernel.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 28, 2011 at 04:08, Finn Thain <fthain@telegraphics.com.au> wrote:
> On Fri, 26 Aug 2011, Geert Uytterhoeven wrote:
>> - [PATCH 18/24]: m68k/mac: Optimize interrupts using chain handlers (NEW)
>
> That patch has a mistake --
>
>        irq_set_chained_handler(IRQ_AUTO_4, psc_irq);
>        irq_set_handler_data(IRQ_AUTO_3, (void *)0x40);
>        irq_set_chained_handler(IRQ_AUTO_5, psc_irq);
>        irq_set_handler_data(IRQ_AUTO_3, (void *)0x50);
>        irq_set_chained_handler(IRQ_AUTO_6, psc_irq);
>        irq_set_handler_data(IRQ_AUTO_3, (void *)0x60);
>
> should be
>
>        irq_set_chained_handler(IRQ_AUTO_4, psc_irq);
>        irq_set_handler_data(IRQ_AUTO_4, (void *)0x40);
>        irq_set_chained_handler(IRQ_AUTO_5, psc_irq);
>        irq_set_handler_data(IRQ_AUTO_5, (void *)0x50);
>        irq_set_chained_handler(IRQ_AUTO_6, psc_irq);
>        irq_set_handler_data(IRQ_AUTO_6, (void *)0x60);

Woops, of course. Thanks!

> On one VIA-based machine that I tested, !CONFIG_USE_GENERIC_HARDIRQS
> gives:
>
> # cat /proc/interrupts
> auto       1:       2299 via1
> auto       2:       3876 via2
> auto       4:        562 SCC
> auto       7:          0 NMI
> mac       10:        590 pmu-shift
> mac       12:         90 pmu-clock
> mac       14:       1635 timer
> mac       17:       3876 nubus
> mac       56:       3879 sonic
>
> whereas, CONFIG_USE_GENERIC_HARDIRQS=y gives:
>
> # cat /proc/interrupts
>           CPU0
>  4:       5303      auto  SCC
>  7:          0      auto  NMI
>  10:       2136       mac  pmu-shift
>  12:        607       mac  pmu-clock
>  14:      41858       mac  timer
>  56:      66876       mac  sonic
> ERR:          0
>
> Are there no counters for chained IRQs?

I noticed the same for Amiga.

> Other than these issues everything looks OK. I will test OSS and Baboon
> when I get the relevant hardware set up.

Thanks again!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
