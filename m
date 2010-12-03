Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932446Ab0LCKq2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 05:46:28 -0500
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:13223
	"EHLO DB3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758423Ab0LCKqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 05:46:23 -0500
X-SpamScore: -2
X-BigFish: VPS-2(zzbb2cKzz1202hzz8275bhz32i691h668h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LCULWY-02-1EW-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 12/12] KVM: SVM: Add clean-bit for LBR state
Date: Fri, 3 Dec 2010 11:45:59 +0100
Message-ID: <1291373159-4822-13-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1291373159-4822-1-git-send-email-joerg.roedel@amd.com>
References: <1291373159-4822-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements the clean-bit for all LBR related
state. This includes the debugctl, br_from, br_to,
last_excp_from, and last_excp_to msrs.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 7643f83..8966669 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -197,6 +197,7 @@ enum {
 	VMCB_DT,         /* GDT, IDT */
 	VMCB_SEG,        /* CS, DS, SS, ES, CPL */
 	VMCB_CR2,        /* CR2 only */
+	VMCB_LBR,        /* DBGCTL, BR_FROM, BR_TO, LAST_EX_FROM, LAST_EX_TO */
 	VMCB_DIRTY_MAX,
 };
 
@@ -2846,6 +2847,7 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, unsigned ecx, u64 data)
 			return 1;
 
 		svm->vmcb->save.dbgctl = data;
+		mark_dirty(svm->vmcb, VMCB_LBR);
 		if (data & (1ULL<<0))
 			svm_enable_lbrv(svm);
 		else
-- 
1.7.1


