Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752910Ab2LJRdl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 12:33:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44298 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752817Ab2LJRdj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 12:33:39 -0500
Subject: [PATCH v2 10/10] kvm: Increase user memory slots on x86 to 125
To: mtosatti@redhat.com, gleb@redhat.com
From: Alex Williamson <alex.williamson@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Date: Mon, 10 Dec 2012 10:33:38 -0700
Message-ID: <20121210173338.10461.31808.stgit@bling.home>
In-Reply-To: <20121210171417.10461.20079.stgit@bling.home>
References: <20121210171417.10461.20079.stgit@bling.home>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the 3 private slots, this gives us a nice round 128 slots total.
The primary motivation for this is to support more assigned devices.
Each assigned device can theoretically use up to 8 slots (6 MMIO BARs,
1 ROM BAR, 1 spare for a split MSI-X table mapping) though it's far
more typical for a device to use 3-4 slots.  If we assume a typical VM
uses a dozen slots for non-assigned devices purposes, we should always
be able to support 14 worst case assigned devices or 28 to 37 typical
devices.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index ce8b037..9558a1e 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -31,7 +31,7 @@
 
 #define KVM_MAX_VCPUS 254
 #define KVM_SOFT_MAX_VCPUS 160
-#define KVM_USER_MEM_SLOTS 32
+#define KVM_USER_MEM_SLOTS 125
 /* memory slots that are not exposed to userspace */
 #define KVM_PRIVATE_MEM_SLOTS 3
 #define KVM_MEM_SLOTS_NUM (KVM_USER_MEM_SLOTS + KVM_PRIVATE_MEM_SLOTS)

