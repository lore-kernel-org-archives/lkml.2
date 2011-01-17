Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752914Ab1AQKI6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 05:08:58 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:34325 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752573Ab1AQKIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 05:08:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=nIoeQeJJinpqG5iyd40jQYLxNnefLKjdCm4hem5B3GWeo3GTyJdAxBSonSsMkknA2L
         sqMb2GalFqYSwYVLWhnk1lQx0yxdMGBRAxc+0AYwVFZjOD4y45DzQhxZ9q7tRjCdQsPO
         nLegrEhZkiPHcSkTkFvqO/IpeqLU7ur5+kDOc=
From: Vasiliy Kulikov <segoon@openwall.com>
To: kernel-janitors@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ben Gardner <bgardner@wabtec.com>,
        Andres Salomon <dilinger@queued.net>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: cs5535_gpio: check put_user() return code
Date: Mon, 17 Jan 2011 13:08:49 +0300
Message-Id: <1295258929-31350-1-git-send-email-segoon@openwall.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

put_user() may fail, if so return -EFAULT.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
---
 Compile tested only.

 drivers/staging/cs5535_gpio/cs5535_gpio.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/cs5535_gpio/cs5535_gpio.c b/drivers/staging/cs5535_gpio/cs5535_gpio.c
index 0cf1e5f..b25f9d1 100644
--- a/drivers/staging/cs5535_gpio/cs5535_gpio.c
+++ b/drivers/staging/cs5535_gpio/cs5535_gpio.c
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

