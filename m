Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752354Ab0HTIMv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 04:12:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34141 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751332Ab0HTIJC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 04:09:02 -0400
From: Zachary Amsden <zamsden@redhat.com>
To: kvm@vger.kernel.org
Cc: Zachary Amsden <zamsden@redhat.com>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: [KVM timekeeping 24/35] Timer request function renaming
Date: Thu, 19 Aug 2010 22:07:38 -1000
Message-Id: <1282291669-25709-25-git-send-email-zamsden@redhat.com>
In-Reply-To: <1282291669-25709-1-git-send-email-zamsden@redhat.com>
References: <1282291669-25709-1-git-send-email-zamsden@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Separate step to prepare for next change.

Signed-off-by: Zachary Amsden <zamsden@redhat.com>
---
 arch/x86/kvm/x86.c       |   12 ++++++------
 include/linux/kvm_host.h |    2 +-
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d715ec0..ac0b2d9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -838,7 +838,7 @@ static void kvm_write_wall_clock(struct kvm *kvm, gpa_t wall_clock)
 
 	/*
 	 * The guest calculates current wall clock time by adding
-	 * system time (updated by kvm_write_guest_time below) to the
+	 * system time (updated by kvm_guest_time_update below) to the
 	 * wall clock specified here.  guest system time equals host
 	 * system time for us, thus we must fill in host boot time here.
 	 */
@@ -976,7 +976,7 @@ void kvm_write_tsc(struct kvm_vcpu *vcpu, u64 data)
 }
 EXPORT_SYMBOL_GPL(kvm_write_tsc);
 
-static int kvm_write_guest_time(struct kvm_vcpu *v)
+static int kvm_guest_time_update(struct kvm_vcpu *v)
 {
 	unsigned long flags;
 	struct kvm_vcpu_arch *vcpu = &v->arch;
@@ -996,7 +996,7 @@ static int kvm_write_guest_time(struct kvm_vcpu *v)
 	local_irq_restore(flags);
 
 	if (unlikely(this_tsc_khz == 0)) {
-		kvm_make_request(KVM_REQ_KVMCLOCK_UPDATE, v);
+		kvm_make_request(KVM_REQ_CLOCK_UPDATE, v);
 		return 1;
 	}
 
@@ -1071,7 +1071,7 @@ static int kvm_request_guest_time_update(struct kvm_vcpu *v)
 
 	if (!vcpu->time_page)
 		return 0;
-	kvm_make_request(KVM_REQ_KVMCLOCK_UPDATE, v);
+	kvm_make_request(KVM_REQ_CLOCK_UPDATE, v);
 	return 1;
 }
 
@@ -4896,8 +4896,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
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
index c13cc48..b3ede70 100644
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
 
-- 
1.7.1

