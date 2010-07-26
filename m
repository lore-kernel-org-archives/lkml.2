Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752369Ab0GZFvd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 01:51:33 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50888 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751060Ab0GZFvb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 01:51:31 -0400
Message-ID: <4C4D216B.5040004@cn.fujitsu.com>
Date: Mon, 26 Jul 2010 13:47:23 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Avi Kivity <avi@qumranet.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        KVM list <kvm@vger.kernel.org>
Subject: [PATCH] KVM: fix compile warning
References: <20100726151405.2dfd20ee.sfr@canb.auug.org.au>
In-Reply-To: <20100726151405.2dfd20ee.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Stephen Rothwell wrote:
> Hi all,
> 
> After merging the kvm tree, today's linux-next build (x86_64
> allmodconfig) produced this warning:
> 
> arch/x86/kvm/mmu.c: In function 'kvm_mmu_pte_write':
> arch/x86/kvm/mmu.c:2908: warning: suggest parentheses around operand of '!' or change '&' to '&&' or '!' to '~'
> 
> Introduced by commit af8720393c71a8f81ade71c404798d80c68c5d73 ("KVM: MMU:
> add missing reserved bits check in speculative path").

Hi Stephen,

Thanks for your report, this patch can fix it.

Subject: [PATCH] KVM: fix compile warning

Fix:
arch/x86/kvm/mmu.c: In function 'kvm_mmu_pte_write':
arch/x86/kvm/mmu.c:2908: warning: suggest parentheses around operand of '!' or change '&' to '&&' or '!' to '~'

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 1a8f43f..0dcc95e 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2904,8 +2904,8 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 			entry = *spte;
 			mmu_pte_write_zap_pte(vcpu, sp, spte);
 			if (gentry &&
-			      !(sp->role.word ^ vcpu->arch.mmu.base_role.word)
-			      & mask.word)
+			      !((sp->role.word ^ vcpu->arch.mmu.base_role.word)
+			      & mask.word))
 				mmu_pte_write_new_pte(vcpu, sp, spte, &gentry);
 			if (!remote_flush && need_remote_flush(entry, *spte))
 				remote_flush = true;
-- 
1.6.5.2


