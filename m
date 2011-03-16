Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340Ab1CPSFn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 14:05:43 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:12008 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751606Ab1CPSFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 14:05:37 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bhz32i668h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LI5WX6-01-8IK-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
        oprofile-list <oprofile-list@lists.sourceforge.net>,
        Heinz Graalfs <graalfs@linux.vnet.ibm.com>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 1/2] oprofile, s390: Cleanups
Date: Wed, 16 Mar 2011 18:58:24 +0100
Message-ID: <1300298305-9164-2-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1300298305-9164-1-git-send-email-robert.richter@amd.com>
References: <1300298305-9164-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unused HAVE_HWSAMPLER config option. It is not used anymore,
removing it.

Also make some functions static and some coding style fixes.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/Kconfig              |    3 ---
 arch/s390/Kconfig         |    1 -
 arch/s390/oprofile/init.c |    6 +++---
 3 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 43abf3c..f78c2be 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -30,9 +30,6 @@ config OPROFILE_EVENT_MULTIPLEX
 config HAVE_OPROFILE
 	bool
 
-config HAVE_HWSAMPLER
-	bool
-
 config KPROBES
 	bool "Kprobes"
 	depends on MODULES
diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 0cf20ad..ff19efd 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -115,7 +115,6 @@ config S390
 	select ARCH_INLINE_WRITE_UNLOCK_BH
 	select ARCH_INLINE_WRITE_UNLOCK_IRQ
 	select ARCH_INLINE_WRITE_UNLOCK_IRQRESTORE
-	select HAVE_HWSAMPLER
 
 config SCHED_OMIT_FRAME_POINTER
 	def_bool y
diff --git a/arch/s390/oprofile/init.c b/arch/s390/oprofile/init.c
index 0e38a5b..16c76de 100644
--- a/arch/s390/oprofile/init.c
+++ b/arch/s390/oprofile/init.c
@@ -133,7 +133,7 @@ static int oprofile_create_hwsampling_files(struct super_block *sb,
 	return 0;
 }
 
-int oprofile_hwsampler_init(struct oprofile_operations* ops)
+static int oprofile_hwsampler_init(struct oprofile_operations *ops)
 {
 	if (hwsampler_setup())
 		return -ENODEV;
@@ -166,13 +166,13 @@ int oprofile_hwsampler_init(struct oprofile_operations* ops)
 	return 0;
 }
 
-void oprofile_hwsampler_exit(void)
+static void oprofile_hwsampler_exit(void)
 {
 	oprofile_timer_exit();
 	hwsampler_shutdown();
 }
 
-int __init oprofile_arch_init(struct oprofile_operations* ops)
+int __init oprofile_arch_init(struct oprofile_operations *ops)
 {
 	ops->backtrace = s390_backtrace;
 
-- 
1.7.3.4


