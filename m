Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752025Ab1ADIFy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 03:05:54 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:64080 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751915Ab1ADIFx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 03:05:53 -0500
Message-ID: <4D22D4F3.3070908@cn.fujitsu.com>
Date: Tue, 04 Jan 2011 16:06:11 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Arnd Bergmann <arnd@arndb.de>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] kvm: add __rcu annotations
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-01-04 16:05:30,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-01-04 16:05:30,
	Serialize complete at 2011-01-04 16:05:30
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add __rcu annotations to :
	(struct kvm)->memslots
	(struct kvm)->buses

signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index a055742..d23f324 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -178,7 +178,7 @@ struct kvm {
 	raw_spinlock_t requests_lock;
 	struct mutex slots_lock;
 	struct mm_struct *mm; /* userspace tied to this vm */
-	struct kvm_memslots *memslots;
+	struct kvm_memslots __rcu *memslots;
 	struct srcu_struct srcu;
 #ifdef CONFIG_KVM_APIC_ARCHITECTURE
 	u32 bsp_vcpu_id;
@@ -188,7 +188,7 @@ struct kvm {
 	atomic_t online_vcpus;
 	struct list_head vm_list;
 	struct mutex lock;
-	struct kvm_io_bus *buses[KVM_NR_BUSES];
+	struct kvm_io_bus __rcu *buses[KVM_NR_BUSES];
 #ifdef CONFIG_HAVE_KVM_EVENTFD
 	struct {
 		spinlock_t        lock;
