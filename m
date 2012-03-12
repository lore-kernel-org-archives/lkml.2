Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964916Ab2CLXkB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 19:40:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18420 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758193Ab2CLXj6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 19:39:58 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 22/35] Disintegrate asm/system.h for OpenRISC [ver #2]
To: paul.gortmaker@windriver.com, hpa@zytor.com
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, arnd@arndb.de,
        David Howells <dhowells@redhat.com>, linux@openrisc.net
Date: Mon, 12 Mar 2012 23:39:45 +0000
Message-ID: <20120312233945.13888.46955.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120312233602.13888.27659.stgit@warthog.procyon.org.uk>
References: <20120312233602.13888.27659.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Disintegrate asm/system.h for OpenRISC.  Not compiled.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: linux@lists.openrisc.net
---

 arch/openrisc/include/asm/Kbuild   |    3 +++
 arch/openrisc/include/asm/system.h |   40 +++++-------------------------------
 arch/openrisc/kernel/idle.c        |    1 -
 arch/openrisc/kernel/process.c     |    1 -
 arch/openrisc/kernel/prom.c        |    1 -
 arch/openrisc/kernel/ptrace.c      |    1 -
 arch/openrisc/kernel/setup.c       |    1 -
 arch/openrisc/kernel/traps.c       |    1 -
 arch/openrisc/mm/init.c            |    1 -
 arch/openrisc/mm/tlb.c             |    1 -
 10 files changed, 8 insertions(+), 43 deletions(-)

diff --git a/arch/openrisc/include/asm/Kbuild b/arch/openrisc/include/asm/Kbuild
index 11162e6..dcea5a0 100644
--- a/arch/openrisc/include/asm/Kbuild
+++ b/arch/openrisc/include/asm/Kbuild
@@ -4,6 +4,7 @@ header-y += spr_defs.h
 
 generic-y += atomic.h
 generic-y += auxvec.h
+generic-y += barrier.h
 generic-y += bitsperlong.h
 generic-y += bug.h
 generic-y += bugs.h
@@ -19,6 +20,7 @@ generic-y += div64.h
 generic-y += dma.h
 generic-y += emergency-restart.h
 generic-y += errno.h
+generic-y += exec.h
 generic-y += fb.h
 generic-y += fcntl.h
 generic-y += ftrace.h
@@ -55,6 +57,7 @@ generic-y += sockios.h
 generic-y += statfs.h
 generic-y += stat.h
 generic-y += string.h
+generic-y += switch_to.h
 generic-y += swab.h
 generic-y += termbits.h
 generic-y += termios.h
diff --git a/arch/openrisc/include/asm/system.h b/arch/openrisc/include/asm/system.h
index cf65888..a7f4057 100644
--- a/arch/openrisc/include/asm/system.h
+++ b/arch/openrisc/include/asm/system.h
@@ -1,35 +1,5 @@
-/*
- * OpenRISC Linux
- *
- * Linux architectural port borrowing liberally from similar works of
- * others.  All original copyrights apply as per the original source
- * declaration.
- *
- * OpenRISC implementation:
- * Copyright (C) 2003 Matjaz Breskvar <phoenix@bsemi.com>
- * Copyright (C) 2010-2011 Jonas Bonn <jonas@southpole.se>
- * et al.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
-
-#ifndef __ASM_OPENRISC_SYSTEM_H
-#define __ASM_OPENRISC_SYSTEM_H
-
-#ifdef __KERNEL__
-#ifndef __ASSEMBLY__
-
-#include <asm/spr.h>
-#include <asm-generic/system.h>
-
-/* We probably need this definition, but the generic system.h provides it
- * and it's not used on our arch anyway...
- */
-/*#define nop() __asm__ __volatile__ ("l.nop"::)*/
-
-#endif /* __ASSEMBLY__ */
-#endif /* __KERNEL__ */
-#endif /* __ASM_OPENRISC_SYSTEM_H */
+/* FILE TO BE DELETED. DO NOT ADD STUFF HERE! */
+#include <asm/barrier.h>
+#include <asm/cmpxchg.h>
+#include <asm/exec.h>
+#include <asm/switch_to.h>
diff --git a/arch/openrisc/kernel/idle.c b/arch/openrisc/kernel/idle.c
index e5fc7887..7d618fe 100644
--- a/arch/openrisc/kernel/idle.c
+++ b/arch/openrisc/kernel/idle.c
@@ -31,7 +31,6 @@
 
 #include <asm/pgtable.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/processor.h>
 #include <asm/mmu.h>
diff --git a/arch/openrisc/kernel/process.c b/arch/openrisc/kernel/process.c
index e4209af..55210f3 100644
--- a/arch/openrisc/kernel/process.c
+++ b/arch/openrisc/kernel/process.c
@@ -38,7 +38,6 @@
 
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/processor.h>
 #include <asm/spr_defs.h>
diff --git a/arch/openrisc/kernel/prom.c b/arch/openrisc/kernel/prom.c
index 3d4478f..5869e3f 100644
--- a/arch/openrisc/kernel/prom.c
+++ b/arch/openrisc/kernel/prom.c
@@ -42,7 +42,6 @@
 #include <asm/processor.h>
 #include <asm/irq.h>
 #include <linux/io.h>
-#include <asm/system.h>
 #include <asm/mmu.h>
 #include <asm/pgtable.h>
 #include <asm/sections.h>
diff --git a/arch/openrisc/kernel/ptrace.c b/arch/openrisc/kernel/ptrace.c
index 7259047..967d499 100644
--- a/arch/openrisc/kernel/ptrace.c
+++ b/arch/openrisc/kernel/ptrace.c
@@ -33,7 +33,6 @@
 #include <asm/segment.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
-#include <asm/system.h>
 
 /*
  * Copy the thread state to a regset that can be interpreted by userspace.
diff --git a/arch/openrisc/kernel/setup.c b/arch/openrisc/kernel/setup.c
index 1422f74..ad2c290 100644
--- a/arch/openrisc/kernel/setup.c
+++ b/arch/openrisc/kernel/setup.c
@@ -41,7 +41,6 @@
 #include <linux/of_platform.h>
 
 #include <asm/segment.h>
-#include <asm/system.h>
 #include <asm/pgtable.h>
 #include <asm/types.h>
 #include <asm/setup.h>
diff --git a/arch/openrisc/kernel/traps.c b/arch/openrisc/kernel/traps.c
index a4ec44a..52ca32b 100644
--- a/arch/openrisc/kernel/traps.c
+++ b/arch/openrisc/kernel/traps.c
@@ -33,7 +33,6 @@
 #include <linux/kallsyms.h>
 #include <asm/uaccess.h>
 
-#include <asm/system.h>
 #include <asm/segment.h>
 #include <asm/io.h>
 #include <asm/pgtable.h>
diff --git a/arch/openrisc/mm/init.c b/arch/openrisc/mm/init.c
index 359dcb2..1cf3a8a 100644
--- a/arch/openrisc/mm/init.c
+++ b/arch/openrisc/mm/init.c
@@ -33,7 +33,6 @@
 #include <linux/pagemap.h>
 #include <linux/memblock.h>
 
-#include <asm/system.h>
 #include <asm/segment.h>
 #include <asm/pgalloc.h>
 #include <asm/pgtable.h>
diff --git a/arch/openrisc/mm/tlb.c b/arch/openrisc/mm/tlb.c
index 56b0b89..683bd4d 100644
--- a/arch/openrisc/mm/tlb.c
+++ b/arch/openrisc/mm/tlb.c
@@ -26,7 +26,6 @@
 #include <linux/mm.h>
 #include <linux/init.h>
 
-#include <asm/system.h>
 #include <asm/segment.h>
 #include <asm/tlbflush.h>
 #include <asm/pgtable.h>

