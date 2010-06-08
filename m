Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754910Ab0FHMIh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 08:08:37 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60042 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754317Ab0FHMIg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 08:08:36 -0400
Message-ID: <4C0E31F1.70803@cn.fujitsu.com>
Date: Tue, 08 Jun 2010 20:05:05 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: [PATCH 1/3] KVM: MMU: remove unnecessary remote tlb flush
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This remote tlb flush is no necessary since we have synced while
sp is zapped

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 6b2c644..959c248 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -3038,8 +3038,6 @@ restart:
 
 	kvm_mmu_commit_zap_page(kvm, &invalid_list);
 	spin_unlock(&kvm->mmu_lock);
-
-	kvm_flush_remote_tlbs(kvm);
 }
 
 static int kvm_mmu_remove_some_alloc_mmu_pages(struct kvm *kvm,
-- 
1.6.1.2

