Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757752Ab0GXBmK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 21:42:10 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:16594 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757675Ab0GXBmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 21:42:09 -0400
From: David Daney <ddaney@caviumnetworks.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org, wim@iguana.be
Cc: linux-kernel@vger.kernel.org, David Daney <ddaney@caviumnetworks.com>
Subject: [PATCH 0/7] Watchdog driver for Octeon SOCs.
Date: Fri, 23 Jul 2010 18:41:40 -0700
Message-Id: <1279935707-3997-1-git-send-email-ddaney@caviumnetworks.com>
X-Mailer: git-send-email 1.7.1.1
X-OriginalArrivalTime: 24 Jul 2010 01:42:06.0859 (UTC) FILETIME=[6C977DB0:01CB2AD1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The main point of this patch set is to add a watchdog driver for
Octeon SOCs.  There is however, some perperation that has to be done
first.

The first two patches add some instructions to the MIPS uasm that are
needed by the watchdog.

If we want the watchdog to be usable as a module we need to export the
uasm APIs, prom_putchar and  __cpu_*_map (third, forth and fifth patchs).

The watch dog tests the c0_Status.NMI bit, so we define this in the
sixth patch.

That brings us to the grand finale, the watchdog driver itself.


David Daney (7):
  MIPS: Add drotr32 and uasm_i_drotr_safe to uasm.
  MIPS: Add BBIT0 and BBIT1 instructions to uasm
  MIPS: Add option to export uasm API.
  MIPS: Octeon: Export prom_putchar().
  MIPS: Export __cpu_number_map and __cpu_logical_map.
  MIPS: Define ST0_NMI in asm/mipsregs.h
  watchdog: Add watchdog driver for OCTEON SOCs.

 arch/mips/Kconfig                  |    3 +
 arch/mips/cavium-octeon/setup.c    |    6 +-
 arch/mips/include/asm/mipsregs.h   |    1 +
 arch/mips/include/asm/uasm.h       |   51 ++-
 arch/mips/kernel/cpu-bugs64.c      |    2 +-
 arch/mips/kernel/smp.c             |    4 +
 arch/mips/mm/uasm.c                |  162 ++++++---
 drivers/watchdog/Kconfig           |   18 +
 drivers/watchdog/Makefile          |    2 +
 drivers/watchdog/octeon-wdt-main.c |  745 ++++++++++++++++++++++++++++++++++++
 drivers/watchdog/octeon-wdt-nmi.S  |   64 +++
 11 files changed, 990 insertions(+), 68 deletions(-)
 create mode 100644 drivers/watchdog/octeon-wdt-main.c
 create mode 100644 drivers/watchdog/octeon-wdt-nmi.S

