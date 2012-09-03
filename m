Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932167Ab2ICNuV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 09:50:21 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:50008 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932150Ab2ICNuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 09:50:18 -0400
From: sjur.brandeland@stericsson.com
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjurbren@gmail.com>,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arun Murthy <arun.murthy@stericsson.com>
Subject: [RFC 2/3] include/linux: Add header file for modem power control.
Date: Mon,  3 Sep 2012 15:49:52 +0200
Message-Id: <1346680193-5443-2-git-send-email-sjur.brandeland@stericsson.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1346680193-5443-1-git-send-email-sjur.brandeland@stericsson.com>
References: <1346680193-5443-1-git-send-email-sjur.brandeland@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sjur Brændeland <sjur.brandeland@stericsson.com>

Add a API for modem power control.

Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
cc: Linus Walleij <linus.walleij@linaro.org>
cc: Arun Murthy <arun.murthy@stericsson.com>
---
 include/linux/modem_ctrl.h |   61 ++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 61 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/modem_ctrl.h

diff --git a/include/linux/modem_ctrl.h b/include/linux/modem_ctrl.h
new file mode 100644
index 0000000..f6c537d
--- /dev/null
+++ b/include/linux/modem_ctrl.h
@@ -0,0 +1,61 @@
+/*
+ * Copyright (C) ST-Ericsson AB 2012
+ * Author: Sjur Brendeland / sjur.brandeland@stericsson.com
+ *
+ * License terms: GNU General Public License (GPL) version 2
+ */
+
+#ifndef __INC_MODEM_CTRL_H
+#define __INC_MODEM_CTRL_H
+#include <linux/types.h>
+
+struct modem_ctrl;
+
+/**
+ * modem_ctrl_get- Get the handle for the modem power control API.
+ * @modem_name:	Name of the modem.
+ *
+ * Get a handle to the modem power control API providing
+ * functionality to for powering up and down the modem.
+ *
+ * This function may block.
+ * Returns zero on success, and negative upon error.
+ */
+struct modem_ctrl *modem_ctrl_get(const char *modem_name);
+
+/**
+ * modem_ctrl_put - Release the instance of the modem ctrl API.
+ *
+ * ctrl:	The API handle return by modem_ctrl_get().
+ *
+ * Releases the modem_ctrl API instance.
+ * This function may block.
+ * Returns zero on success, and negative upon error.
+ */
+void modem_ctrl_put(struct modem_ctrl *ctrl);
+
+/**
+ * modem_start() - Start the modem.
+ *
+ * @ctrl:	The API handle return by modem_ctrl_get().
+ *
+ * This function is used to start the modem.
+ *
+ * This function may block.
+ * Returns zero on success, and negative upon error.
+ */
+int modem_start(struct modem_ctrl *ctrl);
+
+/**
+ * modem_stop() - Stop the modem.
+ *
+ * @ctrl:	The API handle return by modem_ctrl_get().
+ *
+ * This function is used to stop the modem.
+ *
+ * This function may block.
+ * Returns zero on success, and negative upon error.
+ */
+int modem_stop(struct modem_ctrl *ctrl);
+
+#endif /*INC_MODEM_CTRL_H*/
-- 
1.7.5.4

