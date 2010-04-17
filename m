Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755411Ab0DQJCF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Apr 2010 05:02:05 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55363 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755142Ab0DQJCB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Apr 2010 05:02:01 -0400
Message-ID: <4BC9790F.1070403@cn.fujitsu.com>
Date: Sat, 17 Apr 2010 17:02:07 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org
Subject: [PATCH] kvm: don not fail when cache is sufficient
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


cleanup: don not fail when cache is sufficient

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index c8c074c..90f666e 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -304,7 +304,7 @@ static int mmu_topup_memory_cache(struct kvm_mmu_memory_cache *cache,
 	while (cache->nobjs < ARRAY_SIZE(cache->objects)) {
 		obj = kmem_cache_zalloc(base_cache, GFP_KERNEL);
 		if (!obj)
-			return -ENOMEM;
+			return cache->nobjs >= min ? 0 : -ENOMEM;
 		cache->objects[cache->nobjs++] = obj;
 	}
 	return 0;
@@ -326,7 +326,7 @@ static int mmu_topup_memory_cache_page(struct kvm_mmu_memory_cache *cache,
 	while (cache->nobjs < ARRAY_SIZE(cache->objects)) {
 		page = alloc_page(GFP_KERNEL);
 		if (!page)
-			return -ENOMEM;
+			return  cache->nobjs >= min ? 0 : -ENOMEM;
 		set_page_private(page, 0);
 		cache->objects[cache->nobjs++] = page_address(page);
 	}

