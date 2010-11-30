Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755007Ab0K3RFM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 12:05:12 -0500
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:28522
	"EHLO VA3EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754943Ab0K3RFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 12:05:07 -0500
X-SpamScore: -2
X-BigFish: VPS-2(zzbb2cKzz1202hzz8275bhz32i691h668h67dh62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LCPJEX-01-0WY-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 6/6] KVM: SVM: Use get_host_vmcb function in svm_get_msr for TSC
Date: Tue, 30 Nov 2010 18:04:01 +0100
Message-ID: <1291136641-4874-7-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1291136641-4874-1-git-send-email-joerg.roedel@amd.com>
References: <1291136641-4874-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces the open-coded vmcb-selection for the
TSC calculation with the new get_host_vmcb helper function
introduced in this patchset.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |    9 ++-------
 1 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 6b51d31..0803795 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -2628,14 +2628,9 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, unsigned ecx, u64 *data)
 
 	switch (ecx) {
 	case MSR_IA32_TSC: {
-		u64 tsc_offset;
+		struct vmcb *vmcb = get_host_vmcb(svm);
 
-		if (is_guest_mode(vcpu))
-			tsc_offset = svm->nested.hsave->control.tsc_offset;
-		else
-			tsc_offset = svm->vmcb->control.tsc_offset;
-
-		*data = tsc_offset + native_read_tsc();
+		*data = vmcb->control.tsc_offset + native_read_tsc();
 		break;
 	}
 	case MSR_STAR:
-- 
1.7.1


