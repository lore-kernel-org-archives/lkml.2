Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932390Ab0LCKqZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 05:46:25 -0500
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:13223
	"EHLO DB3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757401Ab0LCKqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 05:46:22 -0500
X-SpamScore: -1
X-BigFish: VPS-1(ze80izbb2cKzz1202hzz8275bhz32i691h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LCULWX-02-1EQ-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 04/12] KVM: SVM: Add clean-bit for the ASID
Date: Fri, 3 Dec 2010 11:45:51 +0100
Message-ID: <1291373159-4822-5-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1291373159-4822-1-git-send-email-joerg.roedel@amd.com>
References: <1291373159-4822-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements the clean-bit for the asid in the
vmcb.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 3ab42be..8675048 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -189,6 +189,7 @@ enum {
 	VMCB_INTERCEPTS, /* Intercept vectors, TSC offset,
 			    pause filter count */
 	VMCB_PERM_MAP,   /* IOPM Base and MSRPM Base */
+	VMCB_ASID,	 /* ASID */
 	VMCB_DIRTY_MAX,
 };
 
@@ -1488,6 +1489,8 @@ static void new_asid(struct vcpu_svm *svm, struct svm_cpu_data *sd)
 
 	svm->asid_generation = sd->asid_generation;
 	svm->vmcb->control.asid = sd->next_asid++;
+
+	mark_dirty(svm->vmcb, VMCB_ASID);
 }
 
 static void svm_set_dr7(struct kvm_vcpu *vcpu, unsigned long value)
-- 
1.7.1


