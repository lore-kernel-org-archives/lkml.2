Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754384Ab2CHIEp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 03:04:45 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:25464 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753981Ab2CHIEm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 03:04:42 -0500
X-IronPort-AV: E=Sophos;i="4.73,551,1325433600"; 
   d="scan'208";a="4488987"
Message-ID: <4F58687F.6060305@cn.fujitsu.com>
Date: Thu, 08 Mar 2012 16:06:23 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Gleb Natapov <gleb@redhat.com>
Subject: [PATCH 1/2 v3] update linux-headers
References: <4F58664D.1070800@cn.fujitsu.com>
In-Reply-To: <4F58664D.1070800@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-08 16:02:43,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-08 16:02:45,
	Serialize complete at 2012-03-08 16:02:45
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
---
 linux-headers/asm-s390/kvm.h   |    2 ++
 linux-headers/linux/kvm.h      |    7 +++++++
 linux-headers/linux/kvm_para.h |    1 +
 3 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/linux-headers/asm-s390/kvm.h b/linux-headers/asm-s390/kvm.h
index 9acbde4..9607667 100644
--- a/linux-headers/asm-s390/kvm.h
+++ b/linux-headers/asm-s390/kvm.h
@@ -44,10 +44,12 @@ struct kvm_guest_debug_arch {
 #define KVM_SYNC_PREFIX (1UL << 0)
 #define KVM_SYNC_GPRS   (1UL << 1)
 #define KVM_SYNC_ACRS   (1UL << 2)
+#define KVM_SYNC_CRS    (1UL << 3)
 /* definition of registers in kvm_run */
 struct kvm_sync_regs {
 	__u64 prefix;	/* prefix register */
 	__u64 gprs[16];	/* general purpose registers */
 	__u32 acrs[16];	/* access registers */
+	__u64 crs[16];	/* control registers */
 };
 #endif
diff --git a/linux-headers/linux/kvm.h b/linux-headers/linux/kvm.h
index f6b5343..aa1c65e 100644
--- a/linux-headers/linux/kvm.h
+++ b/linux-headers/linux/kvm.h
@@ -163,6 +163,7 @@ struct kvm_pit_config {
 #define KVM_EXIT_OSI              18
 #define KVM_EXIT_PAPR_HCALL	  19
 #define KVM_EXIT_S390_UCONTROL	  20
+#define KVM_EXIT_GUEST_PANICKED	  21
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 #define KVM_INTERNAL_ERROR_EMULATION 1
@@ -588,6 +589,7 @@ struct kvm_ppc_pvinfo {
 #define KVM_CAP_TSC_DEADLINE_TIMER 72
 #define KVM_CAP_S390_UCONTROL 73
 #define KVM_CAP_SYNC_REGS 74
+#define KVM_CAP_PCI_2_3 75
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -784,6 +786,9 @@ struct kvm_s390_ucas_mapping {
 /* Available with KVM_CAP_TSC_CONTROL */
 #define KVM_SET_TSC_KHZ           _IO(KVMIO,  0xa2)
 #define KVM_GET_TSC_KHZ           _IO(KVMIO,  0xa3)
+/* Available with KVM_CAP_PCI_2_3 */
+#define KVM_ASSIGN_SET_INTX_MASK  _IOW(KVMIO,  0xa4, \
+				       struct kvm_assigned_pci_dev)
 
 /*
  * ioctls for vcpu fds
@@ -857,6 +862,8 @@ struct kvm_s390_ucas_mapping {
 #define KVM_SET_ONE_REG		  _IOW(KVMIO,  0xac, struct kvm_one_reg)
 
 #define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
+#define KVM_DEV_ASSIGN_PCI_2_3		(1 << 1)
+#define KVM_DEV_ASSIGN_MASK_INTX	(1 << 2)
 
 struct kvm_assigned_pci_dev {
 	__u32 assigned_dev_id;
diff --git a/linux-headers/linux/kvm_para.h b/linux-headers/linux/kvm_para.h
index 7bdcf93..9be20ee 100644
--- a/linux-headers/linux/kvm_para.h
+++ b/linux-headers/linux/kvm_para.h
@@ -19,6 +19,7 @@
 #define KVM_HC_MMU_OP			2
 #define KVM_HC_FEATURES			3
 #define KVM_HC_PPC_MAP_MAGIC_PAGE	4
+#define KVM_HC_GUEST_PANICKED		5
 
 /*
  * hypercalls use architecture specific
-- 
1.7.1

