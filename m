Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965342Ab2LFWVG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 17:21:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13486 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964856Ab2LFWVE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 17:21:04 -0500
Subject: [PATCH 06/10] kvm: Make KVM_PRIVATE_MEM_SLOTS optional
To: mtosatti@redhat.com, gleb@redhat.com
From: Alex Williamson <alex.williamson@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Date: Thu, 06 Dec 2012 15:21:03 -0700
Message-ID: <20121206222103.24968.19718.stgit@bling.home>
In-Reply-To: <20121206214722.24968.6043.stgit@bling.home>
References: <20121206214722.24968.6043.stgit@bling.home>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seems like everyone copied x86 and defined 4 private memory slots
that never actually get used.  Even x86 only uses 3 of the 4.  These
aren't exposed so there's no need to add padding.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 arch/ia64/include/asm/kvm_host.h    |    2 --
 arch/powerpc/include/asm/kvm_host.h |    4 +---
 arch/s390/include/asm/kvm_host.h    |    2 --
 arch/x86/include/asm/kvm_host.h     |    4 ++--
 include/linux/kvm_host.h            |    4 ++++
 5 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/arch/ia64/include/asm/kvm_host.h b/arch/ia64/include/asm/kvm_host.h
index 48d7b0e..cfa7498 100644
--- a/arch/ia64/include/asm/kvm_host.h
+++ b/arch/ia64/include/asm/kvm_host.h
@@ -24,8 +24,6 @@
 #define __ASM_KVM_HOST_H
 
 #define KVM_USER_MEM_SLOTS 32
-/* memory slots that does not exposed to userspace */
-#define KVM_PRIVATE_MEM_SLOTS 4
 
 #define KVM_COALESCED_MMIO_PAGE_OFFSET 1
 
diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index 5eb1dd8..23ca70d 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -38,9 +38,7 @@
 #define KVM_MAX_VCPUS		NR_CPUS
 #define KVM_MAX_VCORES		NR_CPUS
 #define KVM_USER_MEM_SLOTS 32
-/* memory slots that does not exposed to userspace */
-#define KVM_PRIVATE_MEM_SLOTS 4
-#define KVM_MEM_SLOTS_NUM (KVM_USER_MEM_SLOTS + KVM_PRIVATE_MEM_SLOTS)
+#define KVM_MEM_SLOTS_NUM KVM_USER_MEM_SLOTS
 
 #ifdef CONFIG_KVM_MMIO
 #define KVM_COALESCED_MMIO_PAGE_OFFSET 1
diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index ac33432..711c5ab 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -21,8 +21,6 @@
 
 #define KVM_MAX_VCPUS 64
 #define KVM_USER_MEM_SLOTS 32
-/* memory slots that does not exposed to userspace */
-#define KVM_PRIVATE_MEM_SLOTS 4
 
 struct sca_entry {
 	atomic_t scn;
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index e619519..ce8b037 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -32,8 +32,8 @@
 #define KVM_MAX_VCPUS 254
 #define KVM_SOFT_MAX_VCPUS 160
 #define KVM_USER_MEM_SLOTS 32
-/* memory slots that does not exposed to userspace */
-#define KVM_PRIVATE_MEM_SLOTS 4
+/* memory slots that are not exposed to userspace */
+#define KVM_PRIVATE_MEM_SLOTS 3
 #define KVM_MEM_SLOTS_NUM (KVM_USER_MEM_SLOTS + KVM_PRIVATE_MEM_SLOTS)
 
 #define KVM_MMIO_SIZE 16
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index fb9354d..bf8380f 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -298,6 +298,10 @@ struct kvm_irq_routing_table {};
 
 #endif
 
+#ifndef KVM_PRIVATE_MEM_SLOTS
+#define KVM_PRIVATE_MEM_SLOTS 0
+#endif
+
 #ifndef KVM_MEM_SLOTS_NUM
 #define KVM_MEM_SLOTS_NUM (KVM_USER_MEM_SLOTS + KVM_PRIVATE_MEM_SLOTS)
 #endif

