Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755011Ab1LNIdB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 03:33:01 -0500
Received: from eu1sys200aog110.obsmtp.com ([207.126.144.129]:51135 "EHLO
	eu1sys200aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754431Ab1LNIc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 03:32:58 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>
Cc: Stephen Warren <swarren@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Barry Song <21cnbao@gmail.com>, Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] pinctrl: add a group-specific hog macro
Date: Wed, 14 Dec 2011 09:32:10 +0100
Message-ID: <1323851530-4171-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

To create elegant tables for pinmux hogs on the PXA MMP platform,
we need this hog macro that can specify both function and group in
one go.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 include/linux/pinctrl/machine.h |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/include/linux/pinctrl/machine.h b/include/linux/pinctrl/machine.h
index ad430e0..d0aecb7 100644
--- a/include/linux/pinctrl/machine.h
+++ b/include/linux/pinctrl/machine.h
@@ -73,6 +73,15 @@ struct pinmux_map {
 	{ .name = a, .ctrl_dev_name = b, .function = c, \
 	  .hog_on_boot = true }
 
+/*
+ * Convenience macro to map a system function onto a certain pinctrl device
+ * using a specified group, to be hogged by the pinmux core until the system
+ * shuts down.
+ */
+#define PINMUX_MAP_SYS_HOG_GROUP(a, b, c, d)		\
+	{ .name = a, .ctrl_dev_name = b, .function = c, .group = d, \
+	  .hog_on_boot = true }
+
 #ifdef CONFIG_PINMUX
 
 extern int pinmux_register_mappings(struct pinmux_map const *map,
-- 
1.7.3.2

