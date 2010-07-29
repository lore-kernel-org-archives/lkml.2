Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757895Ab0G2Pzi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 11:55:38 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:62277 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757614Ab0G2Pzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 11:55:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=q8lzbVDYTn7hMKiSsDzVHR9IfKxwJfqkwKxHTmrBK/onw3HTX24j2H86Z8AzNFoL88
         Tpidcj9Ujv+9kQMpRL9WVIrtd/ArCc4jUdfJWn0vl6LXfTWzdMJMomaUlXq8c3BrxGv2
         2e+GG5dPKMLPtGV4moTl+4t78pM/b3y8jkhhg=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: [PATCH] char: cs5535_gpio: check put_user() result
Date: Thu, 29 Jul 2010 19:55:15 +0400
Message-Id: <1280418915-5674-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

put_user() may fail, if so return -EFAULT.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/char/cs5535_gpio.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/char/cs5535_gpio.c b/drivers/char/cs5535_gpio.c
index 4d830dc..fb7b888 100644
--- a/drivers/char/cs5535_gpio.c
+++ b/drivers/char/cs5535_gpio.c
@@ -146,7 +146,8 @@ static ssize_t cs5535_gpio_read(struct file *file, char __user *buf,
 
 	/* add a line-feed if there is room */
 	if ((i == ARRAY_SIZE(rm)) && (count < len)) {
-		put_user('\n', buf + count);
+		if (put_user('\n', buf + count))
+			return -EFAULT;
 		count++;
 	}
 
-- 
1.7.0.4

