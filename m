Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751813Ab1LATnb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 14:43:31 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60850 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063Ab1LATn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 14:43:29 -0500
From: Sasha Levin <levinsasha928@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Sasha Levin <levinsasha928@gmail.com>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH] KVM: Veirfy memory slot only for readability
Date: Thu,  1 Dec 2011 21:42:56 +0200
Message-Id: <1322768576-9242-1-git-send-email-levinsasha928@gmail.com>
X-Mailer: git-send-email 1.7.8.rc4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's enough for memory slot to be readable, as the comment above the check
states.

A user should be able to create read-only memory slot.

Cc: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: kvm@vger.kernel.org
Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
---
 virt/kvm/kvm_main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index e289486..b92883f 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -727,7 +727,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	/* We can read the guest memory with __xxx_user() later on. */
 	if (user_alloc &&
 	    ((mem->userspace_addr & (PAGE_SIZE - 1)) ||
-	     !access_ok(VERIFY_WRITE,
+	     !access_ok(VERIFY_READ,
 			(void __user *)(unsigned long)mem->userspace_addr,
 			mem->memory_size)))
 		goto out;
-- 
1.7.8.rc4

