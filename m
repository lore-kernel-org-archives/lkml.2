Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550Ab2HUC65 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 22:58:57 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:34149 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755269Ab2HUC6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 22:58:54 -0400
Message-ID: <5032F965.6020900@linux.vnet.ibm.com>
Date: Tue, 21 Aug 2012 10:58:45 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH v6 03/12] KVM: hide KVM_MEMSLOT_INVALID from userspace
References: <5032F8FD.2020306@linux.vnet.ibm.com>
In-Reply-To: <5032F8FD.2020306@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12082102-8878-0000-0000-000003AE1FBD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quote Avi's comment:
| KVM_MEMSLOT_INVALID is actually an internal symbol, not used by
| userspace.  Please move it to kvm_host.h.

Also, we divide the memlsot->flags into two parts, the lower 16 bits
are visible for userspace, the higher 16 bits are internally used in
kvm

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 include/linux/kvm.h      |    7 +++++--
 include/linux/kvm_host.h |    7 +++++++
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 2ce09aa..2de335d 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -101,9 +101,12 @@ struct kvm_userspace_memory_region {
 	__u64 userspace_addr; /* start of the userspace allocated memory */
 };

-/* for kvm_memory_region::flags */
+/*
+ * The bit 0 ~ bit 15 of kvm_memory_region::flags are visible for userspace,
+ * other bits are reserved for kvm internal use which are defined in
+ * include/linux/kvm_host.h.
+ */
 #define KVM_MEM_LOG_DIRTY_PAGES  1UL
-#define KVM_MEMSLOT_INVALID      (1UL << 1)

 /* for KVM_IRQ_LINE */
 struct kvm_irq_level {
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index d2b897e..d4bd4d4 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -36,6 +36,13 @@
 #endif

 /*
+ * The bit 16 ~ bit 31 of kvm_memory_region::flags are internally used
+ * in kvm, other bits are visible for userspace which are defined in
+ * include/linux/kvm_h.
+ */
+#define KVM_MEMSLOT_INVALID	(1UL << 16)
+
+/*
  * If we support unaligned MMIO, at most one fragment will be split into two:
  */
 #ifdef KVM_UNALIGNED_MMIO
-- 
1.7.7.6

