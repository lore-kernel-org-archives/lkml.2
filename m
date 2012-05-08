Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753025Ab2EHJqF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 05:46:05 -0400
Received: from eu1sys200aog119.obsmtp.com ([207.126.144.147]:59917 "EHLO
	eu1sys200aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752067Ab2EHJqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 05:46:00 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Stephen Warren <swarren@nvidia.com>, Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 07/12] pinctrl: add sleep state definition
Date: Tue, 8 May 2012 11:45:10 +0200
Message-ID: <1336470310-23709-1-git-send-email-linus.walleij@stericsson.com>
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

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 include/linux/pinctrl/pinctrl-state.h |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/include/linux/pinctrl/pinctrl-state.h b/include/linux/pinctrl/pinctrl-state.h
index 3920e28..85bc1fe 100644
--- a/include/linux/pinctrl/pinctrl-state.h
+++ b/include/linux/pinctrl/pinctrl-state.h
@@ -2,5 +2,18 @@
  * Standard pin control state definitions
  */
 
+/**
+ * @PINCTRL_STATE_DEFAULT: the state the pinctrl handle shall be put
+ *	on as default, usually this means the pins are up and ready to
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

