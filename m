Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237Ab1CHPHK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 10:07:10 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:48378 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754469Ab1CHPHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 10:07:05 -0500
From: Jamie Iles <jamie@jamieiles.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Jamie Iles <jamie@jamieiles.com>
Subject: [PATCHv6 0/5] ARM: add initial support for Picochip picoXcell SoC
Date: Tue,  8 Mar 2011 15:06:52 +0000
Message-Id: <1299596817-19879-1-git-send-email-jamie@jamieiles.com>
X-Mailer: git-send-email 1.7.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've respun this patch series to move the DEBUG_LL 32-bit helpers into
debug-macro.S like mach-davinci does and include the basic clk stuff so
that we can build with drivers that want CLK support.

This patch series takes us to a login console over serial on both PC3X2
and PC3X3 devices on the PC7302 board booted with NOR flash.  I plan on
adding support for the next generation of soc, PM, cpufreq etc at a
later date once these patches are merged but figured it would be good to
start with a nice stable base.

Any feedback would be very much appreciated!

Thanks,

Jamie Iles (5):

  picoxcell: support for Picochip picoXcell SoC
  picoxcell: support for the common system timers
  picoxcell: common SoC peripheral support
  picoxcell: basic clk infrastructure
  picoxcell: support for the PC7302 development board

 arch/arm/Kconfig                                   |   14 ++
 arch/arm/Makefile                                  |    1 +
 arch/arm/mach-picoxcell/Kconfig                    |   13 ++
 arch/arm/mach-picoxcell/Makefile                   |    5 +
 arch/arm/mach-picoxcell/Makefile.boot              |    3 +
 arch/arm/mach-picoxcell/axi2cfg.c                  |   36 ++++
 arch/arm/mach-picoxcell/board_pc7302.c             |  109 ++++++++++
 arch/arm/mach-picoxcell/clk.c                      |   83 ++++++++
 arch/arm/mach-picoxcell/devices.c                  |  122 +++++++++++
 arch/arm/mach-picoxcell/include/mach/clkdev.h      |   70 ++++++
 arch/arm/mach-picoxcell/include/mach/debug-macro.S |   39 ++++
 arch/arm/mach-picoxcell/include/mach/entry-macro.S |   19 ++
 arch/arm/mach-picoxcell/include/mach/hardware.h    |   29 +++
 arch/arm/mach-picoxcell/include/mach/io.h          |   38 ++++
 arch/arm/mach-picoxcell/include/mach/irqs.h        |   89 ++++++++
 arch/arm/mach-picoxcell/include/mach/memory.h      |   27 +++
 .../include/mach/picoxcell/axi2cfg.h               |  122 +++++++++++
 .../mach-picoxcell/include/mach/picoxcell/gpio.h   |   48 +++++
 .../include/mach/picoxcell/picoxcell.h             |   62 ++++++
 .../mach-picoxcell/include/mach/picoxcell/timer.h  |   37 ++++
 .../mach-picoxcell/include/mach/picoxcell/wdog.h   |   43 ++++
 arch/arm/mach-picoxcell/include/mach/platform.h    |   27 +++
 arch/arm/mach-picoxcell/include/mach/system.h      |   51 +++++
 arch/arm/mach-picoxcell/include/mach/timex.h       |   26 +++
 arch/arm/mach-picoxcell/include/mach/uncompress.h  |   60 ++++++
 arch/arm/mach-picoxcell/include/mach/vmalloc.h     |   18 ++
 arch/arm/mach-picoxcell/io.c                       |   49 +++++
 arch/arm/mach-picoxcell/picoxcell_core.c           |  107 ++++++++++
 arch/arm/mach-picoxcell/picoxcell_core.h           |   25 +++
 arch/arm/mach-picoxcell/soc.h                      |   32 +++
 arch/arm/mach-picoxcell/time.c                     |  222 ++++++++++++++++++++
 31 files changed, 1626 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-picoxcell/Kconfig
 create mode 100644 arch/arm/mach-picoxcell/Makefile
 create mode 100644 arch/arm/mach-picoxcell/Makefile.boot
 create mode 100644 arch/arm/mach-picoxcell/axi2cfg.c
 create mode 100644 arch/arm/mach-picoxcell/board_pc7302.c
 create mode 100644 arch/arm/mach-picoxcell/clk.c
 create mode 100644 arch/arm/mach-picoxcell/devices.c
 create mode 100644 arch/arm/mach-picoxcell/include/mach/clkdev.h
 create mode 100644 arch/arm/mach-picoxcell/include/mach/debug-macro.S
 create mode 100644 arch/arm/mach-picoxcell/include/mach/entry-macro.S
 create mode 100644 arch/arm/mach-picoxcell/include/mach/hardware.h
 create mode 100644 arch/arm/mach-picoxcell/include/mach/io.h
 create mode 100644 arch/arm/mach-picoxcell/include/mach/irqs.h
 create mode 100644 arch/arm/mach-picoxcell/include/mach/memory.h
 create mode 100644 arch/arm/mach-picoxcell/include/mach/picoxcell/axi2cfg.h
 create mode 100644 arch/arm/mach-picoxcell/include/mach/picoxcell/gpio.h
 create mode 100644 arch/arm/mach-picoxcell/include/mach/picoxcell/picoxcell.h
 create mode 100644 arch/arm/mach-picoxcell/include/mach/picoxcell/timer.h
 create mode 100644 arch/arm/mach-picoxcell/include/mach/picoxcell/wdog.h
 create mode 100644 arch/arm/mach-picoxcell/include/mach/platform.h
 create mode 100644 arch/arm/mach-picoxcell/include/mach/system.h
 create mode 100644 arch/arm/mach-picoxcell/include/mach/timex.h
 create mode 100644 arch/arm/mach-picoxcell/include/mach/uncompress.h
 create mode 100644 arch/arm/mach-picoxcell/include/mach/vmalloc.h
 create mode 100644 arch/arm/mach-picoxcell/io.c
 create mode 100644 arch/arm/mach-picoxcell/picoxcell_core.c
 create mode 100644 arch/arm/mach-picoxcell/picoxcell_core.h
 create mode 100644 arch/arm/mach-picoxcell/soc.h
 create mode 100644 arch/arm/mach-picoxcell/time.c

-- 
1.7.4

