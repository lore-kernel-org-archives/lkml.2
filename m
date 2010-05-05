Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932868Ab0EEOFF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 10:05:05 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:7439 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755927Ab0EEOFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 10:05:01 -0400
X-SpamScore: -4
X-BigFish: VPS-4(zz936eMab9bhzz1202hzz6ff19hz32i87h2a8h43h62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L1Y9S0-01-1SK-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 5/5] KVM: SVM: Don't allow nested guest to VMMCALL into host
Date: Wed, 5 May 2010 16:04:45 +0200
Message-ID: <1273068285-3105-6-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1273068285-3105-1-git-send-email-joerg.roedel@amd.com>
References: <1273068285-3105-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch disables the possibility for a l2-guest to do a
VMMCALL directly into the host. This would happen if the
l1-hypervisor doesn't intercept VMMCALL and the l2-guest
executes this instruction.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index bc087c7..2e9b57a 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -2036,6 +2036,9 @@ static bool nested_svm_vmrun(struct vcpu_svm *svm)
 		svm->vmcb->control.intercept_cr_write &= ~INTERCEPT_CR8_MASK;
 	}
 
+	/* We don't want to see VMMCALLs from a nested guest */
+	svm->vmcb->control.intercept &= ~(1ULL << INTERCEPT_VMMCALL);
+
 	/*
 	 * We don't want a nested guest to be more powerful than the guest, so
 	 * all intercepts are ORed
-- 
1.7.1


