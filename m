Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827Ab2JGTTP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 15:19:15 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:48525 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626Ab2JGTTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 15:19:04 -0400
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: <linux-kernel@vger.kernel.org>
Cc: Tim Bird <tim.bird@am.sony.com>, mmarek@suse.cz, sam@ravnborg.org,
        rientjes@google.com, Ezequiel Garcia <elezegarcia@gmail.com>
Subject: [PATCH v2] Makefile: Add option to disable gcc automatic inlining
Date: Sun,  7 Oct 2012 16:18:52 -0300
Message-Id: <1349637532-27466-1-git-send-email-elezegarcia@gmail.com>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new option is CONFIG_CC_DISABLE_AUTO_INLINE and it's
located at:
  * Kernel hacking
    * Disable gcc automatic inlining

This option appends this options CFLAGS:

-fno-default-inline
-fno-inline
-fno-inline-small-functions
-fno-indirect-inlining
-fno-inline-functions-called-once

It's still not clear which of these really work and which doesn't.
Just in case, just disable all of them.

Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
Changes from v1:
 * Change define name to CONFIG_CC_XXX
 * Disable all options that refer to inlining

This work is part of CELF Workgroup Project:
"Kernel_dynamic_memory_allocation_tracking_and_reduction":
http://elinux.org/Kernel_dynamic_memory_allocation_tracking_and_reduction

 Makefile             |    8 ++++++++
 kernel/trace/Kconfig |    4 ++++
 2 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/Makefile b/Makefile
index ddf5be9..3169603 100644
--- a/Makefile
+++ b/Makefile
@@ -561,6 +561,14 @@ else
 KBUILD_CFLAGS	+= -O2
 endif
 
+ifdef CONFIG_CC_DISABLE_AUTO_INLINE
+KBUILD_CFLAGS	+= -fno-default-inline \
+		   -fno-inline \
+		   -fno-inline-small-functions \
+		   -fno-indirect-inlining \
+		   -fno-inline-functions-called-once
+endif
+
 include $(srctree)/arch/$(SRCARCH)/Makefile
 
 ifdef CONFIG_READABLE_ASM
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 8c4c070..144da36 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -128,6 +128,10 @@ config TRACING_SUPPORT
 	depends on STACKTRACE_SUPPORT
 	default y
 
+config CC_DISABLE_AUTO_INLINE
+	bool "Disable gcc automatic inlining"
+	default n
+
 if TRACING_SUPPORT
 
 menuconfig FTRACE
-- 
1.7.8.6

