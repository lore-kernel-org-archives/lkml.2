Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753685Ab0DVKde (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 06:33:34 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:39641 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753401Ab0DVKda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 06:33:30 -0400
X-SpamScore: 11
X-BigFish: VPS11(zzab9bh9321rzz1202hzzz32i2a8h87h43h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L19XBM-01-036-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 4/8] KVM: SVM: Propagate nested entry failure into guest hypervisor
Date: Thu, 22 Apr 2010 12:33:10 +0200
Message-ID: <1271932394-13968-5-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1271932394-13968-1-git-send-email-joerg.roedel@amd.com>
References: <1271932394-13968-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 22 Apr 2010 10:33:19.0044 (UTC) FILETIME=[397A3840:01CAE207]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements propagation of a failes guest vmrun
back into the guest instead of killing the whole guest.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 5ad9d80..b10d163 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1715,6 +1715,10 @@ static int nested_svm_intercept(struct vcpu_svm *svm)
 			vmexit = NESTED_EXIT_DONE;
 		break;
 	}
+	case SVM_EXIT_ERR: {
+		vmexit = NESTED_EXIT_DONE;
+		break;
+	}
 	default: {
 		u64 exit_bits = 1ULL << (exit_code - SVM_EXIT_INTR);
 		if (svm->nested.intercept & exit_bits)
-- 
1.7.0.4


