Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759644Ab2FAM0j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 08:26:39 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41377 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759630Ab2FAM0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 08:26:36 -0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Pekka Enberg <penberg@kernel.org>
Cc: Leonid Moiseichuk <leonid.moiseichuk@nokia.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Minchan Kim <minchan@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        John Stultz <john.stultz@linaro.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Subject: [PATCH 5/5] vmevent: Rename one-shot mode to edge trigger mode
Date: Fri,  1 Jun 2012 05:24:06 -0700
Message-Id: <1338553446-22292-5-git-send-email-anton.vorontsov@linaro.org>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <20120601122118.GA6128@lizard>
References: <20120601122118.GA6128@lizard>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

VMEVENT_ATTR_STATE_ONE_SHOT is misleading name. That is effect as
edge trigger shot, not only once.

Suggested-by: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Suggested-by: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 include/linux/vmevent.h |    4 ++--
 mm/vmevent.c            |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/vmevent.h b/include/linux/vmevent.h
index b8ec0ac..b1c4016 100644
--- a/include/linux/vmevent.h
+++ b/include/linux/vmevent.h
@@ -31,9 +31,9 @@ enum {
 	 */
 	VMEVENT_ATTR_STATE_VALUE_EQ	= (1UL << 2),
 	/*
-	 * One-shot mode.
+	 * Edge trigger mode.
 	 */
-	VMEVENT_ATTR_STATE_ONE_SHOT	= (1UL << 3),
+	VMEVENT_ATTR_STATE_EDGE_TRIGGER	= (1UL << 3),
 
 	__VMEVENT_ATTR_STATE_INTERNAL	= (1UL << 30) |
 					  (1UL << 31),
diff --git a/mm/vmevent.c b/mm/vmevent.c
index e64a92d..46c1d18 100644
--- a/mm/vmevent.c
+++ b/mm/vmevent.c
@@ -104,7 +104,7 @@ static bool vmevent_match(struct vmevent_watch *watch)
 			continue;
 
 		if (attr_lt || attr_gt || attr_eq) {
-			bool one_shot = state & VMEVENT_ATTR_STATE_ONE_SHOT;
+			bool edge = state & VMEVENT_ATTR_STATE_EDGE_TRIGGER;
 			u32 was_lt_mask = VMEVENT_ATTR_STATE_VALUE_WAS_LT;
 			u32 was_gt_mask = VMEVENT_ATTR_STATE_VALUE_WAS_GT;
 			u64 value = vmevent_sample_attr(watch, attr);
@@ -117,7 +117,7 @@ static bool vmevent_match(struct vmevent_watch *watch)
 			bool ret = false;
 
 			if (((attr_lt && lt) || (attr_gt && gt) ||
-					(attr_eq && eq)) && !one_shot)
+					(attr_eq && eq)) && !edge)
 				return true;
 
 			if (attr_eq && eq && was_eq) {
-- 
1.7.9.2

