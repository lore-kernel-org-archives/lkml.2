Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753352Ab2H2DVt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 23:21:49 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:11324 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752875Ab2H2DVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 23:21:48 -0400
From: T Makphaibulchoke <tmac@hp.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        akpm@linux-foundation.org, yinghai@kernel.org, tiwai@suse.de,
        dhowells@redhat.com, linux-kernel@vger.kernel.org
Cc: T Makphaibulchoke <tmac@hp.com>
Subject: [PATCH] x86/mm/init.c: devmem_is_allowed() off by one
Date: Tue, 28 Aug 2012 21:21:43 -0600
Message-Id: <1346210503-14276-1-git-send-email-tmac@hp.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixing an off-by-one error in devmem_is_allowed(), which allows accesses to
physical addresses 0x100000-0x100fff, an extra page past 1MB.

Signed-off-by: T Makphaibulchoke <tmac@hp.com>
---
 arch/x86/mm/init.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index e0e6990..ab1f6a9 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -319,7 +319,7 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
  */
 int devmem_is_allowed(unsigned long pagenr)
 {
-	if (pagenr <= 256)
+	if (pagenr < 256)
 		return 1;
 	if (iomem_is_exclusive(pagenr << PAGE_SHIFT))
 		return 0;
-- 
1.7.1

