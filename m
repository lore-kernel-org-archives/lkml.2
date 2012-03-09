Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759365Ab2CIEmz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 23:42:55 -0500
Received: from ozlabs.org ([203.10.76.45]:46282 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758217Ab2CIEmD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 23:42:03 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
CC: linux-kernel@vger.kernel.org
To: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Message-ID: <1331267212.6033.rusty@rustcorp.com.au>
Date: Fri, 09 Mar 2012 14:56:52 +1030
Subject: [PATCH 8/8] ARM: KVM: don't BUG() if guest executes smc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Rusty Russell <rusty@rustcorp.com.au>

In this case, we just kill the guest.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 arch/arm/kvm/arm.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index 1724657..9ef5bdb 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -367,6 +367,13 @@ static int handle_hvc(struct kvm_vcpu *vcpu, struct kvm_run *run)
 	return 0;
 }
 
+static int handle_smc(struct kvm_vcpu *vcpu, struct kvm_run *run)
+{
+	/* We don't support SMC; don't do that. */
+	kvm_debug("smc: at %08x", vcpu->arch.regs.pc);
+	return -EINVAL;
+}
+
 static int handle_dabt_hyp(struct kvm_vcpu *vcpu, struct kvm_run *run)
 {
 	/* The hypervisor should never cause aborts */
@@ -386,6 +393,7 @@ static int (*arm_exit_handlers[])(struct kvm_vcpu *vcpu, struct kvm_run *r) = {
 	[HSR_EC_CP10_ID]	= kvm_handle_cp10_id,
 	[HSR_EC_SVC_HYP]	= handle_svc_hyp,
 	[HSR_EC_HVC]		= handle_hvc,
+	[HSR_EC_SMC	]	= handle_smc,
 	[HSR_EC_IABT]		= kvm_handle_guest_abort,
 	[HSR_EC_DABT]		= kvm_handle_guest_abort,
 	[HSR_EC_DABT_HYP]	= handle_dabt_hyp,

