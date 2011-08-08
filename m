Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946Ab1HHNIn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 09:08:43 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:33954 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753821Ab1HHNIl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 09:08:41 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.OSX.2.00.1106171337170.191@ibook.intranet>
References: <alpine.DEB.2.00.1105282010370.16617@ayla.of.borg>
	<BANLkTimebx56-Wb5JPWxYVnND9gG8OVdsQ@mail.gmail.com>
	<BANLkTin+gp2Cnxj8kHbHRmuoEgyDR8YeaQ@mail.gmail.com>
	<BANLkTik5-H1fc2rk3QrwvQiF=7fELmE2CA@mail.gmail.com>
	<alpine.OSX.2.00.1106171337170.191@ibook.intranet>
Date: Mon, 8 Aug 2011 15:08:40 +0200
X-Google-Sender-Auth: vl5sTWIhxKwiM0A7tlZgRqaSzQM
Message-ID: <CAMuHMdWcB2JmfxPz=bs3TM2eTPYWnzjFeXw0PRXTTcPeHBQPPQ@mail.gmail.com>
Subject: Re: m68k: Convert to genirq (WIP)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Finn Thain <fthain@telegraphics.com.au>
Cc: "Linux/m68k" <linux-m68k@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 17, 2011 at 05:45, Finn Thain <fthain@telegraphics.com.au> wrote:
> On Thu, 16 Jun 2011, Geert Uytterhoeven wrote:
>> On Wed, Jun 15, 2011 at 21:44, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>> > On Sat, Jun 4, 2011 at 19:56, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>> >> On Sat, May 28, 2011 at 20:32, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>> >>
>> >> It works on Amiga now, too. It can still use some optimizations in
>> >> the irq_{enable,disable,ack,mask,mask_ack,unmask} area, as my
>> >> BogoMIPS rating dropped by ca 2.5% and is now under 16, for a 25 MHz
>> >> 68040.
>> >
>> > Seems like everything (Atari/ARAnyM and Amiga) still works when using
>> > handle_simple_irq instead of handle_level_irq. As a bonus, BogoMIPS is
>> > above 16 again.
>
> Your bogomips benchmark would be the best-case penalty, right?
>
> Have you tried say, sending a ping flood to measure throughput and
> latency?

Results on Amiga 4000/040 (25 MHz 68040, 12 MiB Fast RAM) with Ariadne Ethernet,
running 3.0-rc7.

                              legacy m68k               genirq

bogomips:                     16.17 (lpj=80896)         16.02 (lpj=80128)

10x ping fast machine:        9034 ms                   9025 ms
  rtt min/avg/max/mdev (ms)   1.815/2.556/8.580/2.008   1.903/2.142/3.275/0.388

100x flood ping fast machine: 4654 ms                   3960 ms
  rtt min/avg/max/mdev (ms)   1.831/2.113/3.285/0.361   1.887/2.068/2.958/0.242
  pipe, ipg/ewma (ms)         10, 47.013/2.111          6, 40.005/1.989

wget 16 MiB image              86.99 KB/s               112.08 KB/s
                              104.31 KB/s               115.95 KB/s
                              109.56 KB/s               116.22 KB/s


/proc/interrupts (legacy m68k):

auto       1:          0 int1
auto       2:     152824 CIAA, ide0, eth0
auto       3:     133649 int3
auto       4:          0 int4
auto       5:          0 int5
auto       6:     193334 CIAB
amiga      8:          0 serial TX
amiga     12:     133649 fb vertb handler
amiga     19:          0 serial RX
cia       25:        240 amikbd
cia       27:     193334 timer


/proc/interrupts (genirq):

           CPU0
  2:      29503      auto  CIAA, ide0, eth0
  6:      93738      auto  CIAB
  8:          0     amiga  serial TX
 12:      64657     amiga  fb vertb handler
 13:          3     amiga
 19:          0     amiga  serial RX
 25:        788       cia  amikbd
 27:      93738       cia  timer
ERR:          0

I did some more refactoring which made the Mac conversion trivial (but
still untested).
I'll prepare it for publishing when the kids leave me alone ;-)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
