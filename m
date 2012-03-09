Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758377Ab2CIEmG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 23:42:06 -0500
Received: from ozlabs.org ([203.10.76.45]:45616 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757955Ab2CIEmB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 23:42:01 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
CC: linux-kernel@vger.kernel.org
To: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Message-ID: <1331267212.32474.rusty@rustcorp.com.au>
Date: Fri, 09 Mar 2012 14:56:52 +1030
Subject: [PATCH 3/8] ARM: KVM: make struct coproc_params arg const.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Rusty Russell <rusty@rustcorp.com.au>

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 arch/arm/kvm/emulate.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm/kvm/emulate.c b/arch/arm/kvm/emulate.c
index 108db38..87a1141 100644
--- a/arch/arm/kvm/emulate.c
+++ b/arch/arm/kvm/emulate.c
@@ -165,7 +165,7 @@ struct coproc_params {
 	bool is_write;
 };
 
-static void cp15_op(struct kvm_vcpu *vcpu, struct coproc_params *p,
+static void cp15_op(struct kvm_vcpu *vcpu, const struct coproc_params *p,
 			   enum cp15_regs cp15_reg)
 {
 	if (p->is_write)
@@ -174,7 +174,7 @@ static void cp15_op(struct kvm_vcpu *vcpu, struct coproc_params *p,
 		*vcpu_reg(vcpu, p->Rt1) = vcpu->arch.cp15[cp15_reg];
 }
 
-static void print_cp_instr(struct coproc_params *p)
+static void print_cp_instr(const struct coproc_params *p)
 {
 	if (p->is_64bit) {
 		kvm_debug("%s\tp15, %lu, r%lu, r%lu, c%lu",
@@ -213,7 +213,7 @@ int kvm_handle_cp14_access(struct kvm_vcpu *vcpu, struct kvm_run *run)
  * @p:    The coprocessor parameters struct pointer holding trap inst. details
  */
 static int emulate_cp15_c9_access(struct kvm_vcpu *vcpu,
-				  struct coproc_params *p)
+				  const struct coproc_params *p)
 {
 	BUG_ON(p->CRn != 9);
 	BUG_ON(p->is_64bit);
@@ -251,7 +251,7 @@ static int emulate_cp15_c9_access(struct kvm_vcpu *vcpu,
  * to these registers.
  */
 static int emulate_cp15_c10_access(struct kvm_vcpu *vcpu,
-				   struct coproc_params *p)
+				   const struct coproc_params *p)
 {
 	BUG_ON(p->CRn != 10);
 	BUG_ON(p->is_64bit);
@@ -293,7 +293,7 @@ static int emulate_cp15_c10_access(struct kvm_vcpu *vcpu,
  * This may need to be refined.
  */
 static int emulate_cp15_c15_access(struct kvm_vcpu *vcpu,
-				   struct coproc_params *p)
+				   const struct coproc_params *p)
 {
 	trace_kvm_emulate_cp15_imp(p->Op1, p->Rt1, p->CRn, p->CRm,
 				   p->Op2, p->is_write);

