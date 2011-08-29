Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755629Ab1H2X0H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 19:26:07 -0400
Received: from mga02.intel.com ([134.134.136.20]:24129 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755450Ab1H2XX3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 19:23:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="43424141"
From: Andi Kleen <andi@firstfloor.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        viro@zeniv.linux.org.uk, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 08/11] DIO: Remove unnecessary dio argument from dio_pages_present()
Date: Mon, 29 Aug 2011 16:23:19 -0700
Message-Id: <1314660202-661-9-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1314660202-661-1-git-send-email-andi@firstfloor.org>
References: <1314660202-661-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Acked-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 fs/direct-io.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/direct-io.c b/fs/direct-io.c
index 669b667..3f5d1b4 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -191,7 +191,7 @@ EXPORT_SYMBOL_GPL(inode_dio_done);
 /*
  * How many pages are in the queue?
  */
-static inline unsigned dio_pages_present(struct dio *dio, struct dio_submit *sdio)
+static inline unsigned dio_pages_present(struct dio_submit *sdio)
 {
 	return sdio->tail - sdio->head;
 }
@@ -247,13 +247,13 @@ out:
  */
 static inline struct page *dio_get_page(struct dio *dio, struct dio_submit *sdio)
 {
-	if (dio_pages_present(dio, sdio) == 0) {
+	if (dio_pages_present(sdio) == 0) {
 		int ret;
 
 		ret = dio_refill_pages(dio, sdio);
 		if (ret)
 			return ERR_PTR(ret);
-		BUG_ON(dio_pages_present(dio, sdio) == 0);
+		BUG_ON(dio_pages_present(sdio) == 0);
 	}
 	return dio->pages[sdio->head++];
 }
@@ -437,7 +437,7 @@ static inline void dio_bio_submit(struct dio *dio, struct dio_submit *sdio)
  */
 static inline void dio_cleanup(struct dio *dio, struct dio_submit *sdio)
 {
-	while (dio_pages_present(dio, sdio))
+	while (dio_pages_present(sdio))
 		page_cache_release(dio_get_page(dio, sdio));
 }
 
-- 
1.7.4.4

