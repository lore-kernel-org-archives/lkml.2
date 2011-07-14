Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109Ab1GNJmK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 05:42:10 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:34316 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754034Ab1GNJmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 05:42:08 -0400
Date: Thu, 14 Jul 2011 11:42:03 +0200
From: Tejun Heo <tj@kernel.org>
To: mingo@redhat.com, hpa@zytor.com, tglx@linutronix.de,
        benh@kernel.crashing.org, yinghai@kernel.org, davem@davemloft.net
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, x86@kernel.org
Subject: [PATCH 2.5/13] memblock: Use __meminit[data] instead of __init[data]
Message-ID: <20110714094203.GE3455@htj.dyndns.org>
References: <1310462166-31469-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310462166-31469-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 19ab281ed67b87a6623d725237a7333ca79f1e75 Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Thu, 14 Jul 2011 11:22:16 +0200

memblock will be extended to include early_node_map[], which is also
used during memory hotplug.  Make memblock use __meminit[data] instead
of __init[data] so that memory hotplug code can safely reference it.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Yinghai Lu <yinghai@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 include/linux/memblock.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index aa5df9e..434b958 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -152,8 +152,8 @@ static inline unsigned long memblock_region_reserved_end_pfn(const struct memblo
 
 
 #ifdef ARCH_DISCARD_MEMBLOCK
-#define __init_memblock __init
-#define __initdata_memblock __initdata
+#define __init_memblock __meminit
+#define __initdata_memblock __meminitdata
 #else
 #define __init_memblock
 #define __initdata_memblock
-- 
1.7.6

