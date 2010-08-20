Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780Ab0HTIQd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 04:16:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44922 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751616Ab0HTIIK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 04:08:10 -0400
From: Zachary Amsden <zamsden@redhat.com>
To: kvm@vger.kernel.org
Cc: Zachary Amsden <zamsden@redhat.com>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: [KVM timekeeping 04/35] Fix SVM VMCB reset
Date: Thu, 19 Aug 2010 22:07:18 -1000
Message-Id: <1282291669-25709-5-git-send-email-zamsden@redhat.com>
In-Reply-To: <1282291669-25709-1-git-send-email-zamsden@redhat.com>
References: <1282291669-25709-1-git-send-email-zamsden@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On reset, VMCB TSC should be set to zero.  Instead, code was setting
tsc_offset to zero, which passes through the underlying TSC.

Signed-off-by: Zachary Amsden <zamsden@redhat.com>
---
 arch/x86/kvm/svm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 8d7ae20..74e4522 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -781,7 +781,7 @@ static void init_vmcb(struct vcpu_svm *svm)
 
 	control->iopm_base_pa = iopm_base;
 	control->msrpm_base_pa = __pa(svm->msrpm);
-	control->tsc_offset = 0;
+	kvm_write_tsc(&svm->vcpu, 0);
 	control->int_ctl = V_INTR_MASKING_MASK;
 
 	init_seg(&save->es);
-- 
1.7.1

