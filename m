Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756526Ab2CHKMa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 05:12:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46295 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756386Ab2CHKM1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 05:12:27 -0500
Subject: [PATCH] kvm: svm: count all irq windows exit
To: joerg.roedel@amd.com, mtosatti@redhat.com, avi@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
From: Jason Wang <jasowang@redhat.com>
Date: Thu, 08 Mar 2012 18:07:56 +0800
Message-ID: <20120308100756.3984.25343.stgit@amd-6168-8-1.englab.nay.redhat.com>
User-Agent: StGit/0.16-1-g60c4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also count the exits of fast-path.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 arch/x86/kvm/svm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 53efd59..5ef7233 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -3235,6 +3235,7 @@ static int interrupt_window_interception(struct vcpu_svm *svm)
 	svm_clear_vintr(svm);
 	svm->vmcb->control.int_ctl &= ~V_IRQ_MASK;
 	mark_dirty(svm->vmcb, VMCB_INTR);
+	++svm->vcpu.stat.irq_window_exits;
 	/*
 	 * If the user space waits to inject interrupts, exit as soon as
 	 * possible
@@ -3242,7 +3243,6 @@ static int interrupt_window_interception(struct vcpu_svm *svm)
 	if (!irqchip_in_kernel(svm->vcpu.kvm) &&
 	    kvm_run->request_interrupt_window &&
 	    !kvm_cpu_has_interrupt(&svm->vcpu)) {
-		++svm->vcpu.stat.irq_window_exits;
 		kvm_run->exit_reason = KVM_EXIT_IRQ_WINDOW_OPEN;
 		return 0;
 	}

