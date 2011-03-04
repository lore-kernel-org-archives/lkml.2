Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759498Ab1CDLAq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 06:00:46 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:61578 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752084Ab1CDLAo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 06:00:44 -0500
Message-ID: <4D70C693.4060405@cn.fujitsu.com>
Date: Fri, 04 Mar 2011 19:01:39 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH 9/10] KVM: MMU: remove unused macros
References: <4D70C569.1030107@cn.fujitsu.com>
In-Reply-To: <4D70C569.1030107@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-04 18:59:32,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-04 18:59:33,
	Serialize complete at 2011-03-04 18:59:33
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These macros are not used, so removed

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c         |    5 -----
 arch/x86/kvm/paging_tmpl.h |    3 ---
 2 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 7d558b8..54a2ead 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -111,9 +111,6 @@ module_param(oos_shadow, bool, 0644);
 #define PT64_LEVEL_SHIFT(level) \
 		(PAGE_SHIFT + (level - 1) * PT64_LEVEL_BITS)
 
-#define PT64_LEVEL_MASK(level) \
-		(((1ULL << PT64_LEVEL_BITS) - 1) << PT64_LEVEL_SHIFT(level))
-
 #define PT64_INDEX(address, level)\
 	(((address) >> PT64_LEVEL_SHIFT(level)) & ((1 << PT64_LEVEL_BITS) - 1))
 
@@ -123,8 +120,6 @@ module_param(oos_shadow, bool, 0644);
 #define PT32_LEVEL_SHIFT(level) \
 		(PAGE_SHIFT + (level - 1) * PT32_LEVEL_BITS)
 
-#define PT32_LEVEL_MASK(level) \
-		(((1ULL << PT32_LEVEL_BITS) - 1) << PT32_LEVEL_SHIFT(level))
 #define PT32_LVL_OFFSET_MASK(level) \
 	(PT32_BASE_ADDR_MASK & ((1ULL << (PAGE_SHIFT + (((level) - 1) \
 						* PT32_LEVEL_BITS))) - 1))
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index b3862ee..86eb816 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -31,7 +31,6 @@
 	#define PT_LVL_ADDR_MASK(lvl) PT64_LVL_ADDR_MASK(lvl)
 	#define PT_LVL_OFFSET_MASK(lvl) PT64_LVL_OFFSET_MASK(lvl)
 	#define PT_INDEX(addr, level) PT64_INDEX(addr, level)
-	#define PT_LEVEL_MASK(level) PT64_LEVEL_MASK(level)
 	#define PT_LEVEL_BITS PT64_LEVEL_BITS
 	#ifdef CONFIG_X86_64
 	#define PT_MAX_FULL_LEVELS 4
@@ -48,7 +47,6 @@
 	#define PT_LVL_ADDR_MASK(lvl) PT32_LVL_ADDR_MASK(lvl)
 	#define PT_LVL_OFFSET_MASK(lvl) PT32_LVL_OFFSET_MASK(lvl)
 	#define PT_INDEX(addr, level) PT32_INDEX(addr, level)
-	#define PT_LEVEL_MASK(level) PT32_LEVEL_MASK(level)
 	#define PT_LEVEL_BITS PT32_LEVEL_BITS
 	#define PT_MAX_FULL_LEVELS 2
 	#define CMPXCHG cmpxchg
@@ -827,7 +825,6 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 #undef FNAME
 #undef PT_BASE_ADDR_MASK
 #undef PT_INDEX
-#undef PT_LEVEL_MASK
 #undef PT_LVL_ADDR_MASK
 #undef PT_LVL_OFFSET_MASK
 #undef PT_LEVEL_BITS
-- 
1.7.4

