Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987Ab0FPFoT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 01:44:19 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:26351 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754829Ab0FPFoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 01:44:16 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 02/37] lmb: Prepare x86 to use lmb to replace early_res
Date: Tue, 15 Jun 2010 22:42:11 -0700
Message-Id: <1276666966-14259-3-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1276666966-14259-1-git-send-email-yinghai@kernel.org>
References: <1276666966-14259-1-git-send-email-yinghai@kernel.org>
X-Auth-Type: Internal IP
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-CT-RefId: str=0001.0A090207.4C186497.01EE,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. expose lmb_debug
2. expose lmb_reserved_init_regions

-v2: drop lmb_add_region() and LMB_ERROR export
-v3: seperate wrong return of lmb_fin_base to another patch
-v4: expose lmb_can_resize to handle x86 EFI that could have more than
      128 entries

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 include/linux/lmb.h |    3 +++
 lib/lmb.c           |    5 +++--
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/include/linux/lmb.h b/include/linux/lmb.h
index 6f8c4bd..1e96224 100644
--- a/include/linux/lmb.h
+++ b/include/linux/lmb.h
@@ -39,6 +39,9 @@ struct lmb {
 };
 
 extern struct lmb lmb;
+extern int lmb_debug;
+extern int lmb_can_resize;
+extern struct lmb_region lmb_reserved_init_regions[];
 
 extern void __init lmb_init(void);
 extern void __init lmb_analyze(void);
diff --git a/lib/lmb.c b/lib/lmb.c
index 13d1a04..bbdb1ec 100644
--- a/lib/lmb.c
+++ b/lib/lmb.c
@@ -22,9 +22,10 @@
 
 struct lmb lmb;
 
-static int lmb_debug, lmb_can_resize;
+int lmb_debug;
+int lmb_can_resize;
 static struct lmb_region lmb_memory_init_regions[INIT_LMB_REGIONS + 1];
-static struct lmb_region lmb_reserved_init_regions[INIT_LMB_REGIONS + 1];
+struct lmb_region lmb_reserved_init_regions[INIT_LMB_REGIONS + 1];
 
 #define LMB_ERROR	(~(phys_addr_t)0)
 
-- 
1.6.4.2

