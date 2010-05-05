Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934829Ab0EEOFt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 10:05:49 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:14253 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934796Ab0EEOFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 10:05:42 -0400
X-SpamScore: -4
X-BigFish: VPS-4(zz936eMab9bhzz1202hzz6ff19hz32i2a8h87h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L1Y9S1-02-IK7-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 4/5] KVM: SVM: Allow EFER.LMSLE to be set with nested svm
Date: Wed, 5 May 2010 16:04:44 +0200
Message-ID: <1273068285-3105-5-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1273068285-3105-1-git-send-email-joerg.roedel@amd.com>
References: <1273068285-3105-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables setting of efer bit 13 which is allowed
in all SVM capable processors. This is necessary for the
SLES11 version of Xen 4.0 to boot with nested svm.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/msr-index.h |    2 ++
 arch/x86/kvm/svm.c               |    2 +-
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index bc473ac..352767d 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -20,6 +20,7 @@
 #define _EFER_LMA		10 /* Long mode active (read-only) */
 #define _EFER_NX		11 /* No execute enable */
 #define _EFER_SVME		12 /* Enable virtualization */
+#define _EFER_LMSLE		13 /* Long Mode Segment Limit Enable */
 #define _EFER_FFXSR		14 /* Enable Fast FXSAVE/FXRSTOR */
 
 #define EFER_SCE		(1<<_EFER_SCE)
@@ -27,6 +28,7 @@
 #define EFER_LMA		(1<<_EFER_LMA)
 #define EFER_NX			(1<<_EFER_NX)
 #define EFER_SVME		(1<<_EFER_SVME)
+#define EFER_LMSLE		(1<<_EFER_LMSLE)
 #define EFER_FFXSR		(1<<_EFER_FFXSR)
 
 /* Intel MSRs. Some also available on other CPUs */
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 74f7b9d..bc087c7 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -610,7 +610,7 @@ static __init int svm_hardware_setup(void)
 
 	if (nested) {
 		printk(KERN_INFO "kvm: Nested Virtualization enabled\n");
-		kvm_enable_efer_bits(EFER_SVME);
+		kvm_enable_efer_bits(EFER_SVME | EFER_LMSLE);
 	}
 
 	for_each_possible_cpu(cpu) {
-- 
1.7.1


