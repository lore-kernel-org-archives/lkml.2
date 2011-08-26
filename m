Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755199Ab1HZUeZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 16:34:25 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:55783 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755088Ab1HZUeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 16:34:19 -0400
MIME-Version: 1.0
Date: Fri, 26 Aug 2011 22:34:18 +0200
X-Google-Sender-Auth: _ctiCIxVZlrddzb0Fj1gJ1D1QSQ
Message-ID: <CAMuHMdUZe0Y55ZPee+umJdEsmY5X-EB-KoC-w-SGEtbPMAcf3g@mail.gmail.com>
Subject: m68k: [v5] Convert to genirq (WIP)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "Linux/m68k" <linux-m68k@vger.kernel.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I rebased and updated my m68k-genirq branch at

git://git.kernel.org:/pub/scm/linux/kernel/git/geert/linux-m68k.git m68k-genirq
http://git.kernel.org/?p=linux/kernel/git/geert/linux-m68k.git;a=shortlog;h=refs/heads/m68k-genirq

[PATCH 01/24] ide-{cd,floppy,tape}, keyboard: Do not include <linux/irq.>
[PATCH 02/24] m68k/irq: Rename irq_controller to irq_chip
[PATCH 03/24] m68k/irq: Kill irq_node_t typedef, always use struct irq_node
[PATCH 04/24] m68k/irq: Rename irq_node to irq_data
[PATCH 05/24] m68k/irq: Switch irq_chip methods to "struct irq_data *data"
[PATCH 06/24] m68k/irq: Rename setup_irq() to m68k_setup_irq() and
make it static
[PATCH 07/24] m68k/irq: Extract irq_set_chip()
[PATCH 08/24] m68k/irq: Add m68k_setup_irq_controller()
[PATCH 09/24] m68k/irq: Rename {,__}m68k_handle_int()
[PATCH 10/24] m68k/irq: Remove obsolete IRQ_FLG_* definitions and users
[PATCH 11/24] m68k/irq: Add genirq support
[PATCH 12/24] m68k/atari: Convert Atari to genirq
[PATCH 13/24] m68k/atari: Remove code and comments about different irq types
[PATCH 14/24] m68k/amiga: Refactor amiints.c
[PATCH 15/24] m68k/amiga: Convert Amiga to genirq
[PATCH 16/24] m68k/amiga: Optimize interrupts using chain handlers
[PATCH 17/24] m68k/mac: Convert Mac to genirq
[PATCH 18/24] m68k/mac: Optimize interrupts using chain handlers
[PATCH 19/24] m68k/hp300: Convert HP9000/300 and HP9000/400 to genirq
[PATCH 20/24] m68k/vme: Convert VME to genirq
[PATCH 21/24] m68k/sun3: Use the kstat_irqs_cpu() wrapper
[PATCH 22/24] m68k/apollo: Convert Apollo to genirq
[PATCH 23/24] m68k/sun3: Convert Sun3/3x to genirq
[PATCH 24/24] m68k/q40: Convert Q40/Q60 to genirq

Changes:
  - [PATCH 11/24]: Keep m68k_setup_auto_interrupt(), it's still needed for Q40
  - [PATCH 18/24]: m68k/mac: Optimize interrupts using chain handlers (NEW)
  - [PATCH 24/24]: m68k/q40: Convert Q40/Q60 to genirq (NEW)

Todo:
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
