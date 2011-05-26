Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932329Ab1EZNSV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 09:18:21 -0400
Received: from qmta05.emeryville.ca.mail.comcast.net ([76.96.30.48]:39051 "EHLO
	qmta05.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757830Ab1EZNRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 09:17:44 -0400
From: matt mooney <mfm@muteddisk.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: Arjan Mels <arjan.mels@nxp.com>, usbip-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/6] staging: usbip: userspace: usbipd.c: add header into source file
Date: Thu, 26 May 2011 06:17:12 -0700
Message-Id: <c4e56066bd69988c67cc03a06ccba295d2568724.1306414175.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <cover.1306414175.git.mfm@muteddisk.com>
References: <cover.1306414175.git.mfm@muteddisk.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The old usbip.h header that was only used to masked what each source
file needed has been changed. So some headers this file needed had to
be added.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 drivers/staging/usbip/userspace/src/usbipd.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/usbip/userspace/src/usbipd.c b/drivers/staging/usbip/userspace/src/usbipd.c
index ec9faac..ccc7dfd 100644
--- a/drivers/staging/usbip/userspace/src/usbipd.c
+++ b/drivers/staging/usbip/userspace/src/usbipd.c
@@ -7,6 +7,7 @@
 #include "../config.h"
 #endif
 
+#include <errno.h>
 #include <unistd.h>
 #include <netdb.h>
 #include <strings.h>
@@ -23,16 +24,15 @@
 
 #define _GNU_SOURCE
 #include <getopt.h>
+#include <glib.h>
 #include <signal.h>
 
-#include "usbip.h"
+#include "stub_driver.h"
+#include "usbip_common.h"
 #include "usbip_network.h"
 
-#include <glib.h>
-
 static const char version[] = PACKAGE_STRING;
 
-
 static int send_reply_devlist(int sockfd)
 {
 	int ret;
-- 
1.7.5.1

