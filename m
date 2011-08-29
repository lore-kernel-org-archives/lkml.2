Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755544Ab1H2XXo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 19:23:44 -0400
Received: from mga02.intel.com ([134.134.136.20]:45603 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755414Ab1H2XX2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 19:23:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="43424142"
From: Andi Kleen <andi@firstfloor.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        viro@zeniv.linux.org.uk, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 09/11] DIO: Remove unused dio parameter from dio_bio_add_page
Date: Mon, 29 Aug 2011 16:23:20 -0700
Message-Id: <1314660202-661-10-git-send-email-andi@firstfloor.org>
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
 fs/direct-io.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/direct-io.c b/fs/direct-io.c
index 3f5d1b4..03bcc6f 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -657,7 +657,7 @@ out:
  *
  * Return zero on success.  Non-zero means the caller needs to start a new BIO.
  */
-static inline int dio_bio_add_page(struct dio *dio, struct dio_submit *sdio)
+static inline int dio_bio_add_page(struct dio_submit *sdio)
 {
 	int ret;
 
@@ -730,11 +730,11 @@ static inline int dio_send_cur_page(struct dio *dio, struct dio_submit *sdio,
 			goto out;
 	}
 
-	if (dio_bio_add_page(dio, sdio) != 0) {
+	if (dio_bio_add_page(sdio) != 0) {
 		dio_bio_submit(dio, sdio);
 		ret = dio_new_bio(dio, sdio, sdio->cur_page_block, map_bh);
 		if (ret == 0) {
-			ret = dio_bio_add_page(dio, sdio);
+			ret = dio_bio_add_page(sdio);
 			BUG_ON(ret != 0);
 		}
 	}
-- 
1.7.4.4

