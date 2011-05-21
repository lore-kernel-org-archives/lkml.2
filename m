Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098Ab1EUMMX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 08:12:23 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44578 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755677Ab1EUMMR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 08:12:17 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 2/3] PM / Hibernate: Remove arch_prepare_suspend()
Date: Sat, 21 May 2011 14:10:34 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39+; KDE/4.6.0; x86_64; ; )
Cc: Frank Hofmann <frank.hofmann@tomtom.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-sh@vger.kernel.org,
        Ralf Baechle <ralf@linux-mips.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
References: <201105211408.28671.rjw@sisk.pl>
In-Reply-To: <201105211408.28671.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201105211410.34491.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

All architectures supporting hibernation define
arch_prepare_suspend() as an empty function, so remove it.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/frv/include/asm/suspend.h       |   20 --------------------
 arch/mips/include/asm/suspend.h      |    2 --
 arch/powerpc/include/asm/suspend.h   |    6 ------
 arch/s390/include/asm/suspend.h      |   10 ----------
 arch/sh/include/asm/suspend.h        |    1 -
 arch/unicore32/include/asm/suspend.h |    1 -
 arch/x86/include/asm/suspend_32.h    |    2 --
 arch/x86/include/asm/suspend_64.h    |    5 -----
 kernel/power/hibernate.c             |    4 ----
 9 files changed, 51 deletions(-)

Index: linux-2.6/arch/frv/include/asm/suspend.h
===================================================================
--- linux-2.6.orig/arch/frv/include/asm/suspend.h
+++ /dev/null
@@ -1,20 +0,0 @@
-/* suspend.h: suspension stuff
- *
- * Copyright (C) 2004 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version
- * 2 of the License, or (at your option) any later version.
- */
-
-#ifndef _ASM_SUSPEND_H
-#define _ASM_SUSPEND_H
-
-static inline int arch_prepare_suspend(void)
-{
-	return 0;
-}
-
-#endif /* _ASM_SUSPEND_H */
Index: linux-2.6/arch/s390/include/asm/suspend.h
===================================================================
--- linux-2.6.orig/arch/s390/include/asm/suspend.h
+++ /dev/null
@@ -1,10 +0,0 @@
-#ifndef __ASM_S390_SUSPEND_H
-#define __ASM_S390_SUSPEND_H
-
-static inline int arch_prepare_suspend(void)
-{
-	return 0;
-}
-
-#endif
-
Index: linux-2.6/arch/sh/include/asm/suspend.h
===================================================================
--- linux-2.6.orig/arch/sh/include/asm/suspend.h
+++ linux-2.6/arch/sh/include/asm/suspend.h
@@ -3,7 +3,6 @@
 
 #ifndef __ASSEMBLY__
 #include <linux/notifier.h>
-static inline int arch_prepare_suspend(void) { return 0; }
 
 #include <asm/ptrace.h>
 
Index: linux-2.6/arch/mips/include/asm/suspend.h
===================================================================
--- linux-2.6.orig/arch/mips/include/asm/suspend.h
+++ linux-2.6/arch/mips/include/asm/suspend.h
@@ -1,8 +1,6 @@
 #ifndef __ASM_SUSPEND_H
 #define __ASM_SUSPEND_H
 
-static inline int arch_prepare_suspend(void) { return 0; }
-
 /* References to section boundaries */
 extern const void __nosave_begin, __nosave_end;
 
Index: linux-2.6/arch/powerpc/include/asm/suspend.h
===================================================================
--- linux-2.6.orig/arch/powerpc/include/asm/suspend.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef __ASM_POWERPC_SUSPEND_H
-#define __ASM_POWERPC_SUSPEND_H
-
-static inline int arch_prepare_suspend(void) { return 0; }
-
-#endif /* __ASM_POWERPC_SUSPEND_H */
Index: linux-2.6/arch/unicore32/include/asm/suspend.h
===================================================================
--- linux-2.6.orig/arch/unicore32/include/asm/suspend.h
+++ linux-2.6/arch/unicore32/include/asm/suspend.h
@@ -14,7 +14,6 @@
 #define __UNICORE_SUSPEND_H__
 
 #ifndef __ASSEMBLY__
-static inline int arch_prepare_suspend(void) { return 0; }
 
 #include <asm/ptrace.h>
 
Index: linux-2.6/arch/x86/include/asm/suspend_32.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/suspend_32.h
+++ linux-2.6/arch/x86/include/asm/suspend_32.h
@@ -9,8 +9,6 @@
 #include <asm/desc.h>
 #include <asm/i387.h>
 
-static inline int arch_prepare_suspend(void) { return 0; }
-
 /* image of the saved processor state */
 struct saved_context {
 	u16 es, fs, gs, ss;
Index: linux-2.6/arch/x86/include/asm/suspend_64.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/suspend_64.h
+++ linux-2.6/arch/x86/include/asm/suspend_64.h
@@ -9,11 +9,6 @@
 #include <asm/desc.h>
 #include <asm/i387.h>
 
-static inline int arch_prepare_suspend(void)
-{
-	return 0;
-}
-
 /*
  * Image of the saved processor state, used by the low level ACPI suspend to
  * RAM code and by the low level hibernation code.
Index: linux-2.6/kernel/power/hibernate.c
===================================================================
--- linux-2.6.orig/kernel/power/hibernate.c
+++ linux-2.6/kernel/power/hibernate.c
@@ -244,10 +244,6 @@ static int create_image(int platform_mod
 {
 	int error;
 
-	error = arch_prepare_suspend();
-	if (error)
-		return error;
-
 	error = dpm_suspend_noirq(PMSG_FREEZE);
 	if (error) {
 		printk(KERN_ERR "PM: Some devices failed to power down, "

