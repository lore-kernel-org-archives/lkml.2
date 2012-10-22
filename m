Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752366Ab2JVIO0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 04:14:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57524 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752303Ab2JVIOY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 04:14:24 -0400
Date: Mon, 22 Oct 2012 09:06:55 +0100
From: Mel Gorman <mgorman@suse.de>
To: Linux-MM <linux-mm@kvack.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/5] mm: autonuma: Specify the migration reason for the
 tracepoint
Message-ID: <20121022080655.GD2198@suse.de>
References: <1350892791-2682-1-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1350892791-2682-1-git-send-email-mgorman@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Record in the migrate_pages tracepoint that the migration is for
AutoNUMA.

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 include/linux/migrate.h        |    1 +
 include/trace/events/migrate.h |    1 +
 mm/autonuma.c                  |    3 ++-
 3 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/include/linux/migrate.h b/include/linux/migrate.h
index 9d1c159..ba17e56 100644
--- a/include/linux/migrate.h
+++ b/include/linux/migrate.h
@@ -13,6 +13,7 @@ enum migrate_reason {
 	MR_MEMORY_HOTPLUG,
 	MR_SYSCALL,		/* also applies to cpusets */
 	MR_MEMPOLICY_MBIND,
+	MR_AUTONUMA,
 	MR_CMA
 };
 
diff --git a/include/trace/events/migrate.h b/include/trace/events/migrate.h
index ec2a6cc..2eaaf90 100644
--- a/include/trace/events/migrate.h
+++ b/include/trace/events/migrate.h
@@ -15,6 +15,7 @@
 	{MR_MEMORY_HOTPLUG,	"memory_hotplug"},		\
 	{MR_SYSCALL,		"syscall_or_cpuset"},		\
 	{MR_MEMPOLICY_MBIND,	"mempolicy_mbind"},		\
+	{MR_AUTONUMA,		"autonuma"},			\
 	{MR_CMA,		"cma"}
 
 TRACE_EVENT(mm_migrate_pages,
diff --git a/mm/autonuma.c b/mm/autonuma.c
index 4db53a1..cb02641 100644
--- a/mm/autonuma.c
+++ b/mm/autonuma.c
@@ -249,7 +249,8 @@ static bool autonuma_migrate_page(struct page *page, int dst_nid,
 		pages_migrated += isolated; /* FIXME: per node */
 		nr_remaining = migrate_pages(&migratepages,
 				    alloc_migrate_dst_page,
-				    pgdat->node_id, false, MIGRATE_ASYNC);
+				    pgdat->node_id, false, MIGRATE_ASYNC,
+				    MR_AUTONUMA);
 		count_vm_events(NUMA_PAGE_MIGRATE, isolated - nr_remaining);
 		if (nr_remaining)
 			putback_lru_pages(&migratepages);
-- 
1.7.7

