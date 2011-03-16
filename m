Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751237Ab1CPNwN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 09:52:13 -0400
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:35372 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750765Ab1CPNwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 09:52:02 -0400
From: Felipe Balbi <balbi@ti.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Grant Likely <grant.likely@secretlab.ca>, Magnus Damm <damm@opensource.se>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andi Kleen <ak@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH] device: add dev_WARN_ON and dev_WARN_ONCE
Date: Wed, 16 Mar 2011 15:51:54 +0200
Message-Id: <1300283514-27105-1-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.7.4.rc2
Organization: Texas Instruments\n
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

it's quite useful to print the device name
on the stack dump caused by WARN(), but
there are other cases where we might want
to use WARN_ON() or WARN_ONCE, introduce
helpers similar to dev_WARN() for those
cases too.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 include/linux/device.h |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/include/linux/device.h b/include/linux/device.h
index 1bf5cf0..454d7c1 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -739,13 +739,21 @@ do {						     \
 #endif
 
 /*
- * dev_WARN() acts like dev_printk(), but with the key difference
+ * dev_WARN*() acts like dev_printk(), but with the key difference
  * of using a WARN/WARN_ON to get the message out, including the
  * file/line information and a backtrace.
  */
 #define dev_WARN(dev, format, arg...) \
 	WARN(1, "Device: %s\n" format, dev_driver_string(dev), ## arg);
 
+#define dev_WARN_ON(dev, condition, format, arg...) \
+	WARN_ON(condition, "Device: %s\n" format,  \
+			dev_driver_string(dev), ## arg)
+
+#define dev_WARN_ONCE(dev, condition, format, arg...) \
+	WARN_ONCE(condition, "Device %s\n" format, \
+			dev_driver_string(dev), ## arg)
+
 /* Create alias, so I can be autoloaded. */
 #define MODULE_ALIAS_CHARDEV(major,minor) \
 	MODULE_ALIAS("char-major-" __stringify(major) "-" __stringify(minor))
-- 
1.7.4.rc2

