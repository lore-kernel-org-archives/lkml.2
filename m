Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913Ab2CHKpc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 05:45:32 -0500
Received: from damascus.uab.es ([158.109.168.135]:42158 "EHLO damascus.uab.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753165Ab2CHKpZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 05:45:25 -0500
X-Greylist: delayed 322 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Mar 2012 05:45:25 EST
Date: Thu, 08 Mar 2012 12:45:54 +0100
From: Davidlohr Bueso <dave@gnu.org>
Subject: [PATCH v2] KVM: x86: add paging gcc optimization
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: KVM <kvm@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
Message-id: <1331207154.28711.2.camel@offworld>
Organization: GNU
MIME-version: 1.0
X-Mailer: Evolution 3.0.3-2
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7BIT
X-Spam-Tests: ALL_TRUSTED=-1
X-imss-version: 2.054
X-imss-result: Passed
X-imss-scanInfo: M:P L:N SM:0
X-imss-tmaseResult: TT:0 TS:0.0000 TC:00 TRN:0 TV:6.5.1024(18760.006)
X-imss-scores: Clean:71.52234 C:2 M:3 S:5 R:5
X-imss-settings: Baseline:3 C:3 M:3 S:3 R:3 (0.5000 0.5000)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davidlohr Bueso <dave@gnu.org>

Since most guests will have paging enabled for memory management, add likely() optimization
around CR0.PG checks.

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
---
 arch/x86/kvm/x86.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index cb80c29..3d1134d 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -64,7 +64,7 @@ static inline int is_pse(struct kvm_vcpu *vcpu)
 
 static inline int is_paging(struct kvm_vcpu *vcpu)
 {
-	return kvm_read_cr0_bits(vcpu, X86_CR0_PG);
+	return likely(kvm_read_cr0_bits(vcpu, X86_CR0_PG));
 }
 
 static inline u32 bit(int bitno)
-- 
1.7.8.3



