Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751357Ab0G0QPO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 12:15:14 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:56987 "EHLO
	TX2EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741Ab0G0QPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 12:15:11 -0400
X-SpamScore: 7
X-BigFish: VPS7(z41cfnzzz1202hzzz32i87h2a8h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L684ZQ-02-JAF-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 1/2] KVM: SVM: Sync efer back into nested vmcb
Date: Tue, 27 Jul 2010 18:14:20 +0200
Message-ID: <1280247261-19115-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1280247261-19115-1-git-send-email-joerg.roedel@amd.com>
References: <1280247261-19115-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a bug in a nested hypervisor that heavily
switches between real-mode and long-mode. The problem is
fixed by syncing back efer into the guest vmcb on emulated
vmexit.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 56c9b6b..7d10f2c 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1897,6 +1897,7 @@ static int nested_svm_vmexit(struct vcpu_svm *svm)
 	nested_vmcb->save.ds     = vmcb->save.ds;
 	nested_vmcb->save.gdtr   = vmcb->save.gdtr;
 	nested_vmcb->save.idtr   = vmcb->save.idtr;
+	nested_vmcb->save.efer   = svm->vcpu.arch.efer;
 	nested_vmcb->save.cr0    = kvm_read_cr0(&svm->vcpu);
 	nested_vmcb->save.cr3    = svm->vcpu.arch.cr3;
 	nested_vmcb->save.cr2    = vmcb->save.cr2;
-- 
1.7.0.4


