Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757271Ab1DHOdq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 10:33:46 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:41232 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756703Ab1DHOdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 10:33:45 -0400
From: Jamie Iles <jamie@jamieiles.com>
To: linux-kernel@vger.kernel.org
Cc: johnstul@us.ibm.com, tglx@linutronix.de, jacob.jun.pan@linux.intel.com,
        Jamie Iles <jamie@jamieiles.com>
Subject: [PATCHv2 0/2] Permit reuse of APB timers on other platforms
Date: Fri,  8 Apr 2011 15:33:36 +0100
Message-Id: <1302273218-7263-1-git-send-email-jamie@jamieiles.com>
X-Mailer: git-send-email 1.7.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series splits out the DesignWare APB timer handling into
clocksource and clockevent drivers then allows different platforms to reuse
them.  The Synopsys timers can be found in x86, ARM and potentially other
architectures.

Here's the updated patch series which Jacob has had running on his x86
platform and I have working on a currently out-of-tree ARM platform.

Many thanks to Jacob for the testing (and fixing) to get this running on
x86.

Jamie Iles (2):
  x86, mrst: share APB timer code with other platforms
  clocksource: platform driver for APB timers

 arch/x86/Kconfig                            |    1 +
 arch/x86/include/asm/apb_timer.h            |   22 +--
 arch/x86/kernel/apb_timer.c                 |  421 +++++----------------------
 drivers/Kconfig                             |    2 +
 drivers/clocksource/Kconfig                 |   11 +
 drivers/clocksource/Makefile                |    2 +
 drivers/clocksource/dw_apb_timer.c          |  322 ++++++++++++++++++++
 drivers/clocksource/dw_apb_timer_platform.c |  173 +++++++++++
 include/linux/dw_apb_timer.h                |  129 ++++++++
 9 files changed, 714 insertions(+), 369 deletions(-)
 create mode 100644 drivers/clocksource/Kconfig
 create mode 100644 drivers/clocksource/dw_apb_timer.c
 create mode 100644 drivers/clocksource/dw_apb_timer_platform.c
 create mode 100644 include/linux/dw_apb_timer.h

-- 
1.7.4.2

