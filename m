Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759197Ab0EZCrw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 22:47:52 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52271 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1759071Ab0EZCrv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 22:47:51 -0400
Message-ID: <4BFC8B0D.2060106@cn.fujitsu.com>
Date: Wed, 26 May 2010 10:44:29 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Joerg Roedel <joerg.roedel@amd.com>,
       LKML <linux-kernel@vger.kernel.org>, KVM list <kvm@vger.kernel.org>
Subject: [PATCH 1/2] KVM: SVM: fix compiling warning
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix:

arch/x86/kvm/svm.c: In function ‘is_erratum_383’:
arch/x86/kvm/svm.c:1459: warning: integer constant is too large for ‘long’ type
arch/x86/kvm/svm.c: In function ‘svm_handle_mce’:
arch/x86/kvm/svm.c:1490: warning: unused variable ‘kvm_run’

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/svm.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 65324a0..02ea5cf 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1456,7 +1456,7 @@ static bool is_erratum_383(void)
 	/* Bit 62 may or may not be set for this mce */
 	value &= ~(1ULL << 62);
 
-	if (value != 0xb600000000010015)
+	if (value != 0xb600000000010015ULL)
 		return false;
 
 	/* Clear MCi_STATUS registers */
@@ -1487,8 +1487,6 @@ static void svm_handle_mce(struct vcpu_svm *svm)
 		 * Erratum 383 triggered. Guest state is corrupt so kill the
 		 * guest.
 		 */
-		struct kvm_run *kvm_run = svm->vcpu.run;
-
 		pr_err("KVM: Guest triggered AMD Erratum 383\n");
 
 		set_bit(KVM_REQ_TRIPLE_FAULT, &svm->vcpu.requests);
-- 
1.6.1.2

