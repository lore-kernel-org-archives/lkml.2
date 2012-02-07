Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756998Ab2BGV23 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 16:28:29 -0500
Received: from oz.csail.mit.edu ([128.30.30.239]:53259 "EHLO mail.mgebm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756533Ab2BGV2Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 16:28:25 -0500
From: Eric B Munson <emunson@mgebm.net>
To: avi@redhat.com
Cc: Eric B Munson <emunson@mgebm.net>, mingo@redhat.com, hpa@zytor.com,
        ryanh@linux.vnet.ibm.com, aliguori@us.ibm.com, mtosatti@redhat.com,
        kvm@vger.kernel.org, linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/4 V12] Add ioctl for KVMCLOCK_GUEST_STOPPED
Date: Tue,  7 Feb 2012 16:28:19 -0500
Message-Id: <1328650100-19521-4-git-send-email-emunson@mgebm.net>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1328650100-19521-1-git-send-email-emunson@mgebm.net>
References: <1328650100-19521-1-git-send-email-emunson@mgebm.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we have a flag that will tell the guest it was suspended, create an
interface for that communication using a KVM ioctl.

Signed-off-by: Eric B Munson <emunson@mgebm.net>

Cc: mingo@redhat.com
Cc: hpa@zytor.com
Cc: ryanh@linux.vnet.ibm.com
Cc: aliguori@us.ibm.com
Cc: mtosatti@redhat.com
Cc: kvm@vger.kernel.org
Cc: linux-arch@vger.kernel.org
Cc: x86@kernel.org
Cc: linux-kernel@vger.kernel.org
---
Changes from V11:
 Correct typo in api.txt
 Add kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu) call to kvm_set_guest_paused()
Changes from V10:
 Return the ioctl to per vcpu instead of per vm
Changes from V9:
 Use kvm_for_each_vcpu to iterate online vcpu's
Changes from V8:
 Make KVM_GUEST_PAUSED a per vm ioctl instead of per vcpu
Changes from V7:
 Define KVM_CAP_GUEST_PAUSED and support check
 Call mark_page_dirty () after setting PVCLOCK_GUEST_STOPPED
Changes from V4:
 Rename KVM_GUEST_PAUSED to KVMCLOCK_GUEST_PAUSED
 Add new ioctl description to api.txt

 include/linux/kvm.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index c3892fc..dbfc4f8 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -557,6 +557,7 @@ struct kvm_ppc_pvinfo {
 #define KVM_CAP_MAX_VCPUS 66       /* returns max vcpus per vm */
 #define KVM_CAP_PPC_PAPR 68
 #define KVM_CAP_S390_GMAP 71
+#define KVM_CAP_GUEST_PAUSED 72
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -762,6 +763,8 @@ struct kvm_clock_data {
 #define KVM_CREATE_SPAPR_TCE	  _IOW(KVMIO,  0xa8, struct kvm_create_spapr_tce)
 /* Available with KVM_CAP_RMA */
 #define KVM_ALLOCATE_RMA	  _IOR(KVMIO,  0xa9, struct kvm_allocate_rma)
+/* VM is being stopped by host */
+#define KVMCLOCK_GUEST_PAUSED    _IO(KVMIO,   0xaa)
 
 #define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
 
-- 
1.7.5.4

