Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965155Ab2B1Nhv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 08:37:51 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:56898 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757236Ab2B1Nhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 08:37:32 -0500
From: Matt Fleming <matt@console-pimps.org>
To: "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>
Subject: [RFC][PATCH 4/6] x86, boot: Restrict CFLAGS for hostprogs
Date: Tue, 28 Feb 2012 13:37:23 +0000
Message-Id: <1330436245-24875-5-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1330436245-24875-1-git-send-email-matt@console-pimps.org>
References: <1330436245-24875-1-git-send-email-matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

Currently tools/build has access to all the kernel headers in
$(srctree). This is unnecessary and could potentially allow
tools/build to erroneously include kernel headers when it should only
be including userspace-exported headers.

Unfortunately, mkcpustr still needs access to some of the asm kernel
headers, so explicitly special case that hostprog.

Cc: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 arch/x86/boot/Makefile |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/boot/Makefile b/arch/x86/boot/Makefile
index 95365a8..3e02148 100644
--- a/arch/x86/boot/Makefile
+++ b/arch/x86/boot/Makefile
@@ -37,8 +37,9 @@ setup-y		+= video-bios.o
 targets		+= $(setup-y)
 hostprogs-y	:= mkcpustr tools/build
 
-HOST_EXTRACFLAGS += $(LINUXINCLUDE)
-
+HOSTCFLAGS_mkcpustr.o := -I$(srctree)/arch/$(SRCARCH)/include
+HOST_EXTRACFLAGS += -I$(objtree)/include -I$(srctree)/tools/include \
+                   -include $(srctree)/include/linux/kconfig.h
 $(obj)/cpu.o: $(obj)/cpustr.h
 
 quiet_cmd_cpustr = CPUSTR  $@
-- 
1.7.4.4

