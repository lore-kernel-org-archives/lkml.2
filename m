Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932502Ab1GNVcl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 17:32:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:33964 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932344Ab1GNVcj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 17:32:39 -0400
Date: Thu, 14 Jul 2011 21:32:30 GMT
From: tip-bot for Tejun Heo <tj@kernel.org>
Message-ID: <tip-67e24bcb725cabd15ef577bf301275d03d6086d7@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        benh@kernel.crashing.org, yinghai@kernel.org, tj@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, benh@kernel.crashing.org, tj@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <20110714094203.GE3455@htj.dyndns.org>
References: <20110714094203.GE3455@htj.dyndns.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/memblock] memblock: Use __meminit[data] instead of __init[data]
Git-Commit-ID: 67e24bcb725cabd15ef577bf301275d03d6086d7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 14 Jul 2011 21:32:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  67e24bcb725cabd15ef577bf301275d03d6086d7
Gitweb:     http://git.kernel.org/tip/67e24bcb725cabd15ef577bf301275d03d6086d7
Author:     Tejun Heo <tj@kernel.org>
AuthorDate: Thu, 14 Jul 2011 11:42:03 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 14 Jul 2011 11:47:42 -0700

memblock: Use __meminit[data] instead of __init[data]

>From 19ab281ed67b87a6623d725237a7333ca79f1e75 Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Thu, 14 Jul 2011 11:22:16 +0200

memblock will be extended to include early_node_map[], which is also
used during memory hotplug.  Make memblock use __meminit[data] instead
of __init[data] so that memory hotplug code can safely reference it.

Signed-off-by: Tejun Heo <tj@kernel.org>
Link: http://lkml.kernel.org/r/20110714094203.GE3455@htj.dyndns.org
Reported-by: Yinghai Lu <yinghai@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
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
