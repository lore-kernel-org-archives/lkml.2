Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755161Ab1IPOOW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 10:14:22 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:52908 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754019Ab1IPOOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 10:14:20 -0400
From: Jonghwan Choi <jhbird.choi@gmail.com>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jonghwan Choi <jhbird.choi@gmail.com>
Subject: [PATCH] CLKDEV: Reduce scaning time
Date: Fri, 16 Sep 2011 23:14:12 +0900
Message-Id: <1316182452-14061-1-git-send-email-jhbird.choi@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If ether dev_id or con_id is NULL. it is not necessary that match point should be 3.
it just takes a long time.

Signed-off-by: Jonghwan Choi <jhbird.choi@gmail.com>
---
 drivers/clk/clkdev.c |   14 ++++++++++----
 1 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/clk/clkdev.c b/drivers/clk/clkdev.c
index 6db161f..d1fcb67 100644
--- a/drivers/clk/clkdev.c
+++ b/drivers/clk/clkdev.c
@@ -35,7 +35,13 @@ static DEFINE_MUTEX(clocks_mutex);
 static struct clk_lookup *clk_find(const char *dev_id, const char *con_id)
 {
 	struct clk_lookup *p, *cl = NULL;
-	int match, best = 0;
+	int match, best = 0, point = 0;
+
+	if (dev_id)
+		point += 2;
+
+	if (con_id)
+		point += 1;
 
 	list_for_each_entry(p, &clocks, node) {
 		match = 0;
@@ -52,10 +58,10 @@ static struct clk_lookup *clk_find(const char *dev_id, const char *con_id)
 
 		if (match > best) {
 			cl = p;
-			if (match != 3)
-				best = match;
-			else
+			if (match == point)
 				break;
+			else
+				best = match;
 		}
 	}
 	return cl;
-- 
1.7.0.4

