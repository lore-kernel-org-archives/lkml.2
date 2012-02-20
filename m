Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752124Ab2BTGqI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 01:46:08 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:19231 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327Ab2BTGqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 01:46:06 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Sun, 19 Feb 2012 22:46:06 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: B29396@freescale.com, s.hauer@pengutronix.de, dongas86@gmail.com,
        shawn.guo@linaro.org, thomas.abraham@linaro.org, tony@atomide.com,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH 01/20] pinctrl: pinctrl_register_mappings() shouldn't be __init
Date: Sun, 19 Feb 2012 23:45:41 -0700
Message-Id: <1329720360-23227-2-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1329720360-23227-1-git-send-email-swarren@nvidia.com>
References: <1329720360-23227-1-git-send-email-swarren@nvidia.com>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It may be common for pinctrl_register_mappings() to be used from __init
context, but there's no reason that additional mappings shouldn't be
added at a later point, e.g. if loading modules that add pin controllers
and their mapping tables.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 drivers/pinctrl/core.c |   15 +++++----------
 1 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index 8a91eb2..84a24a6 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -641,18 +641,13 @@ EXPORT_SYMBOL_GPL(pinctrl_disable);
 
 /**
  * pinctrl_register_mappings() - register a set of pin controller mappings
- * @maps: the pincontrol mappings table to register, this should be marked with
- *	__initdata so it can be discarded after boot, this function will
- *	perform a shallow copy for the mapping entries.
+ * @maps: the pincontrol mappings table to register. This should probably be
+ *	marked with __initdata so it can be discarded after boot. This
+ *	function will perform a shallow copy for the mapping entries.
  * @num_maps: the number of maps in the mapping table
- *
- * Only call this once during initialization of your machine, the function is
- * tagged as __init and won't be callable after init has completed. The map
- * passed into this function will be owned by the pinmux core and cannot be
- * freed.
  */
-int __init pinctrl_register_mappings(struct pinctrl_map const *maps,
-				     unsigned num_maps)
+int pinctrl_register_mappings(struct pinctrl_map const *maps,
+			      unsigned num_maps)
 {
 	void *tmp_maps;
 	int i;
-- 
1.7.5.4

