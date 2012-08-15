Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256Ab2HON77 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 09:59:59 -0400
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:54420 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755060Ab2HON6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 09:58:51 -0400
From: Florian Westphal <fw@strlen.de>
To: kvm@vger.kernel.org
Cc: mtosatti@redhat.com, linux-kernel@vger.kernel.org, glommer@redhat.com,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH V2] KVM: x86: disable stealtime on reboot to avoid mem corruption
Date: Wed, 15 Aug 2012 16:00:40 +0200
Message-Id: <1345039240-29959-1-git-send-email-fw@strlen.de>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

else, host continues to update stealtime after reboot,
which can corrupt e.g. initramfs area.
found when tracking down initramfs unpack error on initial reboot
(with qemu-kvm -smp 2, no problem with single-core).

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 arch/x86/kernel/kvm.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

Changes since v1:
- leave arch/x86/kernel/kvmclock.c as-is (requested by Marcelo)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index c1d61ee..1596cc8 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -354,6 +354,7 @@ static void kvm_pv_guest_cpu_reboot(void *unused)
 	if (kvm_para_has_feature(KVM_FEATURE_PV_EOI))
 		wrmsrl(MSR_KVM_PV_EOI_EN, 0);
 	kvm_pv_disable_apf();
+	kvm_disable_steal_time();
 }
 
 static int kvm_pv_reboot_notify(struct notifier_block *nb,
-- 
1.7.8.6

