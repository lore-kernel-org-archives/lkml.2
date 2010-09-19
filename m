Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755691Ab0ISAiq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 20:38:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51721 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754862Ab0ISAiY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 20:38:24 -0400
From: Zachary Amsden <zamsden@redhat.com>
To: kvm@vger.kernel.org
Cc: Zachary Amsden <zamsden@redhat.com>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>, linux-kernel@vger.kernel.org
Subject: [KVM timekeeping fixes 3/4] Rename timer function
Date: Sat, 18 Sep 2010 14:38:14 -1000
Message-Id: <1284856695-19438-3-git-send-email-zamsden@redhat.com>
In-Reply-To: <1284856695-19438-2-git-send-email-zamsden@redhat.com>
References: <1284856695-19438-1-git-send-email-zamsden@redhat.com>
 <1284856695-19438-2-git-send-email-zamsden@redhat.com>
Organization: Frobozz Magic Timekeeping Company
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This just changes some names to better reflect the usage they
will be given.  Separated out to keep confusion to a minimum.

Signed-off-by: Zachary Amsden <zamsden@redhat.com>
---
 arch/x86/kvm/x86.c       |   12 ++++++------
 include/linux/kvm_host.h |    2 +-
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f92401f..09f468a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -892,7 +892,7 @@ static void kvm_write_wall_clock(struct kvm *kvm, gpa_t wall_clock)
 
 	/*
 	 * The guest calculates current wall clock time by adding
-	 * system time (updated by kvm_write_guest_time below) to the
+	 * system time (updated by kvm_guest_time_update below) to the
 	 * wall clock specified here.  guest system time equals host
 	 * system time for us, thus we must fill in host boot time here.
 	 */
@@ -1032,7 +1032,7 @@ void kvm_write_tsc(struct kvm_vcpu *vcpu, u64 data)
 }
 EXPORT_SYMBOL_GPL(kvm_write_tsc);
 
-static int kvm_write_guest_time(struct kvm_vcpu *v)
+static int kvm_guest_time_update(struct kvm_vcpu *v)
 {
 	unsigned long flags;
 	struct kvm_vcpu_arch *vcpu = &v->arch;
@@ -1052,7 +1052,7 @@ static int kvm_write_guest_time(struct kvm_vcpu *v)
 	local_irq_restore(flags);
 
 	if (unlikely(this_tsc_khz == 0)) {
-		kvm_make_request(KVM_REQ_KVMCLOCK_UPDATE, v);
+		kvm_make_request(KVM_REQ_CLOCK_UPDATE, v);
 		return 1;
 	}
 
@@ -1128,7 +1128,7 @@ static int kvm_request_guest_time_update(struct kvm_vcpu *v)
 
 	if (!vcpu->time_page)
 		return 0;
-	kvm_make_request(KVM_REQ_KVMCLOCK_UPDATE, v);
+	kvm_make_request(KVM_REQ_CLOCK_UPDATE, v);
 	return 1;
 }
 
@@ -5012,8 +5012,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 			kvm_mmu_unload(vcpu);
 		if (kvm_check_request(KVM_REQ_MIGRATE_TIMER, vcpu))
 			__kvm_migrate_timers(vcpu);
-		if (kvm_check_request(KVM_REQ_KVMCLOCK_UPDATE, vcpu)) {
-			r = kvm_write_guest_time(vcpu);
+		if (kvm_check_request(KVM_REQ_CLOCK_UPDATE, vcpu)) {
+			r = kvm_guest_time_update(vcpu);
 			if (unlikely(r))
 				goto out;
 		}
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 6022da1..0b89d00 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -36,7 +36,7 @@
 #define KVM_REQ_PENDING_TIMER      5
 #define KVM_REQ_UNHALT             6
 #define KVM_REQ_MMU_SYNC           7
-#define KVM_REQ_KVMCLOCK_UPDATE    8
+#define KVM_REQ_CLOCK_UPDATE       8
 #define KVM_REQ_KICK               9
 #define KVM_REQ_DEACTIVATE_FPU    10
 #define KVM_REQ_EVENT             11
-- 
1.6.6.1

