Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757149Ab0LML1D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 06:27:03 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:55893 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754677Ab0LML1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 06:27:00 -0500
Date: Mon, 13 Dec 2010 12:26:42 +0100
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCHv7 01/10] mm: migrate.c: fix compilation error
In-reply-to: <cover.1292004520.git.m.nazarewicz@samsung.com>
To: Michal Nazarewicz <mina86@mina86.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ankita Garg <ankita@in.ibm.com>,
        BooJin Kim <boojin.kim@samsung.com>,
        Daniel Walker <dwalker@codeaurora.org>,
        Johan MOSSBERG <johan.xx.mossberg@stericsson.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mel Gorman <mel@csn.ul.ie>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, linux-mm@kvack.org,
        Michal Nazarewicz <m.nazarewicz@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <86d353f4d141c83492cff9f946d382234aac3c77.1292004520.git.m.nazarewicz@samsung.com>
MIME-version: 1.0
X-Mailer: git-send-email 1.7.2.3
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <cover.1292004520.git.m.nazarewicz@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GCC complained about update_mmu_cache() not being defined
in migrate.c.  Including <asm/tlbflush.h> seems to solve the problem.

Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 mm/migrate.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index fe5a3c6..6ae8a66 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -35,6 +35,8 @@
 #include <linux/hugetlb.h>
 #include <linux/gfp.h>
 
+#include <asm/tlbflush.h>
+
 #include "internal.h"
 
 #define lru_to_page(_head) (list_entry((_head)->prev, struct page, lru))
-- 
1.7.2.3

