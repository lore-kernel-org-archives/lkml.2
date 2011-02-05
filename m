Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753134Ab1BEOV7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 09:21:59 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54987 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753067Ab1BEOV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 09:21:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=JzAt1KFopVka6G8JswhRlwupFU1ubODpT3ilqEresWDldhy+swKZLl2FRPBKSLyCoY
         qjBGx8G9qcxy8/GmR6tkDJiu7dmMOXr4ArMQ3acxlEShQF1w9MqIRRTGYg2teQh8o/en
         yq2VG7P/WTccQq/+CBGjegVlbLa7LgZbjc124=
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, adobriyan@gmail.com
Subject: [PATCH 21/52] kstrtox: convert drivers/ide/
Date: Sat,  5 Feb 2011 16:20:24 +0200
Message-Id: <1296915654-7458-21-git-send-email-adobriyan@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1296915654-7458-1-git-send-email-adobriyan@gmail.com>
References: <1296915654-7458-1-git-send-email-adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 drivers/ide/ide-park.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/ide/ide-park.c b/drivers/ide/ide-park.c
index 88a380c..436ca71 100644
--- a/drivers/ide/ide-park.c
+++ b/drivers/ide/ide-park.c
@@ -113,11 +113,13 @@ ssize_t ide_park_store(struct device *dev, struct device_attribute *attr,
 {
 #define MAX_PARK_TIMEOUT 30000
 	ide_drive_t *drive = to_ide_device(dev);
-	long int input;
+	int input;
 	int rc;
 
-	rc = strict_strtol(buf, 10, &input);
-	if (rc || input < -2)
+	rc = kstrtoint(buf, 10, &input);
+	if (rc < 0)
+		return rc;
+	if (input < -2)
 		return -EINVAL;
 	if (input > MAX_PARK_TIMEOUT) {
 		input = MAX_PARK_TIMEOUT;
-- 
1.7.3.4

