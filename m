Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755214Ab1BIR34 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 12:29:56 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:59730 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754854Ab1BIR3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 12:29:53 -0500
X-SpamScore: -2
X-BigFish: VPS-2(zzbb2cKzz1202hzz8275bhz32i668h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LGD1XN-02-4UL-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Zachary Amsden <zamsden@redhat.com>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 1/6] KVM: SVM: Advance instruction pointer in dr_intercept
Date: Wed, 9 Feb 2011 18:29:39 +0100
Message-ID: <1297272584-22689-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1297272584-22689-1-git-send-email-joerg.roedel@amd.com>
References: <1297272584-22689-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the dr_intercept function a new cpu-feature called
decode-assists is implemented and used when available. This
code-path does not advance the guest-rip causing the guest
to dead-loop over mov-dr instructions. This is fixed by this
patch.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 73a8f1d..bfb4948 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -2777,6 +2777,8 @@ static int dr_interception(struct vcpu_svm *svm)
 			kvm_register_write(&svm->vcpu, reg, val);
 	}
 
+	skip_emulated_instruction(&svm->vcpu);
+
 	return 1;
 }
 
-- 
1.7.1


