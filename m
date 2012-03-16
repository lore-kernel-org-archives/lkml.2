Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032686Ab2CPKUf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 06:20:35 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:54119 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965391Ab2CPKUd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 06:20:33 -0400
From: Rajendra Nayak <rnayak@ti.com>
To: <broonie@opensource.wolfsonmicro.com>, <lrg@ti.com>
CC: <linux-kernel@vger.kernel.org>, Rajendra Nayak <rnayak@ti.com>
Subject: [PATCH] regulator: Fix up a confusing dev_warn when regulator_get fails
Date: Fri, 16 Mar 2012 15:50:21 +0530
Message-ID: <1331893221-14426-1-git-send-email-rnayak@ti.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

of_parse_phandle() returns NULL either if the property name
itself does not exist or if it (exists and) does not
reference a valid phandle.
Giving out a warn like the one below (that the property references
an invalid phandle) can be confusing when the property itself
does not exist in the node.
Fix it with a more sensible message and make it a dev_dbg instead
of a dev_warn.

Reported-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Signed-off-by: Rajendra Nayak <rnayak@ti.com>
---
 drivers/regulator/core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 5a6b8ba..e2f3afa 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -148,7 +148,7 @@ static struct device_node *of_get_regulator(struct device *dev, const char *supp
 	regnode = of_parse_phandle(dev->of_node, prop_name, 0);
 
 	if (!regnode) {
-		dev_warn(dev, "%s property in node %s references invalid phandle",
+		dev_dbg(dev, "Looking up %s property in node %s failed",
 				prop_name, dev->of_node->full_name);
 		return NULL;
 	}
-- 
1.7.1

