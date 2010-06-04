Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756044Ab0FDNzz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 09:55:55 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57597 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753357Ab0FDNzy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 09:55:54 -0400
Message-ID: <4C090511.60206@cn.fujitsu.com>
Date: Fri, 04 Jun 2010 21:52:17 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: [PATCH v2 1/7] KVM: MMU: skip invalid sp when unprotect page
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In kvm_mmu_unprotect_page(), the invalid sp can be skipped

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index a62e3ba..e962f26 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1629,7 +1629,7 @@ static int kvm_mmu_unprotect_page(struct kvm *kvm, gfn_t gfn)
 	bucket = &kvm->arch.mmu_page_hash[index];
 restart:
 	hlist_for_each_entry_safe(sp, node, n, bucket, hash_link)
-		if (sp->gfn == gfn && !sp->role.direct) {
+		if (sp->gfn == gfn && !sp->role.direct && !sp->role.invalid) {
 			pgprintk("%s: gfn %lx role %x\n", __func__, gfn,
 				 sp->role.word);
 			r = 1;
-- 
1.6.1.2

