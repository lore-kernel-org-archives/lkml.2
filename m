Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622Ab1G0LKH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 07:10:07 -0400
Received: from relay.parallels.com ([195.214.232.42]:59268 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754542Ab1G0LKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 07:10:05 -0400
Subject: [PATCH RFC] mm: reverse lru scanning order
To: <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Date: Wed, 27 Jul 2011 15:10:02 +0400
Message-ID: <20110727111002.9985.94938.stgit@localhost6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LRU scanning order was accidentially changed in commit v2.6.27-5584-gb69408e:
"vmscan: Use an indexed array for LRU variables".
Before that commit reclaimer always scan active lists first.

This patch just reverse it back.
This is just notice and question: "Does it affect something?"

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
---
 include/linux/mmzone.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index be1ac8d..88fb49c 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -141,7 +141,8 @@ enum lru_list {
 
 #define for_each_lru(l) for (l = 0; l < NR_LRU_LISTS; l++)
 
-#define for_each_evictable_lru(l) for (l = 0; l <= LRU_ACTIVE_FILE; l++)
+#define for_each_evictable_lru(l) \
+	for (l = LRU_ACTIVE_FILE; l >= LRU_INACTIVE_ANON; l--)
 
 static inline int is_file_lru(enum lru_list l)
 {

