Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738Ab2DYPXz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 11:23:55 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:29527 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754152Ab2DYPXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 11:23:54 -0400
X-Authority-Analysis: v=2.0 cv=IaEFqBWa c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=8on2c2KRhUYA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=bgGDqiizJMUdNrunuqAA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1335367432.28106.167.camel@gandalf.stny.rr.com>
Subject: [PATCH v2] kgdb: Do not allow function tracing of kgdb code
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jason Wessel <jason.wessel@windriver.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Date: Wed, 25 Apr 2012 11:23:52 -0400
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As function tracing the kgdb code can cause issues, as kgdb is a
debugger itself, do not trace the kgdb functions.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
v2 - added all files in kernel/debug

diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 532d2e0..b7828ce 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -15,6 +15,7 @@ CFLAGS_REMOVE_pvclock.o = -pg
 CFLAGS_REMOVE_kvmclock.o = -pg
 CFLAGS_REMOVE_ftrace.o = -pg
 CFLAGS_REMOVE_early_printk.o = -pg
+CFLAGS_REMOVE_kgdb.o = -pg
 endif
 
 obj-y			:= process_$(BITS).o signal.o entry_$(BITS).o
diff --git a/kernel/debug/Makefile b/kernel/debug/Makefile
index a85edc3..5fa453c 100644
--- a/kernel/debug/Makefile
+++ b/kernel/debug/Makefile
@@ -2,5 +2,11 @@
 # Makefile for the linux kernel debugger
 #
 
+# Do not function trace debug files
+ifdef CONFIG_FUNCTION_TRACER
+ORIG_CFLAGS := $(KBUILD_CFLAGS)
+KBUILD_CFLAGS = $(subst -pg,,$(ORIG_CFLAGS))
+endif
+
 obj-$(CONFIG_KGDB) += debug_core.o gdbstub.o
 obj-$(CONFIG_KGDB_KDB) += kdb/


