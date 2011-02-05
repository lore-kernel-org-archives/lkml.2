Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409Ab1BEO14 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 09:27:56 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57576 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753186Ab1BEOWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 09:22:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=kF5arDe0rJcCUpuN7OlTf7rLRUjA8/6HfJa8mXQ+25cl5PsmOT6UU6Cy8e00QcISLD
         BHd1CCzGEoUKMwmpkJrqjbGnvXq+p1pBxHiJgysQfvxoZpO4YraqZ3CZY/O5g41sB1J9
         VvpJ/aGDD20Ft0QBJ7XGQ+MQaY/FuBBmC9zFY=
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, adobriyan@gmail.com
Subject: [PATCH 26/52] kstrtox: convert drivers/macintosh/
Date: Sat,  5 Feb 2011 16:20:29 +0200
Message-Id: <1296915654-7458-26-git-send-email-adobriyan@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1296915654-7458-1-git-send-email-adobriyan@gmail.com>
References: <1296915654-7458-1-git-send-email-adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 drivers/macintosh/ams/ams-input.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/macintosh/ams/ams-input.c b/drivers/macintosh/ams/ams-input.c
index 8a71239..d4a6a64 100644
--- a/drivers/macintosh/ams/ams-input.c
+++ b/drivers/macintosh/ams/ams-input.c
@@ -116,10 +116,13 @@ static ssize_t ams_input_show_joystick(struct device *dev,
 static ssize_t ams_input_store_joystick(struct device *dev,
 	struct device_attribute *attr, const char *buf, size_t count)
 {
-	unsigned long enable;
-	int error = 0;
+	unsigned int enable;
+	int error;
 
-	if (strict_strtoul(buf, 0, &enable) || enable > 1)
+	error = kstrtouint(buf, 0, &enable);
+	if (error < 0)
+		return error;
+	if (enable > 1)
 		return -EINVAL;
 
 	mutex_lock(&ams_input_mutex);
-- 
1.7.3.4

