Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932137Ab2EKIfQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 04:35:16 -0400
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:39716 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752167Ab2EKIfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 04:35:03 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Stephen Warren <swarren@nvidia.com>, Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 07/12 v2] pinctrl: add sleep state definition
Date: Fri, 11 May 2012 10:32:23 +0200
Message-ID: <1336725143-25563-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.9.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

There is an IDLE definition in the pinctrl framework, but for
ux500 SLEEP is more apropriate.

I've added some comments on the semantics of the common states
so as to avoid misunderstandings.

ChangeLog v1->v2:
- Fixed terminology "on"->"into".

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 include/linux/pinctrl/pinctrl-state.h |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/include/linux/pinctrl/pinctrl-state.h b/include/linux/pinctrl/pinctrl-state.h
index 3920e28..634608dc 100644
--- a/include/linux/pinctrl/pinctrl-state.h
+++ b/include/linux/pinctrl/pinctrl-state.h
@@ -2,5 +2,18 @@
  * Standard pin control state definitions
  */
 
+/**
+ * @PINCTRL_STATE_DEFAULT: the state the pinctrl handle shall be put
+ *	into as default, usually this means the pins are up and ready to
+ *	be used by the device driver. This state is commonly used by
+ *	hogs to configure muxing and pins at boot.
+ * @PINCTRL_STATE_IDLE: the state the pinctrl handle shall be put into
+ *	when the pins are idle. Could typically be set from a
+ *	pm_runtime_suspend() operation.
+ * @PINCTRL_STATE_SLEEP: the state the pinctrl handle shall be put into
+ *	when the pins are sleeping. Could typically be set from a
+ *	common suspend() function.
+ */
 #define PINCTRL_STATE_DEFAULT "default"
 #define PINCTRL_STATE_IDLE "idle"
+#define PINCTRL_STATE_SLEEP "sleep"
-- 
1.7.9.2

