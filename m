Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497Ab1JXHWq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 03:22:46 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:35170 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753326Ab1JXHWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 03:22:44 -0400
From: Zhao Jin <cronozhj@gmail.com>
To: avi@redhat.com, mtosatti@redhat.com
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH] KVM: MMU: fix the condition of syncing a new shadow page
Date: Mon, 24 Oct 2011 15:21:19 +0800
Message-Id: <1319440880-2610-2-git-send-email-cronozhj@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1319440880-2610-1-git-send-email-cronozhj@gmail.com>
References: <1319440880-2610-1-git-send-email-cronozhj@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Should be "or" since a new shadow page is synced if either it is
not leaf or there already exists another unsync shadow page with 
the same gfn.

Signed-off-by: Zhao Jin <cronozhj@gmail.com>
---
 arch/x86/kvm/mmu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index d7e1694..f36de41 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1698,7 +1698,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 	if (!direct) {
 		if (rmap_write_protect(vcpu->kvm, gfn))
 			kvm_flush_remote_tlbs(vcpu->kvm);
-		if (level > PT_PAGE_TABLE_LEVEL && need_sync)
+		if (level > PT_PAGE_TABLE_LEVEL || need_sync)
 			kvm_sync_pages(vcpu, gfn);
 
 		account_shadowed(vcpu->kvm, gfn);
-- 
1.7.5.4

