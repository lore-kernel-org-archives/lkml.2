Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183Ab1CPN7v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 09:59:51 -0400
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:52902 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752604Ab1CPN7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 09:59:46 -0400
From: Felipe Balbi <balbi@ti.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Grant Likely <grant.likely@secretlab.ca>, Magnus Damm <damm@opensource.se>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andi Kleen <ak@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH] device: add dev_WARN_ONCE
Date: Wed, 16 Mar 2011 15:59:35 +0200
Message-Id: <1300283975-27556-1-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.7.4.rc2
Organization: Texas Instruments\n
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

it's quite useful to print the device name
on the stack dump caused by WARN(), but
there are other cases where we might want
to use WARN_ONCE.

Introduce a helper similar to dev_WARN() for
that case too.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 include/linux/device.h |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/include/linux/device.h b/include/linux/device.h
index 1bf5cf0..83870b8 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -739,13 +739,17 @@ do {						     \
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
1.7.4.rc2

