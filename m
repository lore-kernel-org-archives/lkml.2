Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933227Ab1ETALI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 20:11:08 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:50852 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932182Ab1ETALH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 20:11:07 -0400
X-Sasl-enc: 7sFfzr+B8TN6u3N2dlWkblm/L0ZlSa2v1ufmYGtvvwDf 1305850265
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Felipe Balbi <balbi@ti.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 01/44] device: add dev_WARN_ONCE
Date: Thu, 19 May 2011 17:10:19 -0700
Message-Id: <1305850262-9575-1-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.4.2
In-Reply-To: <20110520000821.GA9367@kroah.com>
References: <20110520000821.GA9367@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Felipe Balbi <balbi@ti.com>

it's quite useful to print the device name
on the stack dump caused by WARN(), but
there are other cases where we might want
to use WARN_ONCE.

Introduce a helper similar to dev_WARN() for
that case too.

Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/device.h |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/include/linux/device.h b/include/linux/device.h
index ab8dfc0..d484051 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -742,13 +742,17 @@ do {						     \
 #endif
 
 /*
- * dev_WARN() acts like dev_printk(), but with the key difference
+ * dev_WARN*() acts like dev_printk(), but with the key difference
  * of using a WARN/WARN_ON to get the message out, including the
  * file/line information and a backtrace.
  */
 #define dev_WARN(dev, format, arg...) \
 	WARN(1, "Device: %s\n" format, dev_driver_string(dev), ## arg);
 
+#define dev_WARN_ONCE(dev, condition, format, arg...) \
+	WARN_ONCE(condition, "Device %s\n" format, \
+			dev_driver_string(dev), ## arg)
+
 /* Create alias, so I can be autoloaded. */
 #define MODULE_ALIAS_CHARDEV(major,minor) \
 	MODULE_ALIAS("char-major-" __stringify(major) "-" __stringify(minor))
-- 
1.7.4.2

