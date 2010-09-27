Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933016Ab0I0KAg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 06:00:36 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63675 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932633Ab0I0KAf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 06:00:35 -0400
Message-ID: <4CA06C4C.1070000@cn.fujitsu.com>
Date: Mon, 27 Sep 2010 18:05:00 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH 3/7] KVM: MMU: set access bit for direct mapping
References: <4CA06BA4.4090303@cn.fujitsu.com>
In-Reply-To: <4CA06BA4.4090303@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set access bit while setup up direct page table if it's nonpaing or npt enabled,
it's good for CPU's speculate access

Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 3630046..88203fa 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2240,7 +2240,8 @@ static int __direct_map(struct kvm_vcpu *vcpu, gpa_t v, int write,
 			__set_spte(iterator.sptep,
 				   __pa(sp->spt)
 				   | PT_PRESENT_MASK | PT_WRITABLE_MASK
-				   | shadow_user_mask | shadow_x_mask);
+				   | shadow_user_mask | shadow_x_mask
+				   | shadow_accessed_mask);
 		}
 	}
 	return pt_write;
-- 
1.7.0.4

