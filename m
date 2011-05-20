Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934683Ab1ETIIW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 04:08:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:57354 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934163Ab1ETIIQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 04:08:16 -0400
Date: Fri, 20 May 2011 08:07:06 GMT
From: tip-bot for Steven Rostedt <rostedt@goodmis.org>
Message-ID: <tip-a2d063ac216c1618bfc2b4d40b7176adffa63511@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        kyle@mcmartin.ca, geert@linux-m68k.org, rostedt@goodmis.org,
        ralf@linux-mips.org, jejb@parisc-linux.org, mattst88@gmail.com,
        ink@jurassic.park.msu.ru, tglx@linutronix.de, takata@linux-m32r.org,
        zippel@linux-m68k.org, deller@gmx.de, rth@twiddle.net, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        kyle@mcmartin.ca, geert@linux-m68k.org, rostedt@goodmis.org,
        ralf@linux-mips.org, jejb@parisc-linux.org, mattst88@gmail.com,
        ink@jurassic.park.msu.ru, zippel@linux-m68k.org, takata@linux-m32r.org,
        tglx@linutronix.de, rth@twiddle.net, deller@gmx.de, mingo@elte.hu
In-Reply-To: <1305855298.1465.19.camel@gandalf.stny.rr.com>
References: <1305855298.1465.19.camel@gandalf.stny.rr.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] extable, core_kernel_data(): Make sure all archs define _sdata
Git-Commit-ID: a2d063ac216c1618bfc2b4d40b7176adffa63511
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 20 May 2011 08:07:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a2d063ac216c1618bfc2b4d40b7176adffa63511
Gitweb:     http://git.kernel.org/tip/a2d063ac216c1618bfc2b4d40b7176adffa63511
Author:     Steven Rostedt <rostedt@goodmis.org>
AuthorDate: Thu, 19 May 2011 21:34:58 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 20 May 2011 08:56:56 +0200

extable, core_kernel_data(): Make sure all archs define _sdata

A new utility function (core_kernel_data()) is used to determine if a
passed in address is part of core kernel data or not. It may or may not
return true for RO data, but this utility must work for RW data.

Thus both _sdata and _edata must be defined and continuous,
without .init sections that may later be freed and replaced by
volatile memory (memory that can be freed).

This utility function is used to determine if data is safe from
ever being freed. Thus it should return true for all RW global
data that is not in a module or has been allocated, or false
otherwise.

Also change core_kernel_data() back to the more precise _sdata condition
and document the function.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Acked-by: Ralf Baechle <ralf@linux-mips.org>
Acked-by: Hirokazu Takata <takata@linux-m32r.org>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: linux-m68k@lists.linux-m68k.org
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Helge Deller <deller@gmx.de>
Cc: JamesE.J.Bottomley <jejb@parisc-linux.org>
Link: http://lkml.kernel.org/r/1305855298.1465.19.camel@gandalf.stny.rr.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
----
 arch/alpha/kernel/vmlinux.lds.S   |    1 +
 arch/m32r/kernel/vmlinux.lds.S    |    1 +
 arch/m68k/kernel/vmlinux-std.lds  |    2 ++
 arch/m68k/kernel/vmlinux-sun3.lds |    1 +
 arch/mips/kernel/vmlinux.lds.S    |    1 +
 arch/parisc/kernel/vmlinux.lds.S  |    3 +++
 kernel/extable.c                  |   12 +++++++++++-
 7 files changed, 20 insertions(+), 1 deletion(-)
---
 arch/alpha/kernel/vmlinux.lds.S   |    1 +
 arch/m32r/kernel/vmlinux.lds.S    |    1 +
 arch/m68k/kernel/vmlinux-std.lds  |    2 ++
 arch/m68k/kernel/vmlinux-sun3.lds |    1 +
 arch/mips/kernel/vmlinux.lds.S    |    1 +
 arch/parisc/kernel/vmlinux.lds.S  |    3 +++
 kernel/extable.c                  |   12 +++++++++++-
 7 files changed, 20 insertions(+), 1 deletions(-)

