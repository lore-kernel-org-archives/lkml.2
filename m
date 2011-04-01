Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755800Ab1DALIS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 07:08:18 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33013 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439Ab1DALIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 07:08:17 -0400
From: Jamie Iles <jamie@jamieiles.com>
To: linux-kernel@vger.kernel.org
Cc: johnstul@us.ibm.com, tglx@linutronix.de, jacob.jun.pan@linux.intel.com,
        Jamie Iles <jamie@jamieiles.com>
Subject: [RFC PATCH 0/2] Permit reuse of APB timers on other platforms
Date: Fri,  1 Apr 2011 12:08:09 +0100
Message-Id: <1301656091-1284-1-git-send-email-jamie@jamieiles.com>
X-Mailer: git-send-email 1.7.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches allow the APB timers to be used by platforms other than
x86.  The first patch moves the actual timer handling and
clocksource/clock_event_device abstraction into drivers/clocksource and
converts x86 to use this.  The second patch adds a platform_driver to
allow other systems to use them.

I've tested these on an ARM platform with NO_HZ but I don't have an x86
platform with these timers that I can test them on so that's just
compile tested.

Jamie Iles (2):
  x86, mrst: share APB timer code with other platforms
  clocksource: platform driver for APB timers

 arch/x86/Kconfig                            |    1 +
 arch/x86/include/asm/apb_timer.h            |   22 +--
 arch/x86/kernel/apb_timer.c                 |  401 ++++-----------------------
 drivers/Kconfig                             |    2 +
 drivers/clocksource/Kconfig                 |   11 +
 drivers/clocksource/Makefile                |    2 +
 drivers/clocksource/dw_apb_timer.c          |  291 +++++++++++++++++++
 drivers/clocksource/dw_apb_timer_platform.c |  173 ++++++++++++
 include/linux/dw_apb_timer.h                |  122 ++++++++
 9 files changed, 662 insertions(+), 363 deletions(-)
 create mode 100644 drivers/clocksource/Kconfig
 create mode 100644 drivers/clocksource/dw_apb_timer.c
 create mode 100644 drivers/clocksource/dw_apb_timer_platform.c
 create mode 100644 include/linux/dw_apb_timer.h

-- 
1.7.4

