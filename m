Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752116Ab2FMFUY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 01:20:24 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:44144 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751679Ab2FMFUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 01:20:23 -0400
From: William Blair <wdblair@bu.edu>
To: acho@novell.com
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, William Blair <wdblair@bu.edu>
Subject: [PATCH] Staging: keucr: scsiglue: fixed a do while coding style issue
Date: Wed, 13 Jun 2012 01:16:49 -0400
Message-Id: <1339564609-5039-1-git-send-email-wdblair@bu.edu>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added a do ... while (0) to a multi statement macro and reformatted a similar macro.

Signed-off-by: William Blair <wdblair@bu.edu>
---
 drivers/staging/keucr/scsiglue.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/keucr/scsiglue.c b/drivers/staging/keucr/scsiglue.c
index e1f3931..083b20e 100644
--- a/drivers/staging/keucr/scsiglue.c
+++ b/drivers/staging/keucr/scsiglue.c
@@ -230,7 +230,10 @@ void usb_stor_report_bus_reset(struct us_data *us)
 /* we use this macro to help us write into the buffer */
 #undef SPRINTF
 #define SPRINTF(args...) \
-	do { if (pos < buffer+length) pos += sprintf(pos, ## args); } while (0)
+	do { \
+		if (pos < buffer+length) \
+			pos += sprintf(pos, ## args); \
+	} while (0)
 
 /*
  * proc_info()
@@ -279,8 +282,10 @@ static int proc_info(struct Scsi_Host *host, char *buffer, char **start,
 		pos += sprintf(pos, "       Quirks:");
 
 #define US_FLAG(name, value) \
-	if (us->fflags & value)\
-		pos += sprintf(pos, " " #name);
+	do { \
+		if (us->fflags & value) \
+			pos += sprintf(pos, " " #name); \
+	} while (0);
 US_DO_ALL_FLAGS
 #undef US_FLAG
 
-- 
1.7.6

