Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753604Ab1K0Cqj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Nov 2011 21:46:39 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59661 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906Ab1K0Cqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Nov 2011 21:46:36 -0500
From: Liu Ping Fan <kernelfans@gmail.com>
To: kvm@vger.kernel.org, qemu-devel@nongnu.org
Cc: linux-kernel@vger.kernel.org, avi@redhat.com, aliguori@us.ibm.com,
        jan.kiszka@web.de, ryanh@us.ibm.com
Subject: [PATCH 5/5] QEMU tmp patches for linux-header files
Date: Sun, 27 Nov 2011 10:45:37 +0800
Message-Id: <1322361937-22438-5-git-send-email-kernelfans@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1322188529-11609-1-git-send-email-kernelfans@gmail.com>
References: <1322188529-11609-1-git-send-email-kernelfans@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Liu Ping Fan <pingfank@linux.vnet.ibm.com>

Temporary patch for qemu to compile. Normally the headers should be
copied from kernel.

Signed-off-by: Liu Ping Fan <pingfank@linux.vnet.ibm.com>
---
 kvm/include/linux/kvm.h   |    9 ++++++++-
 linux-headers/linux/kvm.h |    9 +++++++++
 2 files changed, 17 insertions(+), 1 deletions(-)

diff --git a/kvm/include/linux/kvm.h b/kvm/include/linux/kvm.h
index e46729e..a7fe019 100644
--- a/kvm/include/linux/kvm.h
+++ b/kvm/include/linux/kvm.h
@@ -162,6 +162,7 @@ struct kvm_pit_config {
 #define KVM_EXIT_INTERNAL_ERROR   17
 #define KVM_EXIT_OSI              18
 
+#define KVM_EXIT_VCPU_DEAD              20
 /* For KVM_EXIT_INTERNAL_ERROR */
 #define KVM_INTERNAL_ERROR_EMULATION 1
 #define KVM_INTERNAL_ERROR_SIMUL_EX 2
@@ -328,6 +329,12 @@ struct kvm_signal_mask {
 	__u8  sigset[0];
 };
 
+/*for KVM_VCPU_SET_STATE */
+struct kvm_vcpu_state {
+	int vcpu_id;
+	int state;
+};
+
 /* for KVM_TPR_ACCESS_REPORTING */
 struct kvm_tpr_access_ctl {
 	__u32 enabled;
@@ -726,7 +733,7 @@ struct kvm_clock_data {
 /* Available with KVM_CAP_XCRS */
 #define KVM_GET_XCRS		  _IOR(KVMIO,  0xa6, struct kvm_xcrs)
 #define KVM_SET_XCRS		  _IOW(KVMIO,  0xa7, struct kvm_xcrs)
-
+#define KVM_SETSTATE_VCPU     _IOW(KVMIO,   0xaa, struct kvm_vcpu_state)
 #define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
 
 struct kvm_assigned_pci_dev {
diff --git a/linux-headers/linux/kvm.h b/linux-headers/linux/kvm.h
index fc63b73..4422456 100644
--- a/linux-headers/linux/kvm.h
+++ b/linux-headers/linux/kvm.h
@@ -161,6 +161,8 @@ struct kvm_pit_config {
 #define KVM_EXIT_NMI              16
 #define KVM_EXIT_INTERNAL_ERROR   17
 #define KVM_EXIT_OSI              18
+#define KVM_EXIT_VCPU_DEAD              20
+
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 #define KVM_INTERNAL_ERROR_EMULATION 1
@@ -328,6 +330,12 @@ struct kvm_signal_mask {
 	__u8  sigset[0];
 };
 
+/*for KVM_VCPU_SET_STATE */
+struct kvm_vcpu_state {
+	int vcpu_id;
+	int state;
+};
+
 /* for KVM_TPR_ACCESS_REPORTING */
 struct kvm_tpr_access_ctl {
 	__u32 enabled;
@@ -747,6 +755,7 @@ struct kvm_clock_data {
 #define KVM_GET_XCRS		  _IOR(KVMIO,  0xa6, struct kvm_xcrs)
 #define KVM_SET_XCRS		  _IOW(KVMIO,  0xa7, struct kvm_xcrs)
 
+#define KVM_SETSTATE_VCPU     _IOW(KVMIO,   0xaa, struct kvm_vcpu_state)
 #define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
 
 struct kvm_assigned_pci_dev {
-- 
1.7.4.4

