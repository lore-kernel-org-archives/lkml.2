Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932250Ab2F0Vm2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 17:42:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52506 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932185Ab2F0Vm1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 17:42:27 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>, Avi Kivity <avi@redhat.com>,
        Gleb Natapov <gleb@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH] kvm, Add x86_hyper_kvm to complete detect_hypervisor_platform check
Date: Wed, 27 Jun 2012 17:42:18 -0400
Message-Id: <1340833338-15485-1-git-send-email-prarit@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While debugging I noticed that unlike all the other hypervisor code in the
kernel, kvm does not have an entry for x86_hyper which is used in
detect_hypervisor_platform(), and results in a nice message about the
hypervisor being used.  This is only really a stub function and it makes
kvm more consistent with the other hypervisors (and it makes debugging
a little easier).

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Gleb Natapov <gleb@redhat.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
---
 arch/x86/include/asm/hypervisor.h |    1 +
 arch/x86/kernel/cpu/hypervisor.c  |    1 +
 arch/x86/kernel/kvm.c             |    6 ++++++
 3 files changed, 8 insertions(+)

diff --git a/arch/x86/include/asm/hypervisor.h b/arch/x86/include/asm/hypervisor.h
index 7a15153..b518c75 100644
--- a/arch/x86/include/asm/hypervisor.h
+++ b/arch/x86/include/asm/hypervisor.h
@@ -49,6 +49,7 @@ extern const struct hypervisor_x86 *x86_hyper;
 extern const struct hypervisor_x86 x86_hyper_vmware;
 extern const struct hypervisor_x86 x86_hyper_ms_hyperv;
 extern const struct hypervisor_x86 x86_hyper_xen_hvm;
+extern const struct hypervisor_x86 x86_hyper_kvm;
 
 static inline bool hypervisor_x2apic_available(void)
 {
diff --git a/arch/x86/kernel/cpu/hypervisor.c b/arch/x86/kernel/cpu/hypervisor.c
index 755f64f..6d6dd7a 100644
--- a/arch/x86/kernel/cpu/hypervisor.c
+++ b/arch/x86/kernel/cpu/hypervisor.c
@@ -37,6 +37,7 @@ static const __initconst struct hypervisor_x86 * const hypervisors[] =
 #endif
 	&x86_hyper_vmware,
 	&x86_hyper_ms_hyperv,
+	&x86_hyper_kvm,
 };
 
 const struct hypervisor_x86 *x86_hyper;
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index e554e5a..0a38b68 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -39,6 +39,7 @@
 #include <asm/desc.h>
 #include <asm/tlbflush.h>
 #include <asm/idle.h>
+#include <asm/hypervisor.h>
 
 static int kvmapf = 1;
 
@@ -432,6 +433,11 @@ void __init kvm_guest_init(void)
 #endif
 }
 
+const struct hypervisor_x86 x86_hyper_kvm __refconst = {
+	.name			= "KVM",
+};
+EXPORT_SYMBOL(x86_hyper_kvm);
+
 static __init int activate_jump_labels(void)
 {
 	if (has_steal_clock) {
-- 
1.7.9.3

