Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756634Ab0GMCJI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 22:09:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51923 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754728Ab0GMCJC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 22:09:02 -0400
From: Zachary Amsden <zamsden@redhat.com>
To: KVM <kvm@vger.kernel.org>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>
Cc: Linux-kernel <linux-kernel@vger.kernel.org>,
        Zachary Amsden <zamsden@redhat.com>
Subject: [PATCH 06/18] Warn about unstable TSC
Date: Mon, 12 Jul 2010 16:08:00 -1000
Message-Id: <1278986892-11733-7-git-send-email-zamsden@redhat.com>
In-Reply-To: <1278986892-11733-1-git-send-email-zamsden@redhat.com>
References: <1278986892-11733-1-git-send-email-zamsden@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If creating an SMP guest with unstable host TSC, issue a warning

Signed-off-by: Zachary Amsden <zamsden@redhat.com>
---
 arch/x86/kvm/x86.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 273dd7d..045b2d6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5458,6 +5458,10 @@ void kvm_arch_vcpu_free(struct kvm_vcpu *vcpu)
 struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm,
 						unsigned int id)
 {
+	if (check_tsc_unstable() && id != 0)
+		printk_once(KERN_WARNING
+		"kvm: SMP vm created on host with unstable TSC; "
+		"guest TSC will not be reliable\n");
 	return kvm_x86_ops->vcpu_create(kvm, id);
 }
 
-- 
1.7.1

