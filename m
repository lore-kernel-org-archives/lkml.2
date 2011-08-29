Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752940Ab1H2Hgj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 03:36:39 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:64102 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752741Ab1H2Hgd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 03:36:33 -0400
MIME-Version: 1.0
In-Reply-To: <CAMuHMdXk6_1CO8mvfNtbjf3V0Awh=zFYOcrpbUe2-pZkL5knxQ@mail.gmail.com>
References: <CAMuHMdUZe0Y55ZPee+umJdEsmY5X-EB-KoC-w-SGEtbPMAcf3g@mail.gmail.com>
	<alpine.OSX.2.00.1108271506320.190@ibook.local>
	<CAMuHMdXk6_1CO8mvfNtbjf3V0Awh=zFYOcrpbUe2-pZkL5knxQ@mail.gmail.com>
Date: Mon, 29 Aug 2011 09:36:32 +0200
X-Google-Sender-Auth: DWSuWNnV20pUUlXrcrMIOJ-9uLE
Message-ID: <CAMuHMdVG+GM5c0Wmpa-sAYL+pY1Oz7SynEqmpE1vJWY6j4rXvg@mail.gmail.com>
Subject: Re: m68k: [v5] Convert to genirq (WIP)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "Linux/m68k" <linux-m68k@vger.kernel.org>, linux-kernel@vger.kernel.org,
        Finn Thain <fthain@telegraphics.com.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 28, 2011 at 09:53, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> On Sun, Aug 28, 2011 at 04:08, Finn Thain <fthain@telegraphics.com.au> wrote:
>> On one VIA-based machine that I tested, !CONFIG_USE_GENERIC_HARDIRQS
>> gives:
>>
>> # cat /proc/interrupts
>> auto       1:       2299 via1
>> auto       2:       3876 via2
>> auto       4:        562 SCC
>> auto       7:          0 NMI
>> mac       10:        590 pmu-shift
>> mac       12:         90 pmu-clock
>> mac       14:       1635 timer
>> mac       17:       3876 nubus
>> mac       56:       3879 sonic
>>
>> whereas, CONFIG_USE_GENERIC_HARDIRQS=y gives:
>>
>> # cat /proc/interrupts
>>           CPU0
>>  4:       5303      auto  SCC
>>  7:          0      auto  NMI
>>  10:       2136       mac  pmu-shift
>>  12:        607       mac  pmu-clock
>>  14:      41858       mac  timer
>>  56:      66876       mac  sonic
>> ERR:          0
>>
>> Are there no counters for chained IRQs?
>
> I noticed the same for Amiga.

Thomas, is it intentional that chain handlers don't show counters?
What if we get unexpected interrupts the chain handler can't handle?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
