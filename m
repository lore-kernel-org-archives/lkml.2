Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756358Ab1LPGcR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 01:32:17 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:64864 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298Ab1LPGcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 01:32:15 -0500
Date: Fri, 16 Dec 2011 13:32:07 +0800
From: zanghongyong@huawei.com
Subject: [PATCH 1/2] kvm: Introduce get_kvm_from_task
In-reply-to: <1324013528-3663-1-git-send-email-zanghongyong@huawei.com>
X-Originating-IP: [10.166.29.45]
To: linux-kernel@vger.kernel.org
Cc: mst@redhat.com, levinsasha928@gmail.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        xiaowei.yang@huawei.com, hanweidong@huawei.com, wusongwei@huawei.com,
        Hongyong Zang <zanghongyong@huawei.com>
Message-id: <1324013528-3663-2-git-send-email-zanghongyong@huawei.com>
MIME-version: 1.0
X-Mailer: git-send-email 1.7.0.4
Content-type: text/plain
Content-transfer-encoding: 7BIT
X-CFilter-Loop: Reflected
References: <1324013528-3663-1-git-send-email-zanghongyong@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hongyong Zang <zanghongyong@huawei.com>

This function finds the kvm structure from its corresponding user
space process, such as qemu process.

Signed-off-by: Hongyong Zang <zanghongyong@huawei.com>
---
 include/linux/kvm_host.h |    2 +-
 virt/kvm/kvm_main.c      |   13 +++++++++++++
 2 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 8c5c303..1b2f027 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -801,4 +801,4 @@ static inline bool kvm_check_request(int req, struct kvm_vcpu *vcpu)
 }
 
 #endif
-
+struct kvm *get_kvm_from_task(struct task_struct *task);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index e289486..458fe29 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2664,6 +2664,19 @@ static const struct file_operations *stat_fops[] = {
 	[KVM_STAT_VM]   = &vm_stat_fops,
 };
 
+struct kvm* get_kvm_from_task(struct task_struct *task)
+{
+        struct kvm *kvm;
+
+        list_for_each_entry(kvm, &vm_list, vm_list) {
+                if(kvm->mm == task->mm)
+                    return kvm;
+        }
+
+        return NULL;
+}
+EXPORT_SYMBOL_GPL(get_kvm_from_task);
+
 static void kvm_init_debug(void)
 {
 	struct kvm_stats_debugfs_item *p;
-- 
1.7.1

