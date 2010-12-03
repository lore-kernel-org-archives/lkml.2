Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932522Ab0LCKrf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 05:47:35 -0500
Received: from db3ehsobe002.messaging.microsoft.com ([213.199.154.140]:25559
	"EHLO DB3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932396Ab0LCKq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 05:46:26 -0500
X-SpamScore: -2
X-BigFish: VPS-2(zzbb2cKzz1202hzz8275bhz32i691h668h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LCULWY-02-1EV-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 06/12] KVM: SVM: Add clean-bit for NPT state
Date: Fri, 3 Dec 2010 11:45:53 +0100
Message-ID: <1291373159-4822-7-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1291373159-4822-1-git-send-email-joerg.roedel@amd.com>
References: <1291373159-4822-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements the clean-bit for all nested paging
related state in the vmcb.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index b81d31a..3b5d894 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -191,6 +191,7 @@ enum {
 	VMCB_PERM_MAP,   /* IOPM Base and MSRPM Base */
 	VMCB_ASID,	 /* ASID */
 	VMCB_INTR,	 /* int_ctl, int_vector */
+	VMCB_NPT,        /* npt_en, nCR3, gPAT */
 	VMCB_DIRTY_MAX,
 };
 
@@ -1749,6 +1750,7 @@ static void nested_svm_set_tdp_cr3(struct kvm_vcpu *vcpu,
 	struct vcpu_svm *svm = to_svm(vcpu);
 
 	svm->vmcb->control.nested_cr3 = root;
+	mark_dirty(svm->vmcb, VMCB_NPT);
 	force_new_asid(vcpu);
 }
 
@@ -3552,6 +3554,7 @@ static void set_tdp_cr3(struct kvm_vcpu *vcpu, unsigned long root)
 	struct vcpu_svm *svm = to_svm(vcpu);
 
 	svm->vmcb->control.nested_cr3 = root;
+	mark_dirty(svm->vmcb, VMCB_NPT);
 
 	/* Also sync guest cr3 here in case we live migrate */
 	svm->vmcb->save.cr3 = vcpu->arch.cr3;
-- 
1.7.1


