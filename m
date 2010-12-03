Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932505Ab0LCKrd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 05:47:33 -0500
Received: from db3ehsobe004.messaging.microsoft.com ([213.199.154.142]:24355
	"EHLO DB3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932379Ab0LCKq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 05:46:26 -0500
X-SpamScore: -2
X-BigFish: VPS-2(zzbb2cKzz1202hzz8275bhz32i691h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LCULX0-01-H0B-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 10/12] KVM: SVM: Add clean-bit for Segements and CPL
Date: Fri, 3 Dec 2010 11:45:57 +0100
Message-ID: <1291373159-4822-11-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1291373159-4822-1-git-send-email-joerg.roedel@amd.com>
References: <1291373159-4822-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements the clean-bit defined for the cs, ds,
ss, an es segemnts and the current cpl saved in the vmcb.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 2236c9a..4c366fe 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -195,6 +195,7 @@ enum {
 	VMCB_CR,	 /* CR0, CR3, CR4, EFER */
 	VMCB_DR,         /* DR6, DR7 */
 	VMCB_DT,         /* GDT, IDT */
+	VMCB_SEG,        /* CS, DS, SS, ES, CPL */
 	VMCB_DIRTY_MAX,
 };
 
@@ -1457,6 +1458,7 @@ static void svm_set_segment(struct kvm_vcpu *vcpu,
 			= (svm->vmcb->save.cs.attrib
 			   >> SVM_SELECTOR_DPL_SHIFT) & 3;
 
+	mark_dirty(svm->vmcb, VMCB_SEG);
 }
 
 static void update_db_intercept(struct kvm_vcpu *vcpu)
-- 
1.7.1


