Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932077Ab0LERvN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 12:51:13 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64682 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756930Ab0LERvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 12:51:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=lLqo/4Xc8+XgGOYJFbrOJRATM90N/hSEgHFtiJ/l5h8KNKXfFsACw4O6CosHUG52vi
         /1J22rS33MoISNWJ3Syf7THGs96u6ugwFm/jLAliQJlewG208c47zKQoiH6f5xztPRZ9
         C19mch3nkSDdaajIa4dKCkkOb5shPsGKiHB6Y=
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 23/45] kstrtox: convert drivers/ide/
Date: Sun,  5 Dec 2010 19:49:20 +0200
Message-Id: <1291571382-2719-23-git-send-email-adobriyan@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1291571382-2719-1-git-send-email-adobriyan@gmail.com>
References: <1291571382-2719-1-git-send-email-adobriyan@gmail.com>
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
1.7.2.2

