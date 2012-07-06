Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758035Ab2GFRUe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 13:20:34 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41745 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757874Ab2GFRUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 13:20:33 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: core: Mark all DT based boards as having full constraints
Date: Fri,  6 Jul 2012 18:20:30 +0100
Message-Id: <1341595230-2069-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since DT doesn't provide an idiomatic mechanism for enabling full
constraints and since it's much more natural with DT to provide them
just assume that a DT enabled system has full constraints.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 270d9a2..9a70d9c 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -3578,6 +3578,15 @@ static int __init regulator_init_complete(void)
 	struct regulation_constraints *c;
 	int enabled, ret;
 
+	/*
+	 * Since DT doesn't provide an idiomatic mechanism for
+	 * enabling full constraints and since it's much more natural
+	 * with DT to provide them just assume that a DT enabled
+	 * system has full constraints.
+	 */
+	if (of_have_populated_dt())
+		has_full_constraints = true;
+
 	mutex_lock(&regulator_list_mutex);
 
 	/* If we have a full configuration then disable any regulators
-- 
1.7.10

