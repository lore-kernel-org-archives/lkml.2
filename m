Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897Ab0KAI4K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 04:56:10 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61285 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752557Ab0KAI4J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 04:56:09 -0400
Message-ID: <4CCE81AE.2010600@cn.fujitsu.com>
Date: Mon, 01 Nov 2010 17:00:30 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH v2 3/7] KVM: fix searching async gfn in kvm_async_pf_gfn_slot
References: <4CCE8143.3090105@cn.fujitsu.com>
In-Reply-To: <4CCE8143.3090105@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't search later slots if the slot is empty

Acked-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/x86.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2cfdf2d..9b543f4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6206,8 +6206,8 @@ static u32 kvm_async_pf_gfn_slot(struct kvm_vcpu *vcpu, gfn_t gfn)
 	u32 key = kvm_async_pf_hash_fn(gfn);
 
 	for (i = 0; i < roundup_pow_of_two(ASYNC_PF_PER_VCPU) &&
-		     (vcpu->arch.apf.gfns[key] != gfn ||
-		      vcpu->arch.apf.gfns[key] == ~0); i++)
+		     (vcpu->arch.apf.gfns[key] != gfn &&
+		      vcpu->arch.apf.gfns[key] != ~0); i++)
 		key = kvm_async_pf_next_probe(key);
 
 	return key;
-- 
1.7.0.4

