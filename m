Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757316Ab0EMCKS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 22:10:18 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57647 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755776Ab0EMCKN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 22:10:13 -0400
Message-ID: <4BEB5EC4.6070802@cn.fujitsu.com>
Date: Thu, 13 May 2010 10:07:00 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/5] KVM MMU: remove rmap before clear spte
References: <4BEB5E8A.7030606@cn.fujitsu.com>
In-Reply-To: <4BEB5E8A.7030606@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove rmap before clear spte otherwise it will trigger BUG_ON() in
some functions such as rmap_write_protect()

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 67da751..a474d93 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1812,6 +1812,7 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 		if (level > PT_PAGE_TABLE_LEVEL &&
 		    has_wrprotected_page(vcpu->kvm, gfn, level)) {
 			ret = 1;
+			rmap_remove(vcpu->kvm, sptep);
 			spte = shadow_trap_nonpresent_pte;
 			goto set_pte;
 		}
-- 
1.6.1.2


