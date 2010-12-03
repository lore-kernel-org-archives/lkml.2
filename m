Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932535Ab0LCKrg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 05:47:36 -0500
Received: from db3ehsobe002.messaging.microsoft.com ([213.199.154.140]:25559
	"EHLO DB3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932368Ab0LCKqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 05:46:25 -0500
X-SpamScore: -2
X-BigFish: VPS-2(zzbb2cKzz1202hzz8275bhz32i691h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LCULWY-02-1EX-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 09/12] KVM: SVM: Add clean-bit for GDT and IDT
Date: Fri, 3 Dec 2010 11:45:56 +0100
Message-ID: <1291373159-4822-10-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1291373159-4822-1-git-send-email-joerg.roedel@amd.com>
References: <1291373159-4822-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements the clean-bit for the base and limit
of the gdt and idt in the vmcb.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 0517505..2236c9a 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -194,6 +194,7 @@ enum {
 	VMCB_NPT,        /* npt_en, nCR3, gPAT */
 	VMCB_CR,	 /* CR0, CR3, CR4, EFER */
 	VMCB_DR,         /* DR6, DR7 */
+	VMCB_DT,         /* GDT, IDT */
 	VMCB_DIRTY_MAX,
 };
 
@@ -1304,6 +1305,7 @@ static void svm_set_idt(struct kvm_vcpu *vcpu, struct desc_ptr *dt)
 
 	svm->vmcb->save.idtr.limit = dt->size;
 	svm->vmcb->save.idtr.base = dt->address ;
+	mark_dirty(svm->vmcb, VMCB_DT);
 }
 
 static void svm_get_gdt(struct kvm_vcpu *vcpu, struct desc_ptr *dt)
@@ -1320,6 +1322,7 @@ static void svm_set_gdt(struct kvm_vcpu *vcpu, struct desc_ptr *dt)
 
 	svm->vmcb->save.gdtr.limit = dt->size;
 	svm->vmcb->save.gdtr.base = dt->address ;
+	mark_dirty(svm->vmcb, VMCB_DT);
 }
 
 static void svm_decache_cr0_guest_bits(struct kvm_vcpu *vcpu)
-- 
1.7.1


