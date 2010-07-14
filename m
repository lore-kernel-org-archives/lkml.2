Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757912Ab0GNUO0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 16:14:26 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:52430 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757528Ab0GNUKR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 16:10:17 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        Arnd Bergmann <arnd@relay.de.ibm.com>, Arnd Bergmann <arnd@arndb.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH RFC tip/core/rcu 18/30] kvm: more __rcu annotations
Date: Wed, 14 Jul 2010 13:09:52 -0700
Message-Id: <1279138204-12849-18-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.6
In-Reply-To: <20100714200945.GA10535@linux.vnet.ibm.com>
References: <20100714200945.GA10535@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@relay.de.ibm.com>

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |    2 +-
 include/linux/kvm_host.h        |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 76f5483..66524cd 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -378,7 +378,7 @@ struct kvm_mem_aliases {
 };
 
 struct kvm_arch {
-	struct kvm_mem_aliases *aliases;
+	struct kvm_mem_aliases __rcu *aliases;
 
 	unsigned int n_free_mmu_pages;
 	unsigned int n_requested_mmu_pages;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index b34b1b4..b1964a8 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -175,7 +175,7 @@ struct kvm {
 	raw_spinlock_t requests_lock;
 	struct mutex slots_lock;
 	struct mm_struct *mm; /* userspace tied to this vm */
-	struct kvm_memslots *memslots;
+	struct kvm_memslots __rcu *memslots;
 	struct srcu_struct srcu;
 #ifdef CONFIG_KVM_APIC_ARCHITECTURE
 	u32 bsp_vcpu_id;
@@ -185,7 +185,7 @@ struct kvm {
 	atomic_t online_vcpus;
 	struct list_head vm_list;
 	struct mutex lock;
-	struct kvm_io_bus *buses[KVM_NR_BUSES];
+	struct kvm_io_bus __rcu *buses[KVM_NR_BUSES];
 #ifdef CONFIG_HAVE_KVM_EVENTFD
 	struct {
 		spinlock_t        lock;
-- 
1.7.0.6

