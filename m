Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037Ab0EXAJi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 20:09:38 -0400
Received: from xenotime.net ([72.52.115.56]:42054 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755733Ab0EXAIE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 20:08:04 -0400
Date: Sun, 23 May 2010 17:02:30 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 9/9] Documentation: update SubmitChecklist for O=objdir and kconfig testing
Message-ID: <1274659350366@xenotime.net>
In-Reply-To: <12746593501290@xenotime.net>
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

