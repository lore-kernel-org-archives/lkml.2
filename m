Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755654Ab1J3Msr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Oct 2011 08:48:47 -0400
Received: from brigitte.telenet-ops.be ([195.130.137.66]:47635 "EHLO
	brigitte.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754519Ab1J3Mso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Oct 2011 08:48:44 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Greg Ungerer <gerg@uclinux.org>
Subject: [PATCH 00/27 v7] m68k: Convert to genirq
Date: Sun, 30 Oct 2011 13:48:08 +0100
Message-Id: <1319978915-10933-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series converts the m68k/mmu (nommu was converted before)
architecture to the generic hardirq framework.

  - [01/27] ide-{cd,floppy,tape}: Do not include <linux/irq.h>
  - [02/27] m68k/irq: Rename irq_controller to irq_chip
  - [03/27] m68k/irq: Kill irq_node_t typedef, always use struct irq_node
  - [04/27] m68k/irq: Rename irq_node to irq_data
  - [05/27] m68k/irq: Switch irq_chip methods to "struct irq_data *data"
  - [06/27] m68k/irq: Rename setup_irq() to m68k_setup_irq() and make it static
  - [07/27] m68k/irq: Extract irq_set_chip()
  - [08/27] m68k/irq: Add m68k_setup_irq_controller()
  - [09/27] m68k/irq: Rename {,__}m68k_handle_int()
  - [10/27] m68k/irq: Remove obsolete IRQ_FLG_* users
  - [11/27] m68k/irq: Add genirq support
  - [12/27] m68k/atari: Convert Atari to genirq
  - [13/27] m68k/atari: Remove code and comments about different irq types
  - [14/27] m68k/amiga: Refactor amiints.c
  - [15/27] m68k/amiga: Convert Amiga to genirq
  - [16/27] m68k/amiga: Optimize interrupts using chain handlers
  - [17/27] m68k/mac: Convert Mac to genirq
  - [18/27] m68k/mac: Optimize interrupts using chain handlers
  - [19/27] m68k/hp300: Convert HP9000/300 and HP9000/400 to genirq
  - [20/27] m68k/vme: Convert VME to genirq
  - [21/27] m68k/apollo: Convert Apollo to genirq
  - [22/27] m68k/sun3: Use the kstat_irqs_cpu() wrapper
  - [23/27] m68k/sun3: Convert Sun3/3x to genirq
  - [24/27] m68k/q40: Convert Q40/Q60 to genirq
  - [25/27] m68k/irq: Remove obsolete m68k irq framework
  - [26/27] m68k/irq: Remove obsolete support for user vector interrupt fixups
  - [27/27] m68k/mac: Remove mac_irq_{en,dis}able() wrappers

Changes in v7:
  - Rebased after arch/m68k/Kconfig restructuring:
      - The temporary USE_GENERIC_HARDIRQS is now in arch/m68k/Kconfig,
        depending on MMU,
  - Rebased after arch/m68k/kernel/Makefile merge,
  - Split off IRQ_FLG_* removal in separate commits:
      - Postpone removals in drivers that should go through the respective
        driver trees (net/scsi/staging/serial),
      - Postpone final removal to v3.3,
  - Dropped (went in via another tree):
      - genirq: Add missing "else" in irq_shutdown(),
      - keyboard: Do not include <linux/irq.>,
  - Added Patch 27 ("m68k/mac: Remove mac_irq_{en,dis}able() wrappers")
  
I added this to the m68k for-next and for-3.2 branches.

I'll rebase it once more on top of v3.2-rc1 once that comes out (currently
it's based on a random base point).

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
