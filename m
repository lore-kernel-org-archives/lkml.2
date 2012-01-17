Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752409Ab2AQRZV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 12:25:21 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57575 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434Ab2AQRZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 12:25:19 -0500
Date: Tue, 17 Jan 2012 09:24:54 -0800
From: tip-bot for Randy Dunlap <rdunlap@xenotime.net>
Message-ID: <tip-5ee71535440f034de1196b11f78cef81c4025c2b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, rdunlap@xenotime.net,
        tglx@linutronix.de, rientjes@google.com, linux-mm@kvack.org,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, rdunlap@xenotime.net,
        tglx@linutronix.de, rientjes@google.com, linux-mm@kvack.org,
        mingo@elte.hu
In-Reply-To: <4F14811E.6090107@xenotime.net>
References: <4F14811E.6090107@xenotime.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/kconfig: Move the ZONE_DMA entry under a menu
Git-Commit-ID: 5ee71535440f034de1196b11f78cef81c4025c2b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 17 Jan 2012 09:25:03 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5ee71535440f034de1196b11f78cef81c4025c2b
Gitweb:     http://git.kernel.org/tip/5ee71535440f034de1196b11f78cef81c4025c2b
Author:     Randy Dunlap <rdunlap@xenotime.net>
AuthorDate: Mon, 16 Jan 2012 11:57:18 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 17 Jan 2012 10:41:36 +0100

x86/kconfig: Move the ZONE_DMA entry under a menu

Move the ZONE_DMA kconfig symbol under a menu item instead
of having it listed before everything else in
"make {xconfig | gconfig | nconfig | menuconfig}".

This drops the first line of the top-level kernel config menu
(in 3.2) below and moves it under "Processor type and features".

          [*] DMA memory allocation support
              General setup  --->
          [*] Enable loadable module support  --->
          [*] Enable the block layer  --->
              Processor type and features  --->
              Power management and ACPI options  --->
              Bus options (PCI etc.)  --->
              Executable file formats / Emulations  --->

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org <linux-mm@kvack.org>
Link: http://lkml.kernel.org/r/4F14811E.6090107@xenotime.net
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: David Rientjes <rientjes@google.com>
---
 arch/x86/Kconfig |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 5731eb7..db190fa 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -120,16 +120,6 @@ config HAVE_LATENCYTOP_SUPPORT
 config MMU
 	def_bool y
 
-config ZONE_DMA
-	bool "DMA memory allocation support" if EXPERT
-	default y
-	help
-	  DMA memory allocation support allows devices with less than 32-bit
-	  addressing to allocate within the first 16MB of address space.
-	  Disable if no such devices will be used.
-
-	  If unsure, say Y.
-
 config SBUS
 	bool
 
@@ -253,6 +243,16 @@ source "kernel/Kconfig.freezer"
 
 menu "Processor type and features"
 
+config ZONE_DMA
+	bool "DMA memory allocation support" if EXPERT
+	default y
+	help
+	  DMA memory allocation support allows devices with less than 32-bit
+	  addressing to allocate within the first 16MB of address space.
+	  Disable if no such devices will be used.
+
+	  If unsure, say Y.
+
 source "kernel/time/Kconfig"
 
 config SMP
