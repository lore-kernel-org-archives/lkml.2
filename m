Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754144Ab0FESKX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 14:10:23 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:32833 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751328Ab0FESKW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 14:10:22 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Tim Abbott <tabbott@ksplice.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] vmlinux.lds.h: allow people to set a smaller rootfs alignment
Date: Sat,  5 Jun 2010 14:14:45 -0400
Message-Id: <1275761686-4996-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new INIT_RAMFS() define to compliment the existing INIT_RAM_FS, but
this one lets people control the alignment.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 include/asm-generic/vmlinux.lds.h |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 48c5299..9ca268f 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -619,14 +619,15 @@
 		VMLINUX_SYMBOL(__security_initcall_end) = .;
 
 #ifdef CONFIG_BLK_DEV_INITRD
-#define INIT_RAM_FS							\
-	. = ALIGN(PAGE_SIZE);						\
+#define INIT_RAMFS(align)						\
+	. = ALIGN(align);						\
 	VMLINUX_SYMBOL(__initramfs_start) = .;				\
 	*(.init.ramfs)							\
 	VMLINUX_SYMBOL(__initramfs_end) = .;
 #else
-#define INIT_RAM_FS
+#define INIT_RAMFS(align)
 #endif
+#define INIT_RAM_FS INIT_RAMFS(PAGE_SIZE)
 
 /*
  * Default discarded sections.
-- 
1.7.1

