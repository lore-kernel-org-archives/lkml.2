Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751967Ab2KQPEq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 10:04:46 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:39711 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850Ab2KQPEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 10:04:45 -0500
From: Joachim Eastwood <manabian@gmail.com>
To: dhowells@redhat.com, hskinnemoen@gmail.com, egtvedt@samfundet.no
Cc: linux-kernel@vger.kernel.org, geert@linux-m68k.org,
        Joachim Eastwood <manabian@gmail.com>
Subject: [PATCH] AVR32: switch to generic param.h
Date: Sat, 17 Nov 2012 16:04:18 +0100
Message-Id: <1353164658-14509-1-git-send-email-manabian@gmail.com>
X-Mailer: git-send-email 1.8.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit 83b9d3a0 (UAPI: (Scripted) Disintegrate arch/avr32/include/asm)
building AVR32 spews out tons warnings like this:
 In file included from include/linux/sched.h:11,
                  from init/do_mounts_initrd.c:17:
 /linux-2.6/arch/avr32/include/asm/param.h:6:1: warning: "HZ" redefined

Everything we need from param.h on AVR32 is already in
asm-generic so let's use that.

Signed-off-by: Joachim Eastwood <manabian@gmail.com>
---
 arch/avr32/include/asm/Kbuild  | 1 +
 arch/avr32/include/asm/param.h | 9 ---------
 2 files changed, 1 insertion(+), 9 deletions(-)
 delete mode 100644 arch/avr32/include/asm/param.h

diff --git a/arch/avr32/include/asm/Kbuild b/arch/avr32/include/asm/Kbuild
index 4807ded..f52bd7d 100644
--- a/arch/avr32/include/asm/Kbuild
+++ b/arch/avr32/include/asm/Kbuild
@@ -1,3 +1,4 @@
 
 generic-y	+= clkdev.h
 generic-y	+= exec.h
+generic-y	+= param.h
diff --git a/arch/avr32/include/asm/param.h b/arch/avr32/include/asm/param.h
deleted file mode 100644
index 009a167..0000000
--- a/arch/avr32/include/asm/param.h
+++ /dev/null
@@ -1,9 +0,0 @@
-#ifndef __ASM_AVR32_PARAM_H
-#define __ASM_AVR32_PARAM_H
-
-#include <uapi/asm/param.h>
-
-# define HZ		CONFIG_HZ
-# define USER_HZ	100		/* User interfaces are in "ticks" */
-# define CLOCKS_PER_SEC	(USER_HZ)	/* frequency at which times() counts */
-#endif /* __ASM_AVR32_PARAM_H */
-- 
1.8.0

