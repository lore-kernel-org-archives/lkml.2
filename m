Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751946Ab0CQC73 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 22:59:29 -0400
Received: from mail.windriver.com ([147.11.1.11]:47861 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270Ab0CQC7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 22:59:01 -0400
From: Yong Zhang <yong.zhang@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu
Subject: [PATCH 1/3] ratelimit: annotate ___ratelimit()
Date: Wed, 17 Mar 2010 10:58:42 +0800
Message-Id: <1268794724-8665-2-git-send-email-yong.zhang@windriver.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1268794724-8665-1-git-send-email-yong.zhang@windriver.com>
References: <1268794724-8665-1-git-send-email-yong.zhang@windriver.com>
X-OriginalArrivalTime: 17 Mar 2010 02:58:47.0833 (UTC) FILETIME=[C3B2A890:01CAC57D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Especially to prevent from wrong using of the return value.

Signed-off-by: Yong Zhang <yong.zhang@windriver.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Dave Young <hidave.darkstar@gmail.com>
---
 lib/ratelimit.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/lib/ratelimit.c b/lib/ratelimit.c
index 09f5ce1..29a10b3 100644
--- a/lib/ratelimit.c
+++ b/lib/ratelimit.c
@@ -16,9 +16,14 @@
 /*
  * __ratelimit - rate limiting
  * @rs: ratelimit_state data
+ * @func: name of calling function
  *
- * This enforces a rate limit: not more than @rs->ratelimit_burst callbacks
- * in every @rs->ratelimit_jiffies
+ * This enforces a rate limit: not more than @rs->burst callbacks
+ * in every @rs->interval
+ *
+ * RETURNS:
+ * 0 means callbacks will be suppuressed.
+ * 1 means go ahead and do it.
  */
 int ___ratelimit(struct ratelimit_state *rs, const char *func)
 {
-- 
1.6.3.3

