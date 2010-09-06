Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755216Ab0IFPEx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 11:04:53 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:49630 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754750Ab0IFPCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 11:02:55 -0400
X-SpamScore: 1
X-BigFish: VS1(zzzz1202hzz8275bhz32i87h2a8h)
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L8BZ2Q-02-4X3-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: <"http://kvm.qumranet.com"@osrc.amd.com>, <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 26/27] KVM: SVM: Expect two more candiates for exit_int_info
Date: Mon, 6 Sep 2010 17:02:01 +0200
Message-ID: <1283785322-26898-27-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1283785322-26898-1-git-send-email-joerg.roedel@amd.com>
References: <1283785322-26898-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds INTR and NMI intercepts to the list of
expected intercepts with an exit_int_info set. While this
can't happen on bare metal it is architectural legal and may
happen with KVMs SVM emulation.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 949e10d..932183e 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -2993,7 +2993,8 @@ static int handle_exit(struct kvm_vcpu *vcpu)
 
 	if (is_external_interrupt(svm->vmcb->control.exit_int_info) &&
 	    exit_code != SVM_EXIT_EXCP_BASE + PF_VECTOR &&
-	    exit_code != SVM_EXIT_NPF && exit_code != SVM_EXIT_TASK_SWITCH)
+	    exit_code != SVM_EXIT_NPF && exit_code != SVM_EXIT_TASK_SWITCH &&
+	    exit_code != SVM_EXIT_INTR && exit_code != SVM_EXIT_NMI)
 		printk(KERN_ERR "%s: unexpected exit_ini_info 0x%x "
 		       "exit_code 0x%x\n",
 		       __func__, svm->vmcb->control.exit_int_info,
-- 
1.7.0.4


