Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932524Ab1E0IqF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 04:46:05 -0400
Received: from qmta13.emeryville.ca.mail.comcast.net ([76.96.27.243]:48713
	"EHLO qmta13.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758747Ab1E0Iom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 04:44:42 -0400
From: matt mooney <mfm@muteddisk.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: usbip-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH 2/6] staging: usbip: userspace: move header includes out utils.h
Date: Fri, 27 May 2011 01:44:11 -0700
Message-Id: <fb944a5003fac31cc37d1a4f2d69c9d91678d7bd.1306485772.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <ec9a733eb388e3057d46ca451448e23ca24bd7e9.1306485772.git.mfm@muteddisk.com>
References: <ec9a733eb388e3057d46ca451448e23ca24bd7e9.1306485772.git.mfm@muteddisk.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The includes have been moved out of utils.h to their respective source
files where they are suppose to be. An include guard is also added to
utils.h

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 drivers/staging/usbip/userspace/src/usbip_bind.c |    3 +-
 drivers/staging/usbip/userspace/src/utils.c      |    6 ++++-
 drivers/staging/usbip/userspace/src/utils.h      |   25 +++------------------
 3 files changed, 11 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/usbip/userspace/src/usbip_bind.c b/drivers/staging/usbip/userspace/src/usbip_bind.c
index 26cfbad..9869db2 100644
--- a/drivers/staging/usbip/userspace/src/usbip_bind.c
+++ b/drivers/staging/usbip/userspace/src/usbip_bind.c
@@ -18,11 +18,12 @@
 
 #include <sysfs/libsysfs.h>
 
+#include <limits.h>
 #include <stdio.h>
 #include <string.h>
 
-#include <getopt.h>
 #include <fcntl.h>
+#include <getopt.h>
 #include <unistd.h>
 
 #include "usbip_common.h"
diff --git a/drivers/staging/usbip/userspace/src/utils.c b/drivers/staging/usbip/userspace/src/utils.c
index 35b05e4..6dbfdbd 100644
--- a/drivers/staging/usbip/userspace/src/utils.c
+++ b/drivers/staging/usbip/userspace/src/utils.c
@@ -4,9 +4,13 @@
  */
 
 #include <sysfs/libsysfs.h>
+
+#include <limits.h>
+#include <stdio.h>
+#include <string.h>
+
 #include <fcntl.h>
 #include <libgen.h>
-#include <string.h>
 #include <unistd.h>
 
 #include "usbip_common.h"
diff --git a/drivers/staging/usbip/userspace/src/utils.h b/drivers/staging/usbip/userspace/src/utils.h
index 423716d..36ee8d5 100644
--- a/drivers/staging/usbip/userspace/src/utils.h
+++ b/drivers/staging/usbip/userspace/src/utils.h
@@ -1,26 +1,7 @@
+#ifndef __UTILS_H
+#define __UTILS_H
 
-#ifdef HAVE_CONFIG_H
-#include "../config.h"
-#endif
-
-#define _GNU_SOURCE
-#include <string.h>
-#include <sys/un.h>
-#include <sys/types.h>
-#include <sys/socket.h>
-
-#include <sysfs/libsysfs.h>
-#include <glib.h>
-#include <unistd.h>
-#include <stdio.h>
-#include <sys/types.h>
-#include <sys/stat.h>
-#include <fcntl.h>
 #include <stdlib.h>
-#include <time.h>
-#include <errno.h>
-
-
 
 /* Be sync to kernel header */
 #define BUS_ID_SIZE 20
@@ -37,3 +18,5 @@ int write_bConfigurationValue(char *busid, int config);
 int read_bDeviceClass(char *busid);
 int readline(int sockfd, char *str, int strlen);
 int writeline(int sockfd, char *buff, int bufflen);
+
+#endif /* __UTILS_H */
-- 
1.7.5.1

