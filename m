Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933337Ab2CZTBk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 15:01:40 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933090Ab2CZTBj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 15:01:39 -0400
From: Richard Weinberger <richard@nod.at>
To: linuxppc-dev@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, benh@kernel.crashing.org,
        agust@denx.de, Richard Weinberger <richard@nod.at>
Subject: [PATCH] powerpc: 512x: Fix mpc5121_clk_get()
Date: Mon, 26 Mar 2012 21:01:29 +0200
Message-Id: <1332788489-27435-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If try_module_get() fails, mpc5121_clk_get() might return
a wrong clock.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/powerpc/platforms/512x/clock.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/platforms/512x/clock.c b/arch/powerpc/platforms/512x/clock.c
index 1d8700f..9f771e0 100644
--- a/arch/powerpc/platforms/512x/clock.c
+++ b/arch/powerpc/platforms/512x/clock.c
@@ -54,14 +54,16 @@ static DEFINE_MUTEX(clocks_mutex);
 static struct clk *mpc5121_clk_get(struct device *dev, const char *id)
 {
 	struct clk *p, *clk = ERR_PTR(-ENOENT);
-	int dev_match = 0;
-	int id_match = 0;
+	int dev_match;
+	int id_match;
 
 	if (dev == NULL || id == NULL)
 		return clk;
 
 	mutex_lock(&clocks_mutex);
 	list_for_each_entry(p, &clocks, node) {
+		dev_match = id_match = 0;
+
 		if (dev == p->dev)
 			dev_match++;
 		if (strcmp(id, p->name) == 0)
-- 
1.7.7.3

