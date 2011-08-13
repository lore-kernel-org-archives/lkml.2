Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751968Ab1HMSu3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Aug 2011 14:50:29 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:33641 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314Ab1HMSu1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Aug 2011 14:50:27 -0400
MIME-Version: 1.0
Date: Sat, 13 Aug 2011 20:50:26 +0200
X-Google-Sender-Auth: y0Pau992V2BKUUwivShCtj330nw
Message-ID: <CAMuHMdU=wG=yv-EjfFhDC_jO5GMva3JMa=J2tST_nnWPXEfAow@mail.gmail.com>
Subject: m68k: [v3] Convert to genirq (WIP)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "Linux/m68k" <linux-m68k@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I rebased and updated my m68k-genirq branch at

git://git.kernel.org:/pub/scm/linux/kernel/git/geert/linux-m68k.git m68k-genirq
http://git.kernel.org/?p=linux/kernel/git/geert/linux-m68k.git;a=shortlog;h=refs/heads/m68k-genirq

[PATCH 01/16] ide-{cd,floppy,tape}, keyboard: Do not include <linux/irq.>
[PATCH 02/16] m68k/irq: Rename irq_controller to irq_chip
[PATCH 03/16] m68k/irq: Kill irq_node_t typedef, always use struct irq_node
[PATCH 04/16] m68k/irq: Rename irq_node to irq_data
[PATCH 05/16] m68k/irq: Switch irq_chip methods to "struct irq_data *data"
[PATCH 06/16] m68k/irq: Rename setup_irq() to m68k_setup_irq() and
make it static
[PATCH 07/16] m68k/irq: Extract irq_set_chip()
[PATCH 08/16] m68k/irq: Add m68k_setup_irq_controller()
[PATCH 09/16] m68k/irq: Rename {,__}m68k_handle_int()
[PATCH 10/16] m68k/irq: Remove obsolete IRQ_FLG_* definitions and users
[PATCH 11/16] m68k/irq: Add genirq support
[PATCH 12/16] m68k/atari: Convert Atari to genirq
[PATCH 13/16] m68k/amiga: Refactor amiints.c
[PATCH 14/16] m68k/amiga: Convert Amiga to genirq
[PATCH 15/16] m68k/amiga: Optimize interrupts using chain handlers
[PATCH 16/16] m68k/mac: Convert Mac to genirq

Changes:
  - Some more refactoring to ease the conversion,
  - (now trivial) Conversion of Mac, which is still untested.

I did not include chain handler optimizations for Mac, as that code isn't in a
compilable state yet and I still have to look a bit more into the replies from
Finn and Brad (thanks!) to fix that.

It would be nice if somebody could give it a try on Mac.
If it works, we have support for
  - Atari: autovector and vectored user interrupts
  - Amiga: autovector and chained interrupts
  - Mac: autovector and chained interrupts

Remaining platforms to convert:
  - Apollo: ISA interrupts, mapped to vectored user interrupts
  - HP300: Just autovectored interrupts, should be trivial to convert
  - VME: vectored user interrupts, should be trivial to convert
  - Q40: weirdest of all m68k platforms?
  - Sun3/3x: autovector and vectored user interrupts, overriding of standard
             interrupt handlers

Thanks for testing and feedback!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
