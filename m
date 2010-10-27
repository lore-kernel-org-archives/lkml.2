Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760714Ab0J0I7L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 04:59:11 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54679 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1760612Ab0J0I7I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 04:59:08 -0400
Message-ID: <4CC7EAE5.907@cn.fujitsu.com>
Date: Wed, 27 Oct 2010 17:03:33 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH 3/8] KVM: fix searching async gfn in kvm_async_pf_gfn_slot
References: <4CC7EA7D.5020901@cn.fujitsu.com>
In-Reply-To: <4CC7EA7D.5020901@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'gfn' is not recorded if the next slot is empty

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/x86.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7876ec8..16f42ff 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6207,8 +6207,8 @@ static u32 kvm_async_pf_gfn_slot(struct kvm_vcpu *vcpu, gfn_t gfn)
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