diff --git a/arch/alpha/kernel/vmlinux.lds.S b/arch/alpha/kernel/vmlinux.lds.S
index 433be2a..3d890a9 100644
--- a/arch/alpha/kernel/vmlinux.lds.S
+++ b/arch/alpha/kernel/vmlinux.lds.S
@@ -46,6 +46,7 @@ SECTIONS
 	__init_end = .;
 	/* Freed after init ends here */
 
+	_sdata = .;	/* Start of rw data section */
 	_data = .;
 	RW_DATA_SECTION(L1_CACHE_BYTES, PAGE_SIZE, THREAD_SIZE)
 
diff --git a/arch/m32r/kernel/vmlinux.lds.S b/arch/m32r/kernel/vmlinux.lds.S
index c194d64..cf95aec 100644
--- a/arch/m32r/kernel/vmlinux.lds.S
+++ b/arch/m32r/kernel/vmlinux.lds.S
@@ -44,6 +44,7 @@ SECTIONS
   EXCEPTION_TABLE(16)
   NOTES
 
+  _sdata = .;			/* Start of data section */
   RODATA
   RW_DATA_SECTION(32, PAGE_SIZE, THREAD_SIZE)
   _edata = .;			/* End of data section */
diff --git a/arch/m68k/kernel/vmlinux-std.lds b/arch/m68k/kernel/vmlinux-std.lds
index 878be5f..d099359 100644
--- a/arch/m68k/kernel/vmlinux-std.lds
+++ b/arch/m68k/kernel/vmlinux-std.lds
@@ -25,6 +25,8 @@ SECTIONS
 
   EXCEPTION_TABLE(16)
 
+  _sdata = .;			/* Start of data section */
+
   RODATA
 
   RW_DATA_SECTION(16, PAGE_SIZE, THREAD_SIZE)
diff --git a/arch/m68k/kernel/vmlinux-sun3.lds b/arch/m68k/kernel/vmlinux-sun3.lds
index 1ad6b7a..8080469 100644
--- a/arch/m68k/kernel/vmlinux-sun3.lds
+++ b/arch/m68k/kernel/vmlinux-sun3.lds
@@ -25,6 +25,7 @@ SECTIONS
   _etext = .;			/* End of text section */
 
   EXCEPTION_TABLE(16) :data
+  _sdata = .;			/* Start of rw data section */
   RW_DATA_SECTION(16, PAGE_SIZE, THREAD_SIZE) :data
   /* End of data goes *here* so that freeing init code works properly. */
   _edata = .;
diff --git a/arch/mips/kernel/vmlinux.lds.S b/arch/mips/kernel/vmlinux.lds.S
index cd2ca54..01af387 100644
--- a/arch/mips/kernel/vmlinux.lds.S
+++ b/arch/mips/kernel/vmlinux.lds.S
@@ -65,6 +65,7 @@ SECTIONS
 	NOTES :text :note
 	.dummy : { *(.dummy) } :text
 
+	_sdata = .;			/* Start of data section */
 	RODATA
 
 	/* writeable */
diff --git a/arch/parisc/kernel/vmlinux.lds.S b/arch/parisc/kernel/vmlinux.lds.S
index 8f1e4ef..2d9a5c7 100644
--- a/arch/parisc/kernel/vmlinux.lds.S
+++ b/arch/parisc/kernel/vmlinux.lds.S
@@ -69,6 +69,9 @@ SECTIONS
 	/* End of text section */
 	_etext = .;
 
+	/* Start of data section */
+	_sdata = .;
+
 	RODATA
 
 	/* writeable */
diff --git a/kernel/extable.c b/kernel/extable.c
index d44aac0..5339705 100644
--- a/kernel/extable.c
+++ b/kernel/extable.c
@@ -72,9 +72,19 @@ int core_kernel_text(unsigned long addr)
 	return 0;
 }
 
+/**
+ * core_kernel_data - tell if addr points to kernel data
+ * @addr: address to test
+ *
+ * Returns true if @addr passed in is from the core kernel data
+ * section.
+ *
+ * Note: On some archs it may return true for core RODATA, and false
+ *  for others. But will always be true for core RW data.
+ */
 int core_kernel_data(unsigned long addr)
 {
-	if (addr >= (unsigned long)_stext &&
+	if (addr >= (unsigned long)_sdata &&
 	    addr < (unsigned long)_edata)
 		return 1;
 	return 0;
