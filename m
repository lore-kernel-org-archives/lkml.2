Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378Ab0D1D62 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 23:58:28 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60025 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754792Ab0D1D6Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 23:58:24 -0400
Message-ID: <4BD7B1A3.8040802@cn.fujitsu.com>
Date: Wed, 28 Apr 2010 11:55:15 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 4/10] KVM MMU: cleanup invlpg code
References: <4BD7AE34.5000408@cn.fujitsu.com>
In-Reply-To: <4BD7AE34.5000408@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using is_last_spte() to cleanup invlpg code

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/paging_tmpl.h |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 3464fdb..89d66ca 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -474,9 +474,7 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva)
 		level = iterator.level;
 		sptep = iterator.sptep;
 
-		if (level == PT_PAGE_TABLE_LEVEL  ||
-		    ((level == PT_DIRECTORY_LEVEL && is_large_pte(*sptep))) ||
-		    ((level == PT_PDPE_LEVEL && is_large_pte(*sptep)))) {
+		if (is_last_spte(*sptep, level)) {
 			struct kvm_mmu_page *sp = page_header(__pa(sptep));
 			int offset, shift;
 
-- 
1.6.1.2



