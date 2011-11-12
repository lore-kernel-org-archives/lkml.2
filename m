Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754297Ab1H2QnD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 12:43:03 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:56122 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754141Ab1H2Qme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 12:42:34 -0400
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>, Johannes Weiner <jweiner@redhat.com>,
        Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>
Subject: [PATCH 1/3] Correct isolate_mode_t bitwise type
Date: Sun, 13 Nov 2011 01:37:41 +0900
Message-Id: <e139175e938d94c0c977edd05ae07cbad7a72cc5.1321112552.git.minchan.kim@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <cover.1321112552.git.minchan.kim@gmail.com>
References: <cover.1321112552.git.minchan.kim@gmail.com>
In-Reply-To: <cover.1321112552.git.minchan.kim@gmail.com>
References: <cover.1321112552.git.minchan.kim@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[c1e8b0ae8, mm-change-isolate-mode-from-define-to-bitwise-type]
made a mistake on the bitwise type.

This patch corrects it.

CC: Mel Gorman <mgorman@suse.de>
CC: Johannes Weiner <jweiner@redhat.com>
CC: Rik van Riel <riel@redhat.com>
Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
---
 include/linux/mmzone.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 1ed4116..188cb2f 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -166,13 +166,13 @@ static inline int is_unevictable_lru(enum lru_list l)
 #define LRU_ALL	     ((1 << NR_LRU_LISTS) - 1)

 /* Isolate inactive pages */
-#define ISOLATE_INACTIVE	((__force fmode_t)0x1)
+#define ISOLATE_INACTIVE	((__force isolate_mode_t)0x1)
 /* Isolate active pages */
-#define ISOLATE_ACTIVE		((__force fmode_t)0x2)
+#define ISOLATE_ACTIVE		((__force isolate_mode_t)0x2)
 /* Isolate clean file */
-#define ISOLATE_CLEAN		((__force fmode_t)0x4)
+#define ISOLATE_CLEAN		((__force isolate_mode_t)0x4)
 /* Isolate unmapped file */
-#define ISOLATE_UNMAPPED	((__force fmode_t)0x8)
+#define ISOLATE_UNMAPPED	((__force isolate_mode_t)0x8)

 /* LRU Isolation modes. */
 typedef unsigned __bitwise__ isolate_mode_t;
--
1.7.6
