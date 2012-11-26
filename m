Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933750Ab2KZRMV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:12:21 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47940 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933720Ab2KZRMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:12:01 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 194/270] pinctrl: remove mutex lock in groups show
Date: Mon, 26 Nov 2012 14:58:04 -0200
Message-Id: <1353949160-26803-195-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haojian Zhuang <haojian.zhuang@gmail.com>

commit 7ae9d71e8df27a3ab60a05ae3add08728debc09c upstream.

Mutex is locked duplicatly by pinconf_groups_show() and
pin_config_group_get(). It results dead lock. So avoid to lock mutex
in pinconf_groups_show().

Signed-off-by: Haojian Zhuang <haojian.zhuang@gmail.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/pinctrl/pinconf.c |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/pinctrl/pinconf.c b/drivers/pinctrl/pinconf.c
index 43f474c..baee2cc 100644
--- a/drivers/pinctrl/pinconf.c
+++ b/drivers/pinctrl/pinconf.c
@@ -537,8 +537,6 @@ static int pinconf_groups_show(struct seq_file *s, void *what)
 	seq_puts(s, "Pin config settings per pin group\n");
 	seq_puts(s, "Format: group (name): configs\n");
 
-	mutex_lock(&pinctrl_mutex);
-
 	while (selector < ngroups) {
 		const char *gname = pctlops->get_group_name(pctldev, selector);
 
@@ -549,8 +547,6 @@ static int pinconf_groups_show(struct seq_file *s, void *what)
 		selector++;
 	}
 
-	mutex_unlock(&pinctrl_mutex);
-
 	return 0;
 }
 
-- 
1.7.9.5

