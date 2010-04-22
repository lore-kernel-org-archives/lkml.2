Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969Ab0DVKdq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 06:33:46 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:19432
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753875Ab0DVKdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 06:33:42 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzab9bhzz1202hzzz32i2a8h87h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L19XBP-02-0SI-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 8/8] KVM: SVM: Handle MCE intercepts always on host level
Date: Thu, 22 Apr 2010 12:33:14 +0200
Message-ID: <1271932394-13968-9-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1271932394-13968-1-git-send-email-joerg.roedel@amd.com>
References: <1271932394-13968-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 22 Apr 2010 10:33:19.0215 (UTC) FILETIME=[39944FF0:01CAE207]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch prevents MCE intercepts from being propagated
into the L1 guest if they happened in an L2 guest.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 30e49fe..889f660 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1651,6 +1651,7 @@ static int nested_svm_exit_special(struct vcpu_svm *svm)
 	switch (exit_code) {
 	case SVM_EXIT_INTR:
 	case SVM_EXIT_NMI:
+	case SVM_EXIT_EXCP_BASE + MC_VECTOR:
 		return NESTED_EXIT_HOST;
 	case SVM_EXIT_NPF:
 		/* For now we are always handling NPFs when using them */
-- 
1.7.0.4


