Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752414Ab1FTGB6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 02:01:58 -0400
Received: from qmta10.emeryville.ca.mail.comcast.net ([76.96.30.17]:36223 "EHLO
	qmta10.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752154Ab1FTGB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 02:01:56 -0400
From: matt mooney <mfm@muteddisk.com>
To: Greg KH <greg@kroah.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 04/22] staging: usbip: userspace: usbip_common.h: fixup header includes
Date: Sun, 19 Jun 2011 22:44:34 -0700
Message-Id: <78266d3fcf3d7daa9a3e399d5f5af6bb2f5a9649.1308547654.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.7.5.2
In-Reply-To: <cover.1308547654.git.mfm@muteddisk.com>
References: <cover.1308547654.git.mfm@muteddisk.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unnecessary headers from the file, and add the now missing
headers into the files that actually need them.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 .../staging/usbip/userspace/libsrc/stub_driver.c   |    2 ++
 .../staging/usbip/userspace/libsrc/usbip_common.h  |   18 ++++++++----------
 drivers/staging/usbip/userspace/src/utils.c        |    1 +
 3 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/usbip/userspace/libsrc/stub_driver.c b/drivers/staging/usbip/userspace/libsrc/stub_driver.c
index 4d4d171..6a1272d 100644
--- a/drivers/staging/usbip/userspace/libsrc/stub_driver.c
+++ b/drivers/staging/usbip/userspace/libsrc/stub_driver.c
@@ -4,6 +4,8 @@
 
 #include <sys/types.h>
 #include <sys/stat.h>
+
+#include <errno.h>
 #include <unistd.h>
 
 #include "usbip.h"
diff --git a/drivers/staging/usbip/userspace/libsrc/usbip_common.h b/drivers/staging/usbip/userspace/libsrc/usbip_common.h
index 7dadb21..eedefbd 100644
--- a/drivers/staging/usbip/userspace/libsrc/usbip_common.h
+++ b/drivers/staging/usbip/userspace/libsrc/usbip_common.h
@@ -2,20 +2,18 @@
  * Copyright (C) 2005-2007 Takahiro Hirofuchi
  */
 
-#ifndef _USBIP_COMMON_H
-#define _USBIP_COMMON_H
+#ifndef __USBIP_COMMON_H
+#define __USBIP_COMMON_H
+
+#include <sysfs/libsysfs.h>
 
-#include <unistd.h>
 #include <stdint.h>
-#include <syslog.h>
-#include <errno.h>
 #include <stdio.h>
-#include <string.h>
 #include <stdlib.h>
+#include <string.h>
 
-#include <sysfs/libsysfs.h>
-#include <netdb.h>
-#include <sys/socket.h>
+#include <syslog.h>
+#include <unistd.h>
 
 #ifndef USBIDS_FILE
 #define USBIDS_FILE "/usr/share/hwdata/usb.ids"
@@ -146,4 +144,4 @@ void usbip_names_free(void);
 void usbip_names_get_product(char *buff, size_t size, uint16_t vendor, uint16_t product);
 void usbip_names_get_class(char *buff, size_t size, uint8_t class, uint8_t subclass, uint8_t protocol);
 
-#endif
+#endif /* __USBIP_COMMON_H */
diff --git a/drivers/staging/usbip/userspace/src/utils.c b/drivers/staging/usbip/userspace/src/utils.c
index 1da1109..2a25cec 100644
--- a/drivers/staging/usbip/userspace/src/utils.c
+++ b/drivers/staging/usbip/userspace/src/utils.c
@@ -6,6 +6,7 @@
 #include <sysfs/libsysfs.h>
 
 #include <limits.h>
+#include <errno.h>
 #include <stdio.h>
 #include <string.h>
 
-- 
1.7.5.2

