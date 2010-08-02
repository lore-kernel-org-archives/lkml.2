Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753122Ab0HBIQY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 04:16:24 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60214 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751255Ab0HBIQW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 04:16:22 -0400
Message-ID: <4C567DD8.5050101@cn.fujitsu.com>
Date: Mon, 02 Aug 2010 16:12:08 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
Subject: [PATCH v2 1/3] KVM: MMU: using kvm_set_pfn_accessed() instead of
 mark_page_accessed()
References: <4C4E5313.1080308@cn.fujitsu.com>
In-Reply-To: <4C4E5313.1080308@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's a small cleanup that using using kvm_set_pfn_accessed() instead
of mark_page_accessed()

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 56da796..f7b379a 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -313,7 +313,7 @@ static void update_spte(u64 *sptep, u64 new_spte)
 	else {
 		old_spte = __xchg_spte(sptep, new_spte);
 		if (old_spte & shadow_accessed_mask)
-			mark_page_accessed(pfn_to_page(spte_to_pfn(old_spte)));
+			kvm_set_pfn_accessed(spte_to_pfn(old_spte));
 	}
 }
 
-- 
1.6.1.2


