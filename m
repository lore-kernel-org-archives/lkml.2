Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899Ab1K1Tcz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 14:32:55 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57739 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754815Ab1K1Tcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 14:32:52 -0500
From: Tejun Heo <tj@kernel.org>
To: benh@kernel.crashing.org, yinghai@kernel.org, hpa@zytor.com,
        tony.luck@intel.com, ralf@linux-mips.org, schwidefsky@de.ibm.com,
        liqin.chen@sunplusct.com, lethal@linux-sh.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        mingo@redhat.com, jonas@southpole.se, lennox.wu@gmail.com
Cc: Tejun Heo <tj@kernel.org>, linux-sh@vger.kernel.org
Subject: [PATCH 17/23] SuperH: Use HAVE_MEMBLOCK_NODE_MAP
Date: Mon, 28 Nov 2011 11:31:19 -0800
Message-Id: <1322508685-32532-18-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1322508685-32532-1-git-send-email-tj@kernel.org>
References: <1322508685-32532-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sh doesn't access early_node_map[] directly and enabling
HAVE_MEMBLOCK_NODE_MAP is trivial - replacing add_active_range() calls
with memblock_set_node() and selecting HAVE_MEMBLOCK_NODE_MAP is
enough.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: linux-sh@vger.kernel.org
---
 arch/sh/Kconfig        |    1 +
 arch/sh/kernel/setup.c |    3 ++-
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index 5629e20..47a2f1c 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -4,6 +4,7 @@ config SUPERH
 	select CLKDEV_LOOKUP
 	select HAVE_IDE if HAS_IOPORT
 	select HAVE_MEMBLOCK
+	select HAVE_MEMBLOCK_NODE_MAP
 	select HAVE_OPROFILE
 	select HAVE_GENERIC_DMA_COHERENT
 	select HAVE_ARCH_TRACEHOOK
diff --git a/arch/sh/kernel/setup.c b/arch/sh/kernel/setup.c
index 1a0e946..7b57bf1 100644
--- a/arch/sh/kernel/setup.c
+++ b/arch/sh/kernel/setup.c
@@ -230,7 +230,8 @@ void __init __add_active_range(unsigned int nid, unsigned long start_pfn,
 	pmb_bolt_mapping((unsigned long)__va(start), start, end - start,
 			 PAGE_KERNEL);
 
-	add_active_range(nid, start_pfn, end_pfn);
+	memblock_set_node(PFN_PHYS(start_pfn),
+			  PFN_PHYS(end_pfn - start_pfn), nid);
 }
 
 void __init __weak plat_early_device_setup(void)
-- 
1.7.3.1

