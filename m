Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870Ab2DWFDH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 01:03:07 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:58540 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703Ab2DWFDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 01:03:05 -0400
Date: Mon, 23 Apr 2012 13:42:43 +0930
From: Christopher Yeoh <cyeoh@au1.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Adds Kconfig option for Cross Memory Attach
Message-ID: <20120423134243.5ac73596@Gantu>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
x-cbid: 12042218-5140-0000-0000-0000011E72E7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Attached is a patch which you asked for a while back which adds a
Kconfig option to allow people who don't want cross memory attach to not
have it included in their build.

Regards,

Chris
-- 
cyeoh@au.ibm.com

Signed-off-by: Chris Yeoh <yeohc@au1.ibm.com>
 Kconfig  |   11 +++++++++++
 Makefile |    7 +++++--
 2 files changed, 16 insertions(+), 2 deletions(-)
diff --git a/mm/Kconfig b/mm/Kconfig
index e338407..7619f90 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -379,3 +379,14 @@ config CLEANCACHE
 	  in a negligible performance hit.
 
 	  If unsure, say Y to enable cleancache
+
+config CROSS_MEMORY_ATTACH
+	bool "Cross Memory Support"
+	depends on MMU
+	default y
+	help
+	  Enabling this option adds the system calls process_vm_readv and
+	  process_vm_writev which allow a process with the correct privileges
+	  to directly read from or write to to another process's address space.
+	  See the man page for more details.
+
diff --git a/mm/Makefile b/mm/Makefile
index 50ec00e..1ddd00f 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -5,8 +5,11 @@
 mmu-y			:= nommu.o
 mmu-$(CONFIG_MMU)	:= fremap.o highmem.o madvise.o memory.o mincore.o \
 			   mlock.o mmap.o mprotect.o mremap.o msync.o rmap.o \
-			   vmalloc.o pagewalk.o pgtable-generic.o \
-			   process_vm_access.o
+			   vmalloc.o pagewalk.o pgtable-generic.o
+
+ifdef CONFIG_CROSS_MEMORY_ATTACH
+mmu-$(CONFIG_MMU)	+= process_vm_access.o
+endif
 
 obj-y			:= filemap.o mempool.o oom_kill.o fadvise.o \
 			   maccess.o page_alloc.o page-writeback.o \

