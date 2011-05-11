Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055Ab1EKPzy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 11:55:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42004 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756008Ab1EKPzv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 11:55:51 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH v1 4/5] KVM: Expose kvm_lapic_local_deliver()
Date: Wed, 11 May 2011 11:55:32 -0400
Message-Id: <1305129333-7456-5-git-send-email-avi@redhat.com>
In-Reply-To: <1305129333-7456-1-git-send-email-avi@redhat.com>
References: <1305129333-7456-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Needed to deliver performance monitoring interrupts.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/lapic.c |    2 +-
 arch/x86/kvm/lapic.h |    1 +
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 2b2255b..79d4850 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1017,7 +1017,7 @@ int apic_has_pending_timer(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
-static int kvm_apic_local_deliver(struct kvm_lapic *apic, int lvt_type)
+int kvm_apic_local_deliver(struct kvm_lapic *apic, int lvt_type)
 {
 	u32 reg = apic_get_reg(apic, lvt_type);
 	int vector, mode, trig_mode;
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 52c9e6b..09dbe2f 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -33,6 +33,7 @@ void kvm_apic_set_version(struct kvm_vcpu *vcpu);
 int kvm_apic_match_physical_addr(struct kvm_lapic *apic, u16 dest);
 int kvm_apic_match_logical_addr(struct kvm_lapic *apic, u8 mda);
 int kvm_apic_set_irq(struct kvm_vcpu *vcpu, struct kvm_lapic_irq *irq);
+int kvm_apic_local_deliver(struct kvm_lapic *apic, int lvt_type);
 
 u64 kvm_get_apic_base(struct kvm_vcpu *vcpu);
 void kvm_set_apic_base(struct kvm_vcpu *vcpu, u64 data);
-- 
1.7.4.3

