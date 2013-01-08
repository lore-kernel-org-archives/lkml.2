Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756269Ab3AHNHl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 08:07:41 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:54450 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756228Ab3AHNHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 08:07:40 -0500
From: Rajagopal Venkat <rajagopal.venkat@linaro.org>
To: mturquette@linaro.org
Cc: patches@linaro.org, linaro-dev@lists.linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Rajagopal Venkat <rajagopal.venkat@linaro.org>
Subject: [PATCH] clk: remove unreachable code
Date: Tue,  8 Jan 2013 18:33:11 +0530
Message-Id: <1357650191-30842-1-git-send-email-rajagopal.venkat@linaro.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

while reparenting a clock, NULL check is done for clock in
consideration and its new parent. So re-check is not required.
If done, else part becomes unreachable.

Signed-off-by: Rajagopal Venkat <rajagopal.venkat@linaro.org>
---
 drivers/clk/clk.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 251e45d..f896584 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -1048,10 +1048,7 @@ void __clk_reparent(struct clk *clk, struct clk *new_parent)
 
 	hlist_del(&clk->child_node);
 
-	if (new_parent)
-		hlist_add_head(&clk->child_node, &new_parent->children);
-	else
-		hlist_add_head(&clk->child_node, &clk_orphan_list);
+	hlist_add_head(&clk->child_node, &new_parent->children);
 
 #ifdef CONFIG_COMMON_CLK_DEBUG
 	if (!inited)
-- 
1.7.10.4

