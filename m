Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751223Ab2AQCeT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 21:34:19 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:48090 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758Ab2AQCeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 21:34:18 -0500
X-AuditID: 9c93016f-b7c20ae000005067-e2-4f14de26d180
From: Namhyung Kim <namhyung.kim@lge.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Namhyung Kim <namhyung@gmail.com>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] PM / Hibernate: Correct additional page calculation
Date: Tue, 17 Jan 2012 11:43:09 +0900
Message-Id: <1326768189-13074-1-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.9.rc1.dirty
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The struct bm_block is allocated by chain_alloc(),
so it'd better counting it in LINKED_PAGE_DATA_SIZE.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
---
 kernel/power/snapshot.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index cbe2c1441392..7196d3c023e1 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -812,7 +812,8 @@ unsigned int snapshot_additional_pages(struct zone *zone)
 	unsigned int res;
 
 	res = DIV_ROUND_UP(zone->spanned_pages, BM_BITS_PER_BLOCK);
-	res += DIV_ROUND_UP(res * sizeof(struct bm_block), PAGE_SIZE);
+	res += DIV_ROUND_UP(res * sizeof(struct bm_block),
+			    LINKED_PAGE_DATA_SIZE);
 	return 2 * res;
 }
 
-- 
1.7.9.rc1.dirty

