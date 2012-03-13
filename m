Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758327Ab2CMATE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:19:04 -0400
Received: from mail.windriver.com ([147.11.1.11]:46986 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758295Ab2CMATB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:19:01 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Vasiliy Kulikov <segoon@openwall.com>,
        Andy Sharp <andy.sharp@onstor.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 042/196] drivers/rtc/rtc-ds1511.c: world-writable sysfs nvram file
Date: Mon, 12 Mar 2012 20:12:50 -0400
Message-Id: <1331597724-31358-43-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vasiliy Kulikov <segoon@openwall.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 49d50fb1c28738ef6bad0c2b87d5355a1653fed5 upstream.

Don't allow everybogy to write to NVRAM.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
Cc: Andy Sharp <andy.sharp@onstor.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/rtc/rtc-ds1511.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-ds1511.c b/drivers/rtc/rtc-ds1511.c
index 06b8566..fad05bd 100644
--- a/drivers/rtc/rtc-ds1511.c
+++ b/drivers/rtc/rtc-ds1511.c
@@ -483,7 +483,7 @@ ds1511_nvram_write(struct kobject *kobj, struct bin_attribute *bin_attr,
 static struct bin_attribute ds1511_nvram_attr = {
 	.attr = {
 		.name = "nvram",
-		.mode = S_IRUGO | S_IWUGO,
+		.mode = S_IRUGO | S_IWUSR,
 	},
 	.size = DS1511_RAM_MAX,
 	.read = ds1511_nvram_read,
-- 
1.7.9.3

