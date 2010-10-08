Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031Ab0JHHTe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 03:19:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:37304 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752743Ab0JHHTd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 03:19:33 -0400
Date: Fri, 8 Oct 2010 07:18:57 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        yinghai@kernel.org, balbi@ti.com, khilman@deeprootsystems.com,
        tomi.valkeinen@nokia.com, notasas@gmail.com, benh@kernel.crashing.org,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, balbi@ti.com, khilman@deeprootsystems.com,
        tomi.valkeinen@nokia.com, notasas@gmail.com, benh@kernel.crashing.org,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4CABFADA.9020305@kernel.org>
References: <4CABFADA.9020305@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/memblock] memblock/arm: Fix memblock_region_is_memory() typo
Message-ID: <tip-5fd03ddab7fdbc44bfb2d183a4531c26a8dbca5a@git.kernel.org>
Git-Commit-ID: 5fd03ddab7fdbc44bfb2d183a4531c26a8dbca5a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 08 Oct 2010 07:19:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5fd03ddab7fdbc44bfb2d183a4531c26a8dbca5a
Gitweb:     http://git.kernel.org/tip/5fd03ddab7fdbc44bfb2d183a4531c26a8dbca5a
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Tue, 5 Oct 2010 21:28:10 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 8 Oct 2010 09:14:36 +0200

memblock/arm: Fix memblock_region_is_memory() typo

Fix typo in commit dbe3039 ("memblock/arm: Use memblock_region_is_memory()
for omap fb") - it should be memblock_is_region_memory().

Reported-by: Tomi Valkeinen <tomi.valkeinen@nokia.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Felipe Balbi <balbi@ti.com>
Cc: Kevin Hilman <khilman@deeprootsystems.com>
Cc: ext Grazvydas Ignotas <notasas@gmail.com>
LKML-Reference: <4CABFADA.9020305@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/arm/plat-omap/fb.c    |    2 +-
 drivers/video/omap2/vram.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/plat-omap/fb.c b/arch/arm/plat-omap/fb.c
index 441af2b..7193481 100644
--- a/arch/arm/plat-omap/fb.c
+++ b/arch/arm/plat-omap/fb.c
@@ -173,7 +173,7 @@ static int check_fbmem_region(int region_idx, struct omapfb_mem_region *rg,
 
 static int valid_sdram(unsigned long addr, unsigned long size)
 {
-	return memblock_region_is_memory(addr, size);
+	return memblock_is_region_memory(addr, size);
 }
 
 static int reserve_sdram(unsigned long addr, unsigned long size)
diff --git a/drivers/video/omap2/vram.c b/drivers/video/omap2/vram.c
index 34514a8..fed2a72 100644
--- a/drivers/video/omap2/vram.c
+++ b/drivers/video/omap2/vram.c
@@ -555,7 +555,7 @@ void __init omap_vram_reserve_sdram_memblock(void)
 
 	if (paddr) {
 		if ((paddr & ~PAGE_MASK) ||
-		    !memblock_region_is_memory(paddr, size)) {
+		    !memblock_is_region_memory(paddr, size)) {
 			pr_err("Illegal SDRAM region for VRAM\n");
 			return;
 		}
