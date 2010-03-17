Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760Ab0CQDrH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 23:47:07 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56100 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752396Ab0CQDrE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 23:47:04 -0400
Message-ID: <4BA05040.4000101@cn.fujitsu.com>
Date: Wed, 17 Mar 2010 11:45:04 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: KVM list <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] KVM: cleanup kvm_get_dirty_log()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using bitmap_empty() to see whether memslot->dirty_bitmap is empty

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 virt/kvm/kvm_main.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index bcd08b8..497ae14 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -767,8 +767,7 @@ int kvm_get_dirty_log(struct kvm *kvm,
 			struct kvm_dirty_log *log, int *is_dirty)
 {
 	struct kvm_memory_slot *memslot;
-	int r, i;
-	int n;
+	int r, n;
 	unsigned long any = 0;
 
 	r = -EINVAL;
@@ -782,8 +781,7 @@ int kvm_get_dirty_log(struct kvm *kvm,
 
 	n = ALIGN(memslot->npages, BITS_PER_LONG) / 8;
 
-	for (i = 0; !any && i < n/sizeof(long); ++i)
-		any = memslot->dirty_bitmap[i];
+	any = !bitmap_empty(memslot->dirty_bitmap, memslot->npages);
 
 	r = -EFAULT;
 	if (copy_to_user(log->dirty_bitmap, memslot->dirty_bitmap, n))
-- 
1.6.1.2

