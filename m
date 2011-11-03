Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933660Ab1KCMg5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 08:36:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33920 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933455Ab1KCMeX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 08:34:23 -0400
From: Gleb Natapov <gleb@redhat.com>
To: kvm@vger.kernel.org
Cc: avi@redhat.com, mtosatti@redhat.com, linux-kernel@vger.kernel.org,
        mingo@elte.hu, a.p.zijlstra@chello.nl, acme@ghostprotocols.net
Subject: [PATCHv2 1/9] KVM: Expose kvm_lapic_local_deliver()
Date: Thu,  3 Nov 2011 14:33:30 +0200
Message-Id: <1320323618-10375-2-git-send-email-gleb@redhat.com>
In-Reply-To: <1320323618-10375-1-git-send-email-gleb@redhat.com>
References: <1320323618-10375-1-git-send-email-gleb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Avi Kivity <avi@redhat.com>

Needed to deliver performance monitoring interrupts.

Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Gleb Natapov <gleb@redhat.com>
---
 arch/x86/kvm/lapic.c |    2 +-
 arch/x86/kvm/lapic.h |    1 +
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 54abb40..e87e43e 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1120,7 +1120,7 @@ int apic_has_pending_timer(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
-static int kvm_apic_local_deliver(struct kvm_lapic *apic, int lvt_type)
+int kvm_apic_local_deliver(struct kvm_lapic *apic, int lvt_type)
 {
 	u32 reg = apic_get_reg(apic, lvt_type);
 	int vector, mode, trig_mode;
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 138e8cc..6f4ce25 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -34,6 +34,7 @@ void kvm_apic_set_version(struct kvm_vcpu *vcpu);
 int kvm_apic_match_physical_addr(struct kvm_lapic *apic, u16 dest);
 int kvm_apic_match_logical_addr(struct kvm_lapic *apic, u8 mda);
 int kvm_apic_set_irq(struct kvm_vcpu *vcpu, struct kvm_lapic_irq *irq);
+int kvm_apic_local_deliver(struct kvm_lapic *apic, int lvt_type);
 
 u64 kvm_get_apic_base(struct kvm_vcpu *vcpu);
 void kvm_set_apic_base(struct kvm_vcpu *vcpu, u64 data);
-- 
1.7.5.3

