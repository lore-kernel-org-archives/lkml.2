Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754243Ab1KPJAQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 04:00:16 -0500
Received: from eu1sys200aog118.obsmtp.com ([207.126.144.145]:38266 "EHLO
	eu1sys200aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751988Ab1KPJAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 04:00:14 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, Stephen Warren <swarren@nvidia.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, Barry Song <21cnbao@gmail.com>,
        Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] pinctrl: print pin range in GPIO range debugs
Date: Wed, 16 Nov 2011 09:59:50 +0100
Message-ID: <1321433990-17403-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

Show the mapped pin range corresponding to the GPIO range in
debugfs for pin controllers.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/core.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index a1a679c..4598fc5 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -402,8 +402,11 @@ static int pinctrl_gpioranges_show(struct seq_file *s, void *what)
 	/* Loop over the ranges */
 	mutex_lock(&pctldev->gpio_ranges_lock);
 	list_for_each_entry(range, &pctldev->gpio_ranges, node) {
-		seq_printf(s, "%u: %s [%u - %u]\n", range->id, range->name,
-			   range->base, (range->base + range->npins - 1));
+		seq_printf(s, "%u: %s GPIOS [%u - %u] PINS [%u - %u]\n",
+			   range->id, range->name,
+			   range->base, (range->base + range->npins - 1),
+			   range->pin_base,
+			   (range->pin_base + range->npins - 1));
 	}
 	mutex_unlock(&pctldev->gpio_ranges_lock);
 
-- 
1.7.3.2

