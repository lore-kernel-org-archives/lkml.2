Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030328Ab2B1T2A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 14:28:00 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55031 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030242Ab2B1T16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 14:27:58 -0500
Date: Tue, 28 Feb 2012 11:25:26 -0800
From: tip-bot for Matt Fleming <matt.fleming@intel.com>
Message-ID: <tip-d40f833630a1299fd377408dc8d8fac370d621b0@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de, matt.fleming@intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, matt.fleming@intel.com
In-Reply-To: <1330436245-24875-5-git-send-email-matt@console-pimps.org>
References: <1330436245-24875-5-git-send-email-matt@console-pimps.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/build] x86, boot: Restrict CFLAGS for hostprogs
Git-Commit-ID: d40f833630a1299fd377408dc8d8fac370d621b0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 28 Feb 2012 11:25:54 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d40f833630a1299fd377408dc8d8fac370d621b0
Gitweb:     http://git.kernel.org/tip/d40f833630a1299fd377408dc8d8fac370d621b0
Author:     Matt Fleming <matt.fleming@intel.com>
AuthorDate: Tue, 28 Feb 2012 13:37:23 +0000
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 28 Feb 2012 10:22:59 -0800

x86, boot: Restrict CFLAGS for hostprogs

Currently tools/build has access to all the kernel headers in
$(srctree). This is unnecessary and could potentially allow
tools/build to erroneously include kernel headers when it should only
be including userspace-exported headers.

Unfortunately, mkcpustr still needs access to some of the asm kernel
headers, so explicitly special case that hostprog.

Cc: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Link: http://lkml.kernel.org/r/1330436245-24875-5-git-send-email-matt@console-pimps.org
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
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
