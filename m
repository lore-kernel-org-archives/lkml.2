Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932315Ab0LERvi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 12:51:38 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64682 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932276Ab0LERve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 12:51:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=SZpV8lThv3AUOrsEgeaICK99QoECfeMWoJTKGpVYIrxVkv4hgaA/bix+GHuYZunBfx
         xWQ4QsUJ9of68DeqIrLov8IHulFeVLXJ6TAdQno2vewL6m7vQlXOCiDeAO/E+OKyucfV
         1guEvgYKZ0fpHYyun4ylN30KS6a/qVp/QAsOU=
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 31/45] kstrtox: convert drivers/mmc/
Date: Sun,  5 Dec 2010 19:49:28 +0200
Message-Id: <1291571382-2719-31-git-send-email-adobriyan@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1291571382-2719-1-git-send-email-adobriyan@gmail.com>
References: <1291571382-2719-1-git-send-email-adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 drivers/mmc/card/mmc_test.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/card/mmc_test.c b/drivers/mmc/card/mmc_test.c
index 21adc27..108b72c 100644
--- a/drivers/mmc/card/mmc_test.c
+++ b/drivers/mmc/card/mmc_test.c
@@ -2173,7 +2173,7 @@ static ssize_t mtf_test_write(struct file *file, const char __user *buf,
 	struct mmc_card *card = (struct mmc_card *)sf->private;
 	struct mmc_test_card *test;
 	char lbuf[12];
-	long testcase;
+	int testcase;
 
 	if (count >= sizeof(lbuf))
 		return -EINVAL;
@@ -2182,7 +2182,7 @@ static ssize_t mtf_test_write(struct file *file, const char __user *buf,
 		return -EFAULT;
 	lbuf[count] = '\0';
 
-	if (strict_strtol(lbuf, 10, &testcase))
+	if (kstrtoint(lbuf, 10, &testcase))
 		return -EINVAL;
 
 	test = kzalloc(sizeof(struct mmc_test_card), GFP_KERNEL);
-- 
1.7.2.2

