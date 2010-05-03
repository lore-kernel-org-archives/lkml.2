Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759648Ab0ECPyD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 11:54:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4228 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759605Ab0ECPx4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 11:53:56 -0400
From: Glauber Costa <glommer@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, avi@redhat.com, zamsden@redhat.com
Subject: [PATCH v2 7/7] Tell the guest we'll warn it about tsc stability
Date: Mon,  3 May 2010 11:52:07 -0400
Message-Id: <1272901927-829-8-git-send-email-glommer@redhat.com>
In-Reply-To: <1272901927-829-7-git-send-email-glommer@redhat.com>
References: <1272901927-829-1-git-send-email-glommer@redhat.com>
 <1272901927-829-2-git-send-email-glommer@redhat.com>
 <1272901927-829-3-git-send-email-glommer@redhat.com>
 <1272901927-829-4-git-send-email-glommer@redhat.com>
 <1272901927-829-5-git-send-email-glommer@redhat.com>
 <1272901927-829-6-git-send-email-glommer@redhat.com>
 <1272901927-829-7-git-send-email-glommer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch puts up the flag that tells the guest that we'll warn it
about the tsc being trustworthy or not. By now, we also say
it is not.
---
 arch/x86/kvm/x86.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8a7cdda..63a2acc 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -855,6 +855,8 @@ static void kvm_write_guest_time(struct kvm_vcpu *v)
 	vcpu->hv_clock.system_time = ts.tv_nsec +
 				     (NSEC_PER_SEC * (u64)ts.tv_sec) + v->kvm->arch.kvmclock_offset;
 
+	vcpu->hv_clock.flags = 0;
+
 	/*
 	 * The interface expects us to write an even number signaling that the
 	 * update is finished. Since the guest won't see the intermediate
@@ -1983,7 +1985,8 @@ static void do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 	case 0x40000001:
 		entry->eax = (1 << KVM_FEATURE_CLOCKSOURCE) |
 		(1 << KVM_FEATURE_NOP_IO_DELAY) |
-		(1 << KVM_FEATURE_CLOCKSOURCE2);
+		(1 << KVM_FEATURE_CLOCKSOURCE2) |
+		(1 << KVM_FEATURE_CLOCKSOURCE_STABLE_TSC);
 		break;
 	case 0x80000000:
 		entry->eax = min(entry->eax, 0x8000001a);
-- 
1.6.2.2

