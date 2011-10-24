Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447Ab1JXHWm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 03:22:42 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:35170 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753326Ab1JXHWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 03:22:41 -0400
From: Zhao Jin <cronozhj@gmail.com>
To: avi@redhat.com, mtosatti@redhat.com
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH] KVM: MMU: initialize sptes early
Date: Mon, 24 Oct 2011 15:21:18 +0800
Message-Id: <1319440880-2610-1-git-send-email-cronozhj@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Otherwise, the following kvm_sync_pages() will see invalid sptes in a new
shadow page.

Signed-off-by: Zhao Jin <cronozhj@gmail.com>
---
 arch/x86/kvm/mmu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 8e8da79..d7e1694 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1692,6 +1692,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 		return sp;
 	sp->gfn = gfn;
 	sp->role = role;
+	init_shadow_page_table(sp);
 	hlist_add_head(&sp->hash_link,
 		&vcpu->kvm->arch.mmu_page_hash[kvm_page_table_hashfn(gfn)]);
 	if (!direct) {
@@ -1702,7 +1703,6 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 
 		account_shadowed(vcpu->kvm, gfn);
 	}
-	init_shadow_page_table(sp);
 	trace_kvm_mmu_get_page(sp, true);
 	return sp;
 }
-- 
1.7.5.4

