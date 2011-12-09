Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172Ab1LIX7V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 18:59:21 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:34566 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754970Ab1LIX7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 18:59:16 -0500
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH 1/3] pinctrl: Implement PINMUX_MAP_SYS_HOG
Date: Fri,  9 Dec 2011 16:59:03 -0700
Message-Id: <1323475145-26430-1-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the same as PINMUX_MAP_PRIMARY_SYS_HOG, except that it allows
you to specify a particular control device.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 include/linux/pinctrl/machine.h |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/include/linux/pinctrl/machine.h b/include/linux/pinctrl/machine.h
index f537231..0ca32eb 100644
--- a/include/linux/pinctrl/machine.h
+++ b/include/linux/pinctrl/machine.h
@@ -66,6 +66,14 @@ struct pinmux_map {
 	{ .name = a, .ctrl_dev_name = b, .function = c }
 
 /*
+ * Convenience macro to map a system function onto a certain pinctrl device,
+ * to be hogged by the pinmux core until the system shuts down.
+ */
+#define PINMUX_MAP_SYS_HOG(a, b, c) \
+	{ .name = a, .ctrl_dev_name = b, .function = c, \
+	  .hog_on_boot = true }
+
+/*
  * Convenience macro to map a function onto the primary device pinctrl device
  * this is especially helpful on systems that have only one pin controller
  * or need to set up a lot of mappings on the primary controller.
-- 
1.7.0.4

