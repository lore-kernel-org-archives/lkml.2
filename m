Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756372Ab0EQX3Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 19:29:16 -0400
Received: from xenotime.net ([72.52.115.56]:39536 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756280Ab0EQX3K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 19:29:10 -0400
Date: Mon, 17 May 2010 16:21:11 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 10/10] Documentation: update SubmitChecklist for O=objdir and kconfig testing
Message-ID: <12741384711409@xenotime.net>
In-Reply-To: <12741384711166@xenotime.net>
X-Mailer: gregkh_patchbomb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Add build testing using 'O=builddir'.

Add build testing with various kconfig symbols disabled, listing
common ones that are known to cause build problems.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/SubmitChecklist |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- lnx-2634-docs.orig/Documentation/SubmitChecklist
+++ lnx-2634-docs/Documentation/SubmitChecklist
@@ -18,6 +18,8 @@ kernel patches.
 
 2b: Passes allnoconfig, allmodconfig
 
+2c: Builds successfully when using O=builddir
+
 3: Builds on multiple CPU architectures by using local cross-compile tools
    or some other build farm.
 
@@ -95,3 +97,13 @@ kernel patches.
 
 25: If any ioctl's are added by the patch, then also update
     Documentation/ioctl/ioctl-number.txt.
+
+26: If your modified source code depends on or uses any of the kernel
+    APIs or features that are related to the following kconfig symbols,
+    then test multiple builds with the related kconfig symbols disabled
+    and/or =m (if that option is available) [not all of these at the
+    same time, just various/random combinations of them]:
+
+    CONFIG_SMP, CONFIG_SYSFS, CONFIG_PROC_FS, CONFIG_INPUT, CONFIG_PCI,
+    CONFIG_BLOCK, CONFIG_PM, CONFIG_HOTPLUG, CONFIG_MAGIC_SYSRQ,
+    CONFIG_NET, CONFIG_INET=n (but latter with CONFIG_NET=y)


-- 

