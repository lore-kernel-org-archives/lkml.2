Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756952Ab2EHPzX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 11:55:23 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62138 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755595Ab2EHPzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 11:55:22 -0400
From: Sasha Levin <levinsasha928@gmail.com>
To: kay@vrfy.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        isdn@linux-pingi.de, akpm@linux-foundation.org
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Sasha Levin <levinsasha928@gmail.com>
Subject: [PATCH 1/4] mm: add missing KERN_CONT to free_area_init_nodes
Date: Tue,  8 May 2012 17:56:10 +0200
Message-Id: <1336492573-17530-1-git-send-email-levinsasha928@gmail.com>
X-Mailer: git-send-email 1.7.8.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix this behaviour:

Zone ranges:
  DMA
[mem 0x00010000-0x00ffffff]
  DMA32
[mem 0x01000000-0xffffffff]
  Normal
empty

Revealed due to a new modification to printk().

Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
---
 mm/page_alloc.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 29066fd..b252ae3 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4826,9 +4826,9 @@ void __init free_area_init_nodes(unsigned long *max_zone_pfn)
 		printk("  %-8s ", zone_names[i]);
 		if (arch_zone_lowest_possible_pfn[i] ==
 				arch_zone_highest_possible_pfn[i])
-			printk("empty\n");
+			printk(KERN_CONT "empty\n");
 		else
-			printk("[mem %0#10lx-%0#10lx]\n",
+			printk(KERN_CONT "[mem %0#10lx-%0#10lx]\n",
 				arch_zone_lowest_possible_pfn[i] << PAGE_SHIFT,
 				(arch_zone_highest_possible_pfn[i]
 					<< PAGE_SHIFT) - 1);
-- 
1.7.8.5

