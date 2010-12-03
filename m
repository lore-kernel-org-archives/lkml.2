Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758561Ab0LCOZg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 09:25:36 -0500
Received: from db3ehsobe002.messaging.microsoft.com ([213.199.154.140]:36613
	"EHLO DB3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758398Ab0LCOZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 09:25:34 -0500
X-SpamScore: -2
X-BigFish: VPS-2(zzbb2cKzz1202hzz8275bhz32i691h668h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LCUW29-01-7U2-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 1/3] KVM: SVM: Remove flush_guest_tlb function
Date: Fri, 3 Dec 2010 15:25:14 +0100
Message-ID: <1291386316-6885-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1291386316-6885-1-git-send-email-joerg.roedel@amd.com>
References: <1291386316-6885-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function is unused and there is svm_flush_tlb which
does the same. So this function can be removed.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index c00ea90..772d48e 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -389,11 +389,6 @@ static inline void force_new_asid(struct kvm_vcpu *vcpu)
 	to_svm(vcpu)->asid_generation--;
 }
 
-static inline void flush_guest_tlb(struct kvm_vcpu *vcpu)
-{
-	force_new_asid(vcpu);
-}
-
 static int get_npt_level(void)
 {
 #ifdef CONFIG_X86_64
-- 
1.7.1


