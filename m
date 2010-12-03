Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932528Ab0LCKs2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 05:48:28 -0500
Received: from db3ehsobe002.messaging.microsoft.com ([213.199.154.140]:25559
	"EHLO DB3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932306Ab0LCKqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 05:46:24 -0500
X-SpamScore: -2
X-BigFish: VPS-2(zzbb2cKzz1202hzz8275bhz32i691h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LCULWY-02-1EU-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 08/12] KVM: SVM: Add clean-bit for DR6 and DR7
Date: Fri, 3 Dec 2010 11:45:55 +0100
Message-ID: <1291373159-4822-9-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1291373159-4822-1-git-send-email-joerg.roedel@amd.com>
References: <1291373159-4822-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements the clean-bit for the dr6 and dr7
debug registers in the vmcb.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 1b35969..0517505 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -193,6 +193,7 @@ enum {
 	VMCB_INTR,	 /* int_ctl, int_vector */
 	VMCB_NPT,        /* npt_en, nCR3, gPAT */
 	VMCB_CR,	 /* CR0, CR3, CR4, EFER */
+	VMCB_DR,         /* DR6, DR7 */
 	VMCB_DIRTY_MAX,
 };
 
@@ -1484,6 +1485,8 @@ static void svm_guest_debug(struct kvm_vcpu *vcpu, struct kvm_guest_debug *dbg)
 	else
 		svm->vmcb->save.dr7 = vcpu->arch.dr7;
 
+	mark_dirty(svm->vmcb, VMCB_DR);
+
 	update_db_intercept(vcpu);
 }
 
@@ -1506,6 +1509,7 @@ static void svm_set_dr7(struct kvm_vcpu *vcpu, unsigned long value)
 	struct vcpu_svm *svm = to_svm(vcpu);
 
 	svm->vmcb->save.dr7 = value;
+	mark_dirty(svm->vmcb, VMCB_DR);
 }
 
 static int pf_interception(struct vcpu_svm *svm)
-- 
1.7.1


