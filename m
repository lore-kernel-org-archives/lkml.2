Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880Ab1FTFsN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 01:48:13 -0400
Received: from qmta03.westchester.pa.mail.comcast.net ([76.96.62.32]:37268
	"EHLO qmta03.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752097Ab1FTFpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 01:45:33 -0400
From: matt mooney <mfm@muteddisk.com>
To: Greg KH <greg@kroah.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 06/22] staging: usbip: userspace: usbip.c: add log option
Date: Sun, 19 Jun 2011 22:44:36 -0700
Message-Id: <8a6d045c9214a4af84e7a3f186abe3e7af3fd3d4.1308547654.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.7.5.2
In-Reply-To: <cover.1308547654.git.mfm@muteddisk.com>
References: <cover.1308547654.git.mfm@muteddisk.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add option for logging with syslog, and default to use stderr for
error and info messages.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 drivers/staging/usbip/userspace/src/usbip.c |   13 ++++++++++---
 1 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/usbip/userspace/src/usbip.c b/drivers/staging/usbip/userspace/src/usbip.c
index 8940cd0..cdfe4c2 100644
--- a/drivers/staging/usbip/userspace/src/usbip.c
+++ b/drivers/staging/usbip/userspace/src/usbip.c
@@ -23,6 +23,7 @@
 #include <stdlib.h>
 
 #include <getopt.h>
+#include <syslog.h>
 
 #include "usbip_common.h"
 #include "usbip.h"
@@ -33,7 +34,7 @@ static int usbip_version(int argc, char *argv[]);
 static const char usbip_version_string[] = PACKAGE_STRING;
 
 static const char usbip_usage_string[] =
-	"usbip [--debug] [version]\n"
+	"usbip [--debug] [--log] [version]\n"
 	"             [help] <command> <args>\n";
 
 static void usbip_usage(void)
@@ -138,12 +139,15 @@ int main(int argc, char *argv[])
 {
 	static const struct option opts[] = {
 		{ "debug", no_argument, NULL, 'd' },
-		{ NULL, 0, NULL, 0 }
+		{ "log",   no_argument, NULL, 'l' },
+		{ NULL,    0,           NULL,  0  }
 	};
+
 	char *cmd;
 	int opt;
 	int i, rc = -1;
 
+	usbip_use_stderr = 1;
 	opterr = 0;
 	for (;;) {
 		opt = getopt_long(argc, argv, "+d", opts, NULL);
@@ -154,7 +158,10 @@ int main(int argc, char *argv[])
 		switch (opt) {
 		case 'd':
 			usbip_use_debug = 1;
-			usbip_use_stderr = 1;
+			break;
+		case 'l':
+			usbip_use_syslog = 1;
+			openlog("", LOG_PID, LOG_USER);
 			break;
 		default:
 			goto err_out;
-- 
1.7.5.2

