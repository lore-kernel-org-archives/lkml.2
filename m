Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753450Ab1CPSFu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 14:05:50 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:34371 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827Ab1CPSFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 14:05:37 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bhz32i668h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LI5WX4-02-AQF-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
        oprofile-list <oprofile-list@lists.sourceforge.net>,
        Heinz Graalfs <graalfs@linux.vnet.ibm.com>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 2/2] oprofile: Add __exit attibute to oprofile_arch_exit() functions
Date: Wed, 16 Mar 2011 18:58:25 +0100
Message-ID: <1300298305-9164-3-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1300298305-9164-1-git-send-email-robert.richter@amd.com>
References: <1300298305-9164-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After

 979048e oprofile: don't call arch exit code from init code on failure

we may add __exit attibutes to oprofile_arch_exit() functions.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/alpha/oprofile/common.c                   |    5 +----
 arch/avr32/oprofile/op_model_avr32.c           |    5 +----
 arch/blackfin/oprofile/bfin_oprofile.c         |    4 +---
 arch/ia64/oprofile/init.c                      |    2 +-
 arch/m32r/oprofile/init.c                      |    4 +---
 arch/microblaze/oprofile/microblaze_oprofile.c |    4 +---
 arch/mips/oprofile/common.c                    |    2 +-
 arch/mn10300/oprofile/op_model_null.c          |    5 +----
 arch/parisc/oprofile/init.c                    |    4 +---
 arch/powerpc/oprofile/common.c                 |    4 +---
 arch/s390/oprofile/init.c                      |    2 +-
 arch/sparc/oprofile/init.c                     |    4 +---
 arch/x86/oprofile/init.c                       |    2 +-
 13 files changed, 13 insertions(+), 34 deletions(-)

diff --git a/arch/alpha/oprofile/common.c b/arch/alpha/oprofile/common.c
index bd8ac53..49b7246 100644
--- a/arch/alpha/oprofile/common.c
+++ b/arch/alpha/oprofile/common.c
@@ -183,7 +183,4 @@ oprofile_arch_init(struct oprofile_operations *ops)
 }
 
 
-void
-oprofile_arch_exit(void)
-{
-}
+void __exit oprofile_arch_exit(void) { }
diff --git a/arch/avr32/oprofile/op_model_avr32.c b/arch/avr32/oprofile/op_model_avr32.c
index a3e9b3c..93feba4 100644
--- a/arch/avr32/oprofile/op_model_avr32.c
+++ b/arch/avr32/oprofile/op_model_avr32.c
@@ -232,7 +232,4 @@ int __init oprofile_arch_init(struct oprofile_operations *ops)
 	return 0;
 }
 
-void oprofile_arch_exit(void)
-{
-
-}
+void __exit oprofile_arch_exit(void) { }
diff --git a/arch/blackfin/oprofile/bfin_oprofile.c b/arch/blackfin/oprofile/bfin_oprofile.c
index c3b9713..7dcac13 100644
--- a/arch/blackfin/oprofile/bfin_oprofile.c
+++ b/arch/blackfin/oprofile/bfin_oprofile.c
@@ -13,6 +13,4 @@ int __init oprofile_arch_init(struct oprofile_operations *ops)
 	return -1;
 }
 
-void oprofile_arch_exit(void)
-{
-}
+void __exit oprofile_arch_exit(void) { }
diff --git a/arch/ia64/oprofile/init.c b/arch/ia64/oprofile/init.c
index 31b545c..a28feac 100644
--- a/arch/ia64/oprofile/init.c
+++ b/arch/ia64/oprofile/init.c
@@ -30,7 +30,7 @@ int __init oprofile_arch_init(struct oprofile_operations *ops)
 }
 
 
-void oprofile_arch_exit(void)
+void __exit oprofile_arch_exit(void)
 {
 #ifdef CONFIG_PERFMON
 	perfmon_exit();
diff --git a/arch/m32r/oprofile/init.c b/arch/m32r/oprofile/init.c
index fa56860..a7e063e 100644
--- a/arch/m32r/oprofile/init.c
+++ b/arch/m32r/oprofile/init.c
@@ -17,6 +17,4 @@ int __init oprofile_arch_init(struct oprofile_operations *ops)
 	return -ENODEV;
 }
 
