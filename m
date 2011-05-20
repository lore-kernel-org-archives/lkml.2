Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935443Ab1ETRSt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 13:18:49 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41961 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751956Ab1ETRSs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 13:18:48 -0400
Date: Fri, 20 May 2011 19:18:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20110520171836.GA7291@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perf-urgent-for-linus

 Thanks,

	Ingo

------------------>
Ingo Molnar (1):
      core_kernel_data(): Fix architectures that do not define _sdata

Steven Rostedt (1):
      extable, core_kernel_data(): Make sure all archs define _sdata


 arch/alpha/kernel/vmlinux.lds.S   |    1 +
 arch/m32r/kernel/vmlinux.lds.S    |    1 +
 arch/m68k/kernel/vmlinux-std.lds  |    2 ++
 arch/m68k/kernel/vmlinux-sun3.lds |    1 +
 arch/mips/kernel/vmlinux.lds.S    |    1 +
 arch/parisc/kernel/vmlinux.lds.S  |    3 +++
 kernel/extable.c                  |   10 ++++++++++
 7 files changed, 19 insertions(+), 0 deletions(-)

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
index c2d625f..5339705 100644
--- a/kernel/extable.c
+++ b/kernel/extable.c
@@ -72,6 +72,16 @@ int core_kernel_text(unsigned long addr)
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
 	if (addr >= (unsigned long)_sdata &&
