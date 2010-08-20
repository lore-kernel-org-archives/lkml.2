Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752265Ab0HTIJK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 04:09:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38435 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751896Ab0HTII4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 04:08:56 -0400
From: Zachary Amsden <zamsden@redhat.com>
To: kvm@vger.kernel.org
Cc: Zachary Amsden <zamsden@redhat.com>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: [KVM timekeeping 22/35] Track tsc last write in vcpu
Date: Thu, 19 Aug 2010 22:07:36 -1000
Message-Id: <1282291669-25709-23-git-send-email-zamsden@redhat.com>
In-Reply-To: <1282291669-25709-1-git-send-email-zamsden@redhat.com>
References: <1282291669-25709-1-git-send-email-zamsden@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reason becomes apparent soon; this is an easy to digest step.

Signed-off-by: Zachary Amsden <zamsden@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |    2 ++
 arch/x86/kvm/x86.c              |    2 ++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 871800d..638cae5 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -341,6 +341,8 @@ struct kvm_vcpu_arch {
 	u64 last_host_tsc;
 	u64 last_guest_tsc;
 	u64 last_kernel_ns;
+	u64 last_tsc_nsec;
+	u64 last_tsc_write;
 
 	bool nmi_pending;
 	bool nmi_injected;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 517daf3..3691e70 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -962,6 +962,8 @@ void kvm_write_tsc(struct kvm_vcpu *vcpu, u64 data)
 
 	/* Reset of TSC must disable overshoot protection below */
 	vcpu->arch.hv_clock.tsc_timestamp = 0;
+	vcpu->arch.last_tsc_write = data;
+	vcpu->arch.last_tsc_nsec = ns;
 }
 EXPORT_SYMBOL_GPL(kvm_write_tsc);
 
-- 
1.7.1

