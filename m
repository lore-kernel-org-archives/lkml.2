Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312Ab1HWJeS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 05:34:18 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:42958 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754463Ab1HWJeQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 05:34:16 -0400
MIME-Version: 1.0
Date: Tue, 23 Aug 2011 11:34:15 +0200
X-Google-Sender-Auth: G5zg-V_-1LMTA7wjlhwPsDKYdRs
Message-ID: <CAMuHMdUEOUGbNOv2dhzf43=Q9BQZ5s4CXJ=MctUmWoe-ZozoCA@mail.gmail.com>
Subject: m68k: [v4] Convert to genirq (WIP)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "Linux/m68k" <linux-m68k@vger.kernel.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I rebased and updated my m68k-genirq branch at

git://git.kernel.org:/pub/scm/linux/kernel/git/geert/linux-m68k.git m68k-genirq
http://git.kernel.org/?p=linux/kernel/git/geert/linux-m68k.git;a=shortlog;h=refs/heads/m68k-genirq

[PATCH 01/22] ide-{cd,floppy,tape}, keyboard: Do not include <linux/irq.>
[PATCH 02/22] m68k/irq: Rename irq_controller to irq_chip
[PATCH 03/22] m68k/irq: Kill irq_node_t typedef, always use struct irq_node
[PATCH 04/22] m68k/irq: Rename irq_node to irq_data
[PATCH 05/22] m68k/irq: Switch irq_chip methods to "struct irq_data *data"
[PATCH 06/22] m68k/irq: Rename setup_irq() to m68k_setup_irq() and
make it static
[PATCH 07/22] m68k/irq: Extract irq_set_chip()
[PATCH 08/22] m68k/irq: Add m68k_setup_irq_controller()
[PATCH 09/22] m68k/irq: Rename {,__}m68k_handle_int()
[PATCH 10/22] m68k/irq: Remove obsolete IRQ_FLG_* definitions and users
[PATCH 11/22] m68k/irq: Add genirq support
[PATCH 12/22] m68k/atari: Convert Atari to genirq
[PATCH 13/22] m68k/atari: Remove code and comments about different irq types
[PATCH 14/22] m68k/amiga: Refactor amiints.c
[PATCH 15/22] m68k/amiga: Convert Amiga to genirq
[PATCH 16/22] m68k/amiga: Optimize interrupts using chain handlers
[PATCH 17/22] m68k/mac: Convert Mac to genirq
[PATCH 18/22] m68k/hp300: Convert HP9000/300 and HP9000/400 to genirq
[PATCH 19/22] m68k/vme: Convert VME to genirq
[PATCH 20/22] m68k/sun3: Use the kstat_irqs_cpu() wrapper
[PATCH 21/22] m68k/apollo: Convert Apollo to genirq
[PATCH 22/22] m68k/sun3: Convert Sun3/3x to genirq

Changes:
  - Added cleanup in patch 13
  - Conversion of Apollo and Sun3/3x

Todo:
  - Q40 conversion (see separate email with issues),
  - Chain handler optimizations for Mac,
  - Removal of legacy code inside #ifndef CONFIG_GENERIC_HARDIRQ,
  - Proper patch submission emails,
  - Get it merged (For 3.3? Or even 3.2?).

Oh, I almost forgot: testing ;-)! So far I tested it on Atari (ARAnyM)
and Amiga only.

Thanks for testing and feedback!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
