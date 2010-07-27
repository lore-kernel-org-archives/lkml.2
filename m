Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751589Ab0G0QPS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 12:15:18 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:11666 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916Ab0G0QPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 12:15:11 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzzz32i2a8h87h43h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L684ZS-01-2BK-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 2/2] KVM: SVM: Emulate next_rip svm feature
Date: Tue, 27 Jul 2010 18:14:21 +0200
Message-ID: <1280247261-19115-3-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1280247261-19115-1-git-send-email-joerg.roedel@amd.com>
References: <1280247261-19115-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements the emulations of the svm next_rip
feature in the nested svm implementation in kvm.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 7d10f2c..b44c9cc 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1919,6 +1919,7 @@ static int nested_svm_vmexit(struct vcpu_svm *svm)
 	nested_vmcb->control.exit_info_2       = vmcb->control.exit_info_2;
 	nested_vmcb->control.exit_int_info     = vmcb->control.exit_int_info;
 	nested_vmcb->control.exit_int_info_err = vmcb->control.exit_int_info_err;
+	nested_vmcb->control.next_rip          = vmcb->control.next_rip;
 
 	/*
 	 * If we emulate a VMRUN/#VMEXIT in the same host #vmexit cycle we have
@@ -3356,7 +3357,12 @@ static void svm_set_supported_cpuid(u32 func, struct kvm_cpuid_entry2 *entry)
 		entry->ebx = 8; /* Lets support 8 ASIDs in case we add proper
 				   ASID emulation to nested SVM */
 		entry->ecx = 0; /* Reserved */
-		entry->edx = 0; /* Do not support any additional features */
+		entry->edx = 0; /* Per default do not support any
+				   additional features */
+
+		/* Support next_rip if host supports it */
+		if (svm_has(SVM_FEATURE_NRIP))
+			entry->edx |= SVM_FEATURE_NRIP;
 
 		break;
 	}
-- 
1.7.0.4


