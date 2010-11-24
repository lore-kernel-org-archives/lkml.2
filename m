Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470Ab0KXSSo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 13:18:44 -0500
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:41949 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757Ab0KXSSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 13:18:42 -0500
X-SpamScore: -2
X-BigFish: VPS-2(zzbb2cKzz1202hzz8275bhz32i691h668h67dh685h)
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LCEIUY-02-3OC-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 3/9] KVM: SVM: Add checks for DRx read and write intercepts
Date: Wed, 24 Nov 2010 19:18:29 +0100
Message-ID: <1290622715-8382-4-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1290622715-8382-1-git-send-email-joerg.roedel@amd.com>
References: <1290622715-8382-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds checking for read and write intercepts
from/to DRx registers from the KVM instruction emulator
path.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 29f0491..16ff569 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -3669,6 +3669,9 @@ static int svm_insn_intercepted(struct kvm_vcpu *vcpu,
 	case 0x20: /* CR read  */
 		vmcb->control.exit_code = SVM_EXIT_READ_CR0 + c->modrm_reg;
 		break;
+	case 0x21:
+		vmcb->control.exit_code = SVM_EXIT_READ_DR0 + c->modrm_reg;
+		break;
 	case 0x22: /* CR write */
 		vmcb->control.exit_code = SVM_EXIT_WRITE_CR0 + c->modrm_reg;
 		if (c->modrm_reg == 0 &&
@@ -3683,6 +3686,9 @@ static int svm_insn_intercepted(struct kvm_vcpu *vcpu,
 				vmcb->control.exit_code = SVM_EXIT_CR0_SEL_WRITE;
 		}
 		break;
+	case 0x23:
+		vmcb->control.exit_code = SVM_EXIT_WRITE_DR0 + c->modrm_reg;
+		break;
 	}
 
 	vmcb->control.next_rip = ctxt->eip;
-- 
1.7.1


