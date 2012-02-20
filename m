Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752785Ab2BTGrQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 01:47:16 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:19458 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893Ab2BTGrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 01:47:12 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Sun, 19 Feb 2012 22:46:21 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: B29396@freescale.com, s.hauer@pengutronix.de, dongas86@gmail.com,
        shawn.guo@linaro.org, thomas.abraham@linaro.org, tony@atomide.com,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH 18/20] pinctrl: Fix pinconf_groups_show() to emit newline
Date: Sun, 19 Feb 2012 23:45:58 -0700
Message-Id: <1329720360-23227-19-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1329720360-23227-1-git-send-email-swarren@nvidia.com>
References: <1329720360-23227-1-git-send-email-swarren@nvidia.com>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pinconf_groups_show() wrote all debug information on one line. Fix it to
match pinconf_pins_show() and be legible.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 drivers/pinctrl/pinconf.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/pinctrl/pinconf.c b/drivers/pinctrl/pinconf.c
index fcc4bf4..e0a4537 100644
--- a/drivers/pinctrl/pinconf.c
+++ b/drivers/pinctrl/pinconf.c
@@ -334,6 +334,8 @@ static int pinconf_groups_show(struct seq_file *s, void *what)
 
 		seq_printf(s, "%u (%s):", selector, gname);
 		pinconf_dump_group(pctldev, s, selector, gname);
+		seq_printf(s, "\n");
+
 		selector++;
 	}
 
-- 
1.7.5.4

