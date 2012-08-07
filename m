Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753799Ab2HGJtE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 05:49:04 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:33865 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752307Ab2HGJtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 05:49:01 -0400
Message-ID: <5020E481.1050203@linux.vnet.ibm.com>
Date: Tue, 07 Aug 2012 17:48:49 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH v5 02/12] KVM: hide KVM_MEMSLOT_INVALID from userspace
References: <5020E423.9080004@linux.vnet.ibm.com>
In-Reply-To: <5020E423.9080004@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12080709-4790-0000-0000-00000406FFB9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quote Avi's comment:
| KVM_MEMSLOT_INVALID is actually an internal symbol, not used by
| userspace.  Please move it to kvm_host.h.

Also, move KVM_MEMSLOT_INVALID to the highest bit

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 include/linux/kvm.h      |    1 -
 include/linux/kvm_host.h |    2 ++
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 2ce09aa..dc3aa2a 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -103,7 +103,6 @@ struct kvm_userspace_memory_region {

 /* for kvm_memory_region::flags */
 #define KVM_MEM_LOG_DIRTY_PAGES  1UL
-#define KVM_MEMSLOT_INVALID      (1UL << 1)

 /* for KVM_IRQ_LINE */
 struct kvm_irq_level {
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index d2b897e..4c2da5a 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -35,6 +35,8 @@
 #define KVM_MMIO_SIZE 8
 #endif

+#define KVM_MEMSLOT_INVALID	(1UL << 31)
+
 /*
  * If we support unaligned MMIO, at most one fragment will be split into two:
  */
-- 
1.7.7.6