-void oprofile_arch_exit(void)
-{
-}
+void __exit oprofile_arch_exit(void) { }
diff --git a/arch/microblaze/oprofile/microblaze_oprofile.c b/arch/microblaze/oprofile/microblaze_oprofile.c
index def17e5..23c108d 100644
--- a/arch/microblaze/oprofile/microblaze_oprofile.c
+++ b/arch/microblaze/oprofile/microblaze_oprofile.c
@@ -17,6 +17,4 @@ int __init oprofile_arch_init(struct oprofile_operations *ops)
 	return -1;
 }
 
-void oprofile_arch_exit(void)
-{
-}
+void __exit oprofile_arch_exit(void) { }
diff --git a/arch/mips/oprofile/common.c b/arch/mips/oprofile/common.c
index f9eb1ab..fff011a 100644
--- a/arch/mips/oprofile/common.c
+++ b/arch/mips/oprofile/common.c
@@ -122,7 +122,7 @@ int __init oprofile_arch_init(struct oprofile_operations *ops)
 	return 0;
 }
 
-void oprofile_arch_exit(void)
+void __exit oprofile_arch_exit(void)
 {
 	if (model)
 		model->exit();
diff --git a/arch/mn10300/oprofile/op_model_null.c b/arch/mn10300/oprofile/op_model_null.c
index cd4ab374..d308d13 100644
--- a/arch/mn10300/oprofile/op_model_null.c
+++ b/arch/mn10300/oprofile/op_model_null.c
@@ -16,7 +16,4 @@ int __init oprofile_arch_init(struct oprofile_operations *ops)
 	return -ENODEV;
 }
 
-void oprofile_arch_exit(void)
-{
-}
-
+void __exit oprofile_arch_exit(void) { }
diff --git a/arch/parisc/oprofile/init.c b/arch/parisc/oprofile/init.c
index 026cba2..86cd3a5 100644
--- a/arch/parisc/oprofile/init.c
+++ b/arch/parisc/oprofile/init.c
@@ -18,6 +18,4 @@ int __init oprofile_arch_init(struct oprofile_operations *ops)
 }
 
 
-void oprofile_arch_exit(void)
-{
-}
+void __exit oprofile_arch_exit(void) { }
diff --git a/arch/powerpc/oprofile/common.c b/arch/powerpc/oprofile/common.c
index d65e68f..c090951 100644
--- a/arch/powerpc/oprofile/common.c
+++ b/arch/powerpc/oprofile/common.c
@@ -249,6 +249,4 @@ int __init oprofile_arch_init(struct oprofile_operations *ops)
 	return 0;
 }
 
-void oprofile_arch_exit(void)
-{
-}
+void __exit oprofile_arch_exit(void) { }
diff --git a/arch/s390/oprofile/init.c b/arch/s390/oprofile/init.c
index 16c76de..f4383ab 100644
--- a/arch/s390/oprofile/init.c
+++ b/arch/s390/oprofile/init.c
@@ -179,7 +179,7 @@ int __init oprofile_arch_init(struct oprofile_operations *ops)
 	return oprofile_hwsampler_init(ops);
 }
 
-void oprofile_arch_exit(void)
+void __exit oprofile_arch_exit(void)
 {
 	oprofile_hwsampler_exit();
 }
diff --git a/arch/sparc/oprofile/init.c b/arch/sparc/oprofile/init.c
index f9024bc..315c932 100644
--- a/arch/sparc/oprofile/init.c
+++ b/arch/sparc/oprofile/init.c
@@ -82,6 +82,4 @@ int __init oprofile_arch_init(struct oprofile_operations *ops)
 	return ret;
 }
 
-void oprofile_arch_exit(void)
-{
-}
+void __exit oprofile_arch_exit(void) { }
diff --git a/arch/x86/oprofile/init.c b/arch/x86/oprofile/init.c
index cdfe4c5..085d952 100644
--- a/arch/x86/oprofile/init.c
+++ b/arch/x86/oprofile/init.c
@@ -41,7 +41,7 @@ int __init oprofile_arch_init(struct oprofile_operations *ops)
 }
 
 
-void oprofile_arch_exit(void)
+void __exit oprofile_arch_exit(void)
 {
 #ifdef CONFIG_X86_LOCAL_APIC
 	op_nmi_exit();
-- 
1.7.3.4


