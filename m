Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759285Ab1CaTwE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 15:52:04 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:49689 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753865Ab1CaTwC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 15:52:02 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Cc: uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 1/2] percpu: unify input section names
Date: Thu, 31 Mar 2011 15:52:01 -0400
Message-Id: <1301601122-25431-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The two percpu helper macros have the section names duplicated.  So create
a new define to merge the two.  This also allows arches who need to link
things more directly themselves to avoid duplicating the input sections in
their linker script.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 include/asm-generic/vmlinux.lds.h |   34 ++++++++++++++++++----------------
 1 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index fe77e33..7531278 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -682,6 +682,22 @@
 	}
 
 /**
+ * PERCPU_INPUT - the percpu input sections
+ *
+ * The core percpu section names and core symbols which do not rely
+ * directly upon load addresses.
+ */
+#define PERCPU_INPUT							\
+	VMLINUX_SYMBOL(__per_cpu_start) = .;				\
+	*(.data..percpu..first)						\
+	. = ALIGN(PAGE_SIZE);						\
+	*(.data..percpu..page_aligned)					\
+	*(.data..percpu..readmostly)					\
+	*(.data..percpu)						\
+	*(.data..percpu..shared_aligned)				\
+	VMLINUX_SYMBOL(__per_cpu_end) = .;
+
+/**
  * PERCPU_VADDR - define output section for percpu area
  * @vaddr: explicit base address (optional)
  * @phdr: destination PHDR (optional)
@@ -704,14 +720,7 @@
 	VMLINUX_SYMBOL(__per_cpu_load) = .;				\
 	.data..percpu vaddr : AT(VMLINUX_SYMBOL(__per_cpu_load)		\
 				- LOAD_OFFSET) {			\
-		VMLINUX_SYMBOL(__per_cpu_start) = .;			\
-		*(.data..percpu..first)					\
-		. = ALIGN(PAGE_SIZE);					\
-		*(.data..percpu..page_aligned)				\
-		*(.data..percpu..readmostly)				\
-		*(.data..percpu)					\
-		*(.data..percpu..shared_aligned)			\
-		VMLINUX_SYMBOL(__per_cpu_end) = .;			\
+		PERCPU_INPUT						\
 	} phdr								\
 	. = VMLINUX_SYMBOL(__per_cpu_load) + SIZEOF(.data..percpu);
 
@@ -732,14 +741,7 @@
 	. = ALIGN(align);						\
 	.data..percpu	: AT(ADDR(.data..percpu) - LOAD_OFFSET) {	\
 		VMLINUX_SYMBOL(__per_cpu_load) = .;			\
-		VMLINUX_SYMBOL(__per_cpu_start) = .;			\
-		*(.data..percpu..first)					\
-		. = ALIGN(PAGE_SIZE);					\
-		*(.data..percpu..page_aligned)				\
-		*(.data..percpu..readmostly)				\
-		*(.data..percpu)					\
-		*(.data..percpu..shared_aligned)			\
-		VMLINUX_SYMBOL(__per_cpu_end) = .;			\
+		PERCPU_INPUT						\
 	}
 
 
-- 
1.7.4.1

