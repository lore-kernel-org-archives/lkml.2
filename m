Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732Ab0HTIP2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 04:15:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21992 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751740Ab0HTIIT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 04:08:19 -0400
From: Zachary Amsden <zamsden@redhat.com>
To: kvm@vger.kernel.org
Cc: Zachary Amsden <zamsden@redhat.com>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: [KVM timekeeping 08/35] Warn about unstable TSC
Date: Thu, 19 Aug 2010 22:07:22 -1000
Message-Id: <1282291669-25709-9-git-send-email-zamsden@redhat.com>
In-Reply-To: <1282291669-25709-1-git-send-email-zamsden@redhat.com>
References: <1282291669-25709-1-git-send-email-zamsden@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If creating an SMP guest with unstable host TSC, issue a warning

Signed-off-by: Zachary Amsden <zamsden@redhat.com>
---
 arch/x86/kvm/x86.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3420f25..5e3b10e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5457,6 +5457,10 @@ void kvm_arch_vcpu_free(struct kvm_vcpu *vcpu)
 struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm,
 						unsigned int id)
 {
+	if (check_tsc_unstable() && atomic_read(&kvm->online_vcpus) != 0)
+		printk_once(KERN_WARNING
+		"kvm: SMP vm created on host with unstable TSC; "
+		"guest TSC will not be reliable\n");
 	return kvm_x86_ops->vcpu_create(kvm, id);
 }
 
-- 
1.7.1

