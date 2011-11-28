Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753928Ab1K1Ml6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 07:41:58 -0500
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:54582 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395Ab1K1Ml4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 07:41:56 -0500
Message-ID: <4ED38182.6070505@linux.vnet.ibm.com>
Date: Mon, 28 Nov 2011 20:41:38 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH 3/5] KVM: x86: remove the dead code of KVM_EXIT_HYPERCALL
References: <4ED3811F.1070101@linux.vnet.ibm.com>
In-Reply-To: <4ED3811F.1070101@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 11112802-5490-0000-0000-000000369DF4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KVM_EXIT_HYPERCALL is not used anymore, so remove the code

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/x86.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d54746c..7b6fd72 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5386,10 +5386,6 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	if (r <= 0)
 		goto out;

-	if (kvm_run->exit_reason == KVM_EXIT_HYPERCALL)
-		kvm_register_write(vcpu, VCPU_REGS_RAX,
-				     kvm_run->hypercall.ret);
-
 	r = __vcpu_run(vcpu);

 out:
-- 
1.7.7.3

