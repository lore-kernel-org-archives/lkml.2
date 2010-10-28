Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933967Ab0J1RLr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 13:11:47 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:49317 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932442Ab0J1RLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 13:11:43 -0400
Date: Fri, 29 Oct 2010 02:11:35 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] sh updates for 2.6.37-rc1, part 2.
Message-ID: <20101028171134.GA2114@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from:

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/sh-2.6.git

Which contains:

Paul Mundt (31):
      sh: Expose physical addressing mode through cpuinfo.
      sh: Tidy up genirq Kconfig bits.
      sh: Switch dynamic IRQ creation to generic irq allocator.
      sh: Fix the sparsemem disabled build.
      cdrom: gdrom: ctrl_in/outX to __raw_read/writeX conversion.
      sh: maple: ctrl_in/outX to __raw_read/writeX conversion.
      sh: mach-dreamcast: irq_data conversion.
      sh: IPR IRQs irq_data conversion.
      sh: mach-landisk: irq_data conversion.
      sh: mach-microdev: irq_data conversion.
      sh: imask IRQs irq_data conversion.
      sh: mach-systemh: irq_data conversion.
      sh: mach-x3proto: irq_data conversion.
      sh: hd64461: irq_data conversion.
      input: jornada680_kbd: ctrl_in/outX to __raw_read/writeX conversion.
      input: hp680_ts_input: ctrl_in/outX to __raw_read/writeX conversion.
      sh: mach-se: irq_data conversion.
      rtc: rtc-rs5c313: ctrl_in/outX to __raw_read/writeX conversion.
      sh64: update for IRQ flag handling naming changes.
      sh64: irq_data conversion.
      sh: intc: irq_data conversion.
      sh: update show_interrupts() for irq_data chip lookup.
      sh: disable deprecated genirq support.
      sound: sh: ctrl_in/outX to __raw_read/writeX conversion.
      sh64: _PAGE_SPECIAL support.
      sh: lockless get_user_pages_fast()
      sh: oprofile: Fix up and extend op_name_from_perf_id().
      sh64: oprofile: Fix up kernel stack pointer size mismatch.
      sh: oprofile: Make sure the backtrace op is available for timer-fallback.
      sh: fix up cpu hotplug IRQ migration for irq_data changes.
      sh: intc: switch irq_desc iteration to new active IRQ iterator.

Thomas Gleixner (1):
      sh: Sanitize sparse irq

 arch/sh/Kconfig                            |   14 +-
 arch/sh/boards/mach-cayman/irq.c           |   16 +-
 arch/sh/boards/mach-dreamcast/irq.c        |   17 +-
 arch/sh/boards/mach-landisk/irq.c          |   15 +-
 arch/sh/boards/mach-microdev/irq.c         |   30 +--
 arch/sh/boards/mach-se/7206/irq.c          |   20 +-
 arch/sh/boards/mach-se/7343/irq.c          |   15 +-
 arch/sh/boards/mach-se/7722/irq.c          |   15 +-
 arch/sh/boards/mach-se/7724/irq.c          |   13 +-
 arch/sh/boards/mach-systemh/irq.c          |   57 ++----
 arch/sh/boards/mach-x3proto/gpio.c         |    7 +-
 arch/sh/cchips/hd6446x/hd64461.c           |   19 +-
 arch/sh/include/asm/pgtable.h              |    2 +
 arch/sh/include/asm/pgtable_32.h           |    2 -
 arch/sh/include/asm/pgtable_64.h           |    9 +-
 arch/sh/include/asm/processor.h            |    1 +
 arch/sh/kernel/cpu/init.c                  |    2 +
 arch/sh/kernel/cpu/irq/imask.c             |   14 +-
 arch/sh/kernel/cpu/irq/intc-sh5.c          |   49 +----
 arch/sh/kernel/cpu/irq/ipr.c               |   29 ++--
 arch/sh/kernel/cpu/sh4/perf_event.c        |    2 +-
 arch/sh/kernel/cpu/sh4a/perf_event.c       |    2 +-
 arch/sh/kernel/irq.c                       |   37 ++--
 arch/sh/kernel/irq_64.c                    |   16 +-
 arch/sh/kernel/setup.c                     |    4 +
 arch/sh/mm/Makefile                        |    2 +-
 arch/sh/mm/gup.c                           |  273 ++++++++++++++++++++++++++++
 arch/sh/oprofile/Makefile                  |    2 +
 arch/sh/oprofile/backtrace.c               |    2 +-
 arch/sh/oprofile/common.c                  |   35 ++--
 drivers/cdrom/gdrom.c                      |   76 ++++----
 drivers/input/keyboard/jornada680_kbd.c    |   28 ++--
 drivers/input/touchscreen/hp680_ts_input.c |   16 +-
 drivers/rtc/rtc-rs5c313.c                  |   34 ++--
 drivers/sh/intc/chip.c                     |   53 +++---
 drivers/sh/intc/core.c                     |   45 +++--
 drivers/sh/intc/dynamic.c                  |   91 +--------
 drivers/sh/intc/internals.h                |    2 +-
 drivers/sh/intc/virq.c                     |   14 +-
 drivers/sh/maple/maple.c                   |   20 +-
 include/linux/sh_intc.h                    |    3 -
 sound/sh/aica.c                            |    2 +-
 sound/soc/sh/sh7760-ac97.c                 |    4 +-
 43 files changed, 646 insertions(+), 463 deletions(-)
 create mode 100644 arch/sh/mm/gup.c
