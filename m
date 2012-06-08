Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760616Ab2FHOyq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 10:54:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59661 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755824Ab2FHOyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 10:54:44 -0400
Date: Fri, 8 Jun 2012 07:54:33 -0700
From: tip-bot for Stephen Boyd <sboyd@codeaurora.org>
Message-ID: <tip-eab309494ae2b9e15f85520f00de3893162c2e43@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tj@kernel.org, tglx@linutronix.de, sboyd@codeaurora.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tj@kernel.org, tglx@linutronix.de, sboyd@codeaurora.org
In-Reply-To: <1337845521-32755-1-git-send-email-sboyd@codeaurora.org>
References: <1337845521-32755-1-git-send-email-sboyd@codeaurora.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] memblock: Document memblock_is_region_{memory,
 reserved}()
Git-Commit-ID: eab309494ae2b9e15f85520f00de3893162c2e43
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 08 Jun 2012 07:54:39 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  eab309494ae2b9e15f85520f00de3893162c2e43
Gitweb:     http://git.kernel.org/tip/eab309494ae2b9e15f85520f00de3893162c2e43
Author:     Stephen Boyd <sboyd@codeaurora.org>
AuthorDate: Thu, 24 May 2012 00:45:21 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 8 Jun 2012 11:59:46 +0200

memblock: Document memblock_is_region_{memory,reserved}()

At first glance one would think that memblock_is_region_memory()
and memblock_is_region_reserved() would be implemented in the
same way. Unfortunately they aren't and the former returns
whether the region specified is a subset of a memory bank while
the latter returns whether the region specified intersects with
reserved memory.

Document the two functions so that users aren't tempted to
make the implementation the same between them and to clarify the
purpose of the functions.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Cc: Tejun Heo <tj@kernel.org>
Link: http://lkml.kernel.org/r/1337845521-32755-1-git-send-email-sboyd@codeaurora.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 mm/memblock.c |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index 952123e..32a0a5e 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -867,6 +867,16 @@ int __init_memblock memblock_is_memory(phys_addr_t addr)
 	return memblock_search(&memblock.memory, addr) != -1;
 }
 
+/**
+ * memblock_is_region_memory - check if a region is a subset of memory
+ * @base: base of region to check
+ * @size: size of region to check
+ *
+ * Check if the region [@base, @base+@size) is a subset of a memory block.
+ *
+ * RETURNS:
+ * 0 if false, non-zero if true
+ */
 int __init_memblock memblock_is_region_memory(phys_addr_t base, phys_addr_t size)
 {
 	int idx = memblock_search(&memblock.memory, base);
@@ -879,6 +889,16 @@ int __init_memblock memblock_is_region_memory(phys_addr_t base, phys_addr_t size
 		 memblock.memory.regions[idx].size) >= end;
 }
 
+/**
+ * memblock_is_region_reserved - check if a region intersects reserved memory
+ * @base: base of region to check
+ * @size: size of region to check
+ *
+ * Check if the region [@base, @base+@size) intersects a reserved memory block.
+ *
+ * RETURNS:
+ * 0 if false, non-zero if true
+ */
 int __init_memblock memblock_is_region_reserved(phys_addr_t base, phys_addr_t size)
 {
 	memblock_cap_size(base, &size);
