Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759889Ab2DKWpx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 18:45:53 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:42730 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754114Ab2DKWpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 18:45:52 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH 1/2] pinctrl: ifdef CONFIG_DEBUG_FS cleanup
Date: Wed, 11 Apr 2012 16:45:45 -0600
Message-Id: <1334184346-16377-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

Only provide prototypes for pin{mux,conf}.c debugfs-related functions
when both CONFIG_PIN* /and/ CONFIG_DEBUG_FS are enabled, otherwise
provide static inlines.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 drivers/pinctrl/pinconf.h |   17 ++++++++++++-----
 drivers/pinctrl/pinmux.h  |   18 ++++++++++++------
 2 files changed, 24 insertions(+), 11 deletions(-)

diff --git a/drivers/pinctrl/pinconf.h b/drivers/pinctrl/pinconf.h
index 54510de..32b8354 100644
--- a/drivers/pinctrl/pinconf.h
+++ b/drivers/pinctrl/pinconf.h
@@ -19,11 +19,6 @@ int pinconf_map_to_setting(struct pinctrl_map const *map,
 			  struct pinctrl_setting *setting);
 void pinconf_free_setting(struct pinctrl_setting const *setting);
 int pinconf_apply_setting(struct pinctrl_setting const *setting);
-void pinconf_show_map(struct seq_file *s, struct pinctrl_map const *map);
-void pinconf_show_setting(struct seq_file *s,
-			  struct pinctrl_setting const *setting);
-void pinconf_init_device_debugfs(struct dentry *devroot,
-				 struct pinctrl_dev *pctldev);
 
 /*
  * You will only be interested in these if you're using PINCONF
@@ -61,6 +56,18 @@ static inline int pinconf_apply_setting(struct pinctrl_setting const *setting)
 	return 0;
 }
 
+#endif
+
+#if defined(CONFIG_PINMUX) && defined(CONFIG_DEBUG_FS)
+
+void pinconf_show_map(struct seq_file *s, struct pinctrl_map const *map);
+void pinconf_show_setting(struct seq_file *s,
+			  struct pinctrl_setting const *setting);
+void pinconf_init_device_debugfs(struct dentry *devroot,
+				 struct pinctrl_dev *pctldev);
+
+#else
+
 static inline void pinconf_show_map(struct seq_file *s,
 				    struct pinctrl_map const *map)
 {
diff --git a/drivers/pinctrl/pinmux.h b/drivers/pinctrl/pinmux.h
index 6fc4700..d1a98b1 100644
--- a/drivers/pinctrl/pinmux.h
+++ b/drivers/pinctrl/pinmux.h
@@ -31,12 +31,6 @@ void pinmux_free_setting(struct pinctrl_setting const *setting);
 int pinmux_enable_setting(struct pinctrl_setting const *setting);
 void pinmux_disable_setting(struct pinctrl_setting const *setting);
 
-void pinmux_show_map(struct seq_file *s, struct pinctrl_map const *map);
-void pinmux_show_setting(struct seq_file *s,
-			 struct pinctrl_setting const *setting);
-void pinmux_init_device_debugfs(struct dentry *devroot,
-				struct pinctrl_dev *pctldev);
-
 #else
 
 static inline int pinmux_check_ops(struct pinctrl_dev *pctldev)
@@ -89,6 +83,18 @@ static inline void pinmux_disable_setting(
 {
 }
 
+#endif
+
+#if defined(CONFIG_PINMUX) && defined(CONFIG_DEBUG_FS)
+
+void pinmux_show_map(struct seq_file *s, struct pinctrl_map const *map);
+void pinmux_show_setting(struct seq_file *s,
+			 struct pinctrl_setting const *setting);
+void pinmux_init_device_debugfs(struct dentry *devroot,
+				struct pinctrl_dev *pctldev);
+
+#else
+
 static inline void pinmux_show_map(struct seq_file *s,
 				   struct pinctrl_map const *map)
 {
-- 
1.7.0.4

