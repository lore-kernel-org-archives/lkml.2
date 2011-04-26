Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757642Ab1DZUAl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 16:00:41 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:56189 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757275Ab1DZUAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 16:00:40 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=CL/Ghk5HZbw18lt7UcHBCT2/f6E7ECN2fHmrXIROqAgR8z9zrwkwxx0pLn21YWy8seiHzw8NR+X8/cVgDmgUapu2bCh3AunGGbnXySCwFbmwvaLkeQqEIrzKT23hsO/y;
Date: Tue, 26 Apr 2011 13:00:36 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, David Rientjes <rientjes@google.com>,
        Peter Foley <pefoley2@verizon.net>,
        torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 2/2] init/Kconfig: use if/endif to surround the EXPERT menu
 kconfig symbols
Message-Id: <20110426130036.997a05fc.rdunlap@xenotime.net>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Surround the EXPERT menu with "if EXPERT" and "endif" so that it
is forced to stay as one unit.  Hopefully this will help to prevent
it being broken in the future.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Peter Foley <pefoley2@verizon.net>
---
 init/Kconfig |   36 ++++++++++++++++++++----------------
 1 file changed, 20 insertions(+), 16 deletions(-)

--- lnx-2639-rc4.orig/init/Kconfig
+++ lnx-2639-rc4/init/Kconfig
@@ -924,15 +924,17 @@ menuconfig EXPERT
           environments which can tolerate a "non-standard" kernel.
           Only use this if you really know what you are doing.
 
+if EXPERT
+
 config UID16
-	bool "Enable 16-bit UID system calls" if EXPERT
+	bool "Enable 16-bit UID system calls"
 	depends on ARM || BLACKFIN || CRIS || FRV || H8300 || X86_32 || M68K || (S390 && !64BIT) || SUPERH || SPARC32 || (SPARC64 && COMPAT) || UML || (X86_64 && IA32_EMULATION)
 	default y
 	help
 	  This enables the legacy 16-bit UID syscall wrappers.
 
 config SYSCTL_SYSCALL
-	bool "Sysctl syscall support" if EXPERT
+	bool "Sysctl syscall support"
 	depends on PROC_SYSCTL
 	default y
 	select SYSCTL
@@ -949,7 +951,7 @@ config SYSCTL_SYSCALL
 	  If unsure say Y here.
 
 config KALLSYMS
-	 bool "Load all symbols for debugging/ksymoops" if EXPERT
+	 bool "Load all symbols for debugging/ksymoops"
 	 default y
 	 help
 	   Say Y here to let the kernel print out symbolic crash information and
@@ -980,7 +982,7 @@ config KALLSYMS_EXTRA_PASS
 
 
 config HOTPLUG
-	bool "Support for hot-pluggable devices" if EXPERT
+	bool "Support for hot-pluggable devices"
 	default y
 	help
 	  This option is provided for the case where no hotplug or uevent
@@ -990,7 +992,7 @@ config HOTPLUG
 
 config PRINTK
 	default y
-	bool "Enable support for printk" if EXPERT
+	bool "Enable support for printk"
 	help
 	  This option enables normal printk support. Removing it
 	  eliminates most of the message strings from the kernel image
@@ -999,7 +1001,7 @@ config PRINTK
 	  strongly discouraged.
 
 config BUG
-	bool "BUG() support" if EXPERT
+	bool "BUG() support"
 	default y
 	help
           Disabling this option eliminates support for BUG and WARN, reducing
@@ -1010,12 +1012,12 @@ config BUG
 
 config ELF_CORE
 	default y
-	bool "Enable ELF core dumps" if EXPERT
+	bool "Enable ELF core dumps"
 	help
 	  Enable support for generating core dumps. Disabling saves about 4k.
 
 config PCSPKR_PLATFORM
-	bool "Enable PC-Speaker support" if EXPERT
+	bool "Enable PC-Speaker support"
 	depends on ALPHA || X86 || MIPS || PPC_PREP || PPC_CHRP || PPC_PSERIES
 	default y
 	help
@@ -1024,14 +1026,14 @@ config PCSPKR_PLATFORM
 
 config BASE_FULL
 	default y
-	bool "Enable full-sized data structures for core" if EXPERT
+	bool "Enable full-sized data structures for core"
 	help
 	  Disabling this option reduces the size of miscellaneous core
 	  kernel data structures. This saves memory on small machines,
 	  but may reduce performance.
 
 config FUTEX
-	bool "Enable futex support" if EXPERT
+	bool "Enable futex support"
 	default y
 	select RT_MUTEXES
 	help
@@ -1040,7 +1042,7 @@ config FUTEX
 	  run glibc-based applications correctly.
 
 config EPOLL
-	bool "Enable eventpoll support" if EXPERT
+	bool "Enable eventpoll support"
 	default y
 	select ANON_INODES
 	help
@@ -1048,7 +1050,7 @@ config EPOLL
 	  support for epoll family of system calls.
 
 config SIGNALFD
-	bool "Enable signalfd() system call" if EXPERT
+	bool "Enable signalfd() system call"
 	select ANON_INODES
 	default y
 	help
@@ -1058,7 +1060,7 @@ config SIGNALFD
 	  If unsure, say Y.
 
 config TIMERFD
-	bool "Enable timerfd() system call" if EXPERT
+	bool "Enable timerfd() system call"
 	select ANON_INODES
 	default y
 	help
@@ -1068,7 +1070,7 @@ config TIMERFD
 	  If unsure, say Y.
 
 config EVENTFD
-	bool "Enable eventfd() system call" if EXPERT
+	bool "Enable eventfd() system call"
 	select ANON_INODES
 	default y
 	help
@@ -1078,7 +1080,7 @@ config EVENTFD
 	  If unsure, say Y.
 
 config SHMEM
-	bool "Use full shmem filesystem" if EXPERT
+	bool "Use full shmem filesystem"
 	default y
 	depends on MMU
 	help
@@ -1089,13 +1091,15 @@ config SHMEM
 	  which may be appropriate on small systems without swap.
 
 config AIO
-	bool "Enable AIO support" if EXPERT
+	bool "Enable AIO support"
 	default y
 	help
 	  This option enables POSIX asynchronous I/O which may by used
           by some high performance threaded applications. Disabling
           this option saves about 7k.
 
+endif # EXPERT menu
+
 config EMBEDDED
 	bool "Embedded system"
 	select EXPERT
