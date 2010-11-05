Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753578Ab0KEDIo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 23:08:44 -0400
Received: from mail.perches.com ([173.55.12.10]:4054 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753475Ab0KEDIh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 23:08:37 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        amd64-microcode@amd64.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH 05/49] arch/x86: Use vzalloc
Date: Thu,  4 Nov 2010 20:07:29 -0700
Message-Id: <9eb79212eddaa03ff3e7ddc88bc59b7564ea317c.1288925424.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <alpine.DEB.2.00.1011031108260.11625@router.home>
References: <alpine.DEB.2.00.1011031108260.11625@router.home>
In-Reply-To: <cover.1288925424.git.joe@perches.com>
References: <cover.1288925424.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/x86/kernel/microcode_amd.c |    3 +--
 arch/x86/kvm/x86.c              |    3 +--
 arch/x86/mm/pageattr-test.c     |    3 +--
 3 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index e1af7c0..d46e805 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -183,9 +183,8 @@ get_next_ucode(const u8 *buf, unsigned int size, unsigned int *mc_size)
 		return NULL;
 	}
 
-	mc = vmalloc(UCODE_MAX_SIZE);
+	mc = vzalloc(UCODE_MAX_SIZE);
 	if (mc) {
-		memset(mc, 0, UCODE_MAX_SIZE);
 		if (get_ucode_data(mc, buf + UCODE_CONTAINER_SECTION_HDR,
 				   total_size)) {
 			vfree(mc);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2288ad8..624d4da 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3174,10 +3174,9 @@ int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm,
 		spin_unlock(&kvm->mmu_lock);
 
 		r = -ENOMEM;
-		dirty_bitmap = vmalloc(n);
+		dirty_bitmap = vzalloc(n);
 		if (!dirty_bitmap)
 			goto out;
-		memset(dirty_bitmap, 0, n);
 
 		r = -ENOMEM;
 		slots = kzalloc(sizeof(struct kvm_memslots), GFP_KERNEL);
diff --git a/arch/x86/mm/pageattr-test.c b/arch/x86/mm/pageattr-test.c
index e1d1069..b008656 100644
--- a/arch/x86/mm/pageattr-test.c
+++ b/arch/x86/mm/pageattr-test.c
@@ -123,12 +123,11 @@ static int pageattr_test(void)
 	if (print)
 		printk(KERN_INFO "CPA self-test:\n");
 
-	bm = vmalloc((max_pfn_mapped + 7) / 8);
+	bm = vzalloc((max_pfn_mapped + 7) / 8);
 	if (!bm) {
 		printk(KERN_ERR "CPA Cannot vmalloc bitmap\n");
 		return -ENOMEM;
 	}
-	memset(bm, 0, (max_pfn_mapped + 7) / 8);
 
 	failed += print_split(&sa);
 	srandom32(100);
-- 
1.7.3.1.g432b3.dirty

