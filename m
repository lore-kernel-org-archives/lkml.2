Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755755Ab0DVRpI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 13:45:08 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:62376 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755147Ab0DVRpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 13:45:05 -0400
Date: Thu, 22 Apr 2010 10:44:50 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>
Subject: [PATCH] Documentation: additions to SubmitChecklist
Message-Id: <20100422104450.f559b794.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-CT-RefId: str=0001.0A090203.4BD08B18.0015:SCFMA4539811,ss=1,fgs=0
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

--- linux-2.6.34-rc3-git5.orig/Documentation/SubmitChecklist
+++ linux-2.6.34-rc3-git5/Documentation/SubmitChecklist
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
