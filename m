Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030549Ab2AFUim (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 15:38:42 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:49236 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030443Ab2AFUil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 15:38:41 -0500
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, Chanho Park <chanho61.park@samsung.com>,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH] pinctrl: Fix pinconf_pins_show iteration
Date: Fri,  6 Jan 2012 13:38:31 -0700
Message-Id: <1325882311-7504-1-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 706e852 "pinctrl: correct a offset while enumerating pins"
modified the variable used by pinconf_pin_show()'s for loop, but didn't
update the for loop test expression.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 drivers/pinctrl/pinconf.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/pinctrl/pinconf.c b/drivers/pinctrl/pinconf.c
index 1259872..1892a37 100644
--- a/drivers/pinctrl/pinconf.c
+++ b/drivers/pinctrl/pinconf.c
@@ -236,7 +236,7 @@ static int pinconf_pins_show(struct seq_file *s, void *what)
 	seq_puts(s, "Format: pin (name): pinmux setting array\n");
 
 	/* The pin number can be retrived from the pin controller descriptor */
-	for (i = 0; pin < pctldev->desc->npins; i++) {
+	for (i = 0; i < pctldev->desc->npins; i++) {
 		struct pin_desc *desc;
 
 		pin = pctldev->desc->pins[i].number;
-- 
1.7.0.4

