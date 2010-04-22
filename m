Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752633Ab0DVGQI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 02:16:08 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:65480 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752516Ab0DVGQB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 02:16:01 -0400
Message-ID: <4BCFE8E8.8000609@cn.fujitsu.com>
Date: Thu, 22 Apr 2010 14:12:56 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/10] KVM MMU: cleanup invlpg code
References: <4BCFE581.8050305@cn.fujitsu.com>
In-Reply-To: <4BCFE581.8050305@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using is_last_spte() to cleanup invlpg code

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index fac7c09..fd027a6 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2271,9 +2271,7 @@ static void paging_invlpg(struct kvm_vcpu *vcpu, gva_t gva)
 		level = iterator.level;
 		sptep = iterator.sptep;
 
-		if (level == PT_PAGE_TABLE_LEVEL  ||
-		    ((level == PT_DIRECTORY_LEVEL && is_large_pte(*sptep))) ||
-		    ((level == PT_PDPE_LEVEL && is_large_pte(*sptep)))) {
+		if (is_last_spte(*sptep, level)) {
 			struct kvm_mmu_page *sp = page_header(__pa(sptep));
 			int offset = 0;
 
-- 
1.6.1.2


