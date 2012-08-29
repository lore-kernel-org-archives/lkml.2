Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791Ab2H2Xc2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 19:32:28 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:35263 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754674Ab2H2Xbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 19:31:39 -0400
From: Mathias Krause <minipli@googlemail.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mathias Krause <minipli@googlemail.com>
Subject: [PATCH 5/8] KVM: x86: constify read_write_emulator_ops
Date: Thu, 30 Aug 2012 01:30:17 +0200
Message-Id: <1346283020-22385-6-git-send-email-minipli@googlemail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1346283020-22385-1-git-send-email-minipli@googlemail.com>
References: <1346283020-22385-1-git-send-email-minipli@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We never change those, make them r/o.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
---
 arch/x86/kvm/x86.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f8b0148..79ac03c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3773,14 +3773,14 @@ static int write_exit_mmio(struct kvm_vcpu *vcpu, gpa_t gpa,
 	return X86EMUL_CONTINUE;
 }
 
-static struct read_write_emulator_ops read_emultor = {
+static const struct read_write_emulator_ops read_emultor = {
 	.read_write_prepare = read_prepare,
 	.read_write_emulate = read_emulate,
 	.read_write_mmio = vcpu_mmio_read,
 	.read_write_exit_mmio = read_exit_mmio,
 };
 
-static struct read_write_emulator_ops write_emultor = {
+static const struct read_write_emulator_ops write_emultor = {
 	.read_write_emulate = write_emulate,
 	.read_write_mmio = write_mmio,
 	.read_write_exit_mmio = write_exit_mmio,
@@ -3791,7 +3791,7 @@ static int emulator_read_write_onepage(unsigned long addr, void *val,
 				       unsigned int bytes,
 				       struct x86_exception *exception,
 				       struct kvm_vcpu *vcpu,
-				       struct read_write_emulator_ops *ops)
+				       const struct read_write_emulator_ops *ops)
 {
 	gpa_t gpa;
 	int handled, ret;
@@ -3840,7 +3840,7 @@ mmio:
 int emulator_read_write(struct x86_emulate_ctxt *ctxt, unsigned long addr,
 			void *val, unsigned int bytes,
 			struct x86_exception *exception,
-			struct read_write_emulator_ops *ops)
+			const struct read_write_emulator_ops *ops)
 {
 	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
 	gpa_t gpa;
-- 
1.7.10.4

