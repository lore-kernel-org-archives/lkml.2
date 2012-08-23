Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757323Ab2HWCZg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 22:25:36 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:23424 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754824Ab2HWCZc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 22:25:32 -0400
X-IronPort-AV: E=Sophos;i="4.77,812,1336320000"; 
   d="scan'208";a="5700320"
Message-ID: <503595D8.3060500@cn.fujitsu.com>
Date: Thu, 23 Aug 2012 10:30:48 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Gleb Natapov <gleb@redhat.com>,
        Blue Swirl <blauwirbel@gmail.com>, Eric Blake <eblake@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH v9 2/6] kvm: Update kernel headers
References: <50359561.9070001@cn.fujitsu.com>
In-Reply-To: <50359561.9070001@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/23 10:25:27,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/23 10:25:29,
	Serialize complete at 2012/08/23 10:25:29
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Corresponding kvm.git hash: 35f2d16b with my patch for kvm
---
 linux-headers/asm-s390/kvm.h      |    2 +-
 linux-headers/asm-s390/kvm_para.h |    2 +-
 linux-headers/asm-x86/kvm.h       |    1 +
 linux-headers/asm-x86/kvm_para.h  |    9 +++++++++
 linux-headers/linux/kvm.h         |    3 +++
 linux-headers/linux/kvm_para.h    |    6 ++++++
 6 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/linux-headers/asm-s390/kvm.h b/linux-headers/asm-s390/kvm.h
index bdcbe0f..d25da59 100644
--- a/linux-headers/asm-s390/kvm.h
+++ b/linux-headers/asm-s390/kvm.h
@@ -1,7 +1,7 @@
 #ifndef __LINUX_KVM_S390_H
 #define __LINUX_KVM_S390_H
 /*
- * asm-s390/kvm.h - KVM s390 specific structures and definitions
+ * KVM s390 specific structures and definitions
  *
  * Copyright IBM Corp. 2008
  *
diff --git a/linux-headers/asm-s390/kvm_para.h b/linux-headers/asm-s390/kvm_para.h
index 8e2dd67..870051f 100644
--- a/linux-headers/asm-s390/kvm_para.h
+++ b/linux-headers/asm-s390/kvm_para.h
@@ -1,5 +1,5 @@
 /*
- * asm-s390/kvm_para.h - definition for paravirtual devices on s390
+ * definition for paravirtual devices on s390
  *
  * Copyright IBM Corp. 2008
  *
diff --git a/linux-headers/asm-x86/kvm.h b/linux-headers/asm-x86/kvm.h
index e7d1c19..246617e 100644
--- a/linux-headers/asm-x86/kvm.h
+++ b/linux-headers/asm-x86/kvm.h
@@ -12,6 +12,7 @@
 /* Select x86 specific features in <linux/kvm.h> */
 #define __KVM_HAVE_PIT
 #define __KVM_HAVE_IOAPIC
+#define __KVM_HAVE_IRQ_LINE
 #define __KVM_HAVE_DEVICE_ASSIGNMENT
 #define __KVM_HAVE_MSI
 #define __KVM_HAVE_USER_NMI
diff --git a/linux-headers/asm-x86/kvm_para.h b/linux-headers/asm-x86/kvm_para.h
index f2ac46a..53aca59 100644
--- a/linux-headers/asm-x86/kvm_para.h
+++ b/linux-headers/asm-x86/kvm_para.h
@@ -22,6 +22,7 @@
 #define KVM_FEATURE_CLOCKSOURCE2        3
 #define KVM_FEATURE_ASYNC_PF		4
 #define KVM_FEATURE_STEAL_TIME		5
+#define KVM_FEATURE_PV_EOI		6
 
 /* The last 8 bits are used to indicate how to interpret the flags field
  * in pvclock structure. If no bits are set, all flags are ignored.
@@ -37,6 +38,7 @@
 #define MSR_KVM_SYSTEM_TIME_NEW 0x4b564d01
 #define MSR_KVM_ASYNC_PF_EN 0x4b564d02
 #define MSR_KVM_STEAL_TIME  0x4b564d03
+#define MSR_KVM_PV_EOI_EN      0x4b564d04
 
 struct kvm_steal_time {
 	__u64 steal;
@@ -89,5 +91,12 @@ struct kvm_vcpu_pv_apf_data {
 	__u32 enabled;
 };
 
+#define KVM_PV_EOI_BIT 0
+#define KVM_PV_EOI_MASK (0x1 << KVM_PV_EOI_BIT)
+#define KVM_PV_EOI_ENABLED KVM_PV_EOI_MASK
+#define KVM_PV_EOI_DISABLED 0x0
+
+#define KVM_PV_EVENT_PORT	(0x505UL)
+
 
 #endif /* _ASM_X86_KVM_PARA_H */
diff --git a/linux-headers/linux/kvm.h b/linux-headers/linux/kvm.h
index 5a9d4e3..4b9e575 100644
--- a/linux-headers/linux/kvm.h
+++ b/linux-headers/linux/kvm.h
@@ -617,6 +617,7 @@ struct kvm_ppc_smmu_info {
 #define KVM_CAP_SIGNAL_MSI 77
 #define KVM_CAP_PPC_GET_SMMU_INFO 78
 #define KVM_CAP_S390_COW 79
+#define KVM_CAP_PPC_ALLOC_HTAB 80
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -828,6 +829,8 @@ struct kvm_s390_ucas_mapping {
 #define KVM_SIGNAL_MSI            _IOW(KVMIO,  0xa5, struct kvm_msi)
 /* Available with KVM_CAP_PPC_GET_SMMU_INFO */
 #define KVM_PPC_GET_SMMU_INFO	  _IOR(KVMIO,  0xa6, struct kvm_ppc_smmu_info)
+/* Available with KVM_CAP_PPC_ALLOC_HTAB */
+#define KVM_PPC_ALLOCATE_HTAB	  _IOWR(KVMIO, 0xa7, __u32)
 
 /*
  * ioctls for vcpu fds
diff --git a/linux-headers/linux/kvm_para.h b/linux-headers/linux/kvm_para.h
index 7bdcf93..f6be0bb 100644
--- a/linux-headers/linux/kvm_para.h
+++ b/linux-headers/linux/kvm_para.h
@@ -20,6 +20,12 @@
 #define KVM_HC_FEATURES			3
 #define KVM_HC_PPC_MAP_MAGIC_PAGE	4
 
+/* The bit of supported pv event */
+#define KVM_PV_FEATURE_PANICKED	0
+
+/* The pv event value */
+#define KVM_PV_EVENT_PANICKED	1
+
 /*
  * hypercalls use architecture specific
  */
-- 
1.7.1

