Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756332Ab1GBVzd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 17:55:33 -0400
Received: from 87-119-183-111.tll.elisa.ee ([87.119.183.111]:48206 "EHLO
	bazspaz.fatphil.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755180Ab1GBVz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 17:55:28 -0400
From: Phil Carmody <ext-phil.2.carmody@nokia.com>
To: trivial@kernel.org
Cc: ext-phil.2.carmody@nokia.com, linux-kernel@vger.kernel.org
Subject: [PATCH 6/7] nommu: there is no CONFIG_SMALL_TASKS
Date: Sun,  3 Jul 2011 00:47:51 +0300
Message-Id: <1309643272-364-7-git-send-email-ext-phil.2.carmody@nokia.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1309643272-364-6-git-send-email-ext-phil.2.carmody@nokia.com>
References: <1309643272-364-1-git-send-email-ext-phil.2.carmody@nokia.com>
 <1309643272-364-2-git-send-email-ext-phil.2.carmody@nokia.com>
 <1309643272-364-3-git-send-email-ext-phil.2.carmody@nokia.com>
 <1309643272-364-4-git-send-email-ext-phil.2.carmody@nokia.com>
 <1309643272-364-5-git-send-email-ext-phil.2.carmody@nokia.com>
 <1309643272-364-6-git-send-email-ext-phil.2.carmody@nokia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So this is dead code. That, and it appears KTHREAD_SIZE
isn't used anywhere else in the kernel, so purging the
whole if/else.

Part of a shotgun patchset; found by greps, seds, and diffs
rather than actual understanding.

Signed-off-by: Phil Carmody <ext-phil.2.carmody@nokia.com>
---
 arch/arm/include/asm/page-nommu.h |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/arch/arm/include/asm/page-nommu.h b/arch/arm/include/asm/page-nommu.h
index d1b162a..58da8b2 100644
--- a/arch/arm/include/asm/page-nommu.h
+++ b/arch/arm/include/asm/page-nommu.h
@@ -11,12 +11,6 @@
 #ifndef _ASMARM_PAGE_NOMMU_H
 #define _ASMARM_PAGE_NOMMU_H
 
-#if !defined(CONFIG_SMALL_TASKS) && PAGE_SHIFT < 13
-#define KTHREAD_SIZE (8192)
-#else
-#define KTHREAD_SIZE PAGE_SIZE
-#endif
- 
 #define get_user_page(vaddr)		__get_free_page(GFP_KERNEL)
 #define free_user_page(page, addr)	free_page(addr)
 
-- 
1.7.2.5

