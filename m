Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807Ab0GZIZo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 04:25:44 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:44416 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121Ab0GZIZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 04:25:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=AdMsSOWTozOuNjSlIZi4br3IATNMQ46dmkmKn4JmJQgeKPM7ISG3wH2vqB/2afskBQ
         j2BKNNtT7htP0/VN6FIEPpV8YzJkp5caI2HjAGian62RdFdLpzMwys3KUl43pxpJ7ear
         C+3C1Azj9bcsR9da25vaRmzfbeaxUY4P01hz4=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        Tejun Heo <tj@kernel.org>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] i2c-davinci: use schedule_timeout_uninterruptible()
Date: Mon, 26 Jul 2010 12:24:42 +0400
Message-Id: <1280132682-8055-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

i2c_davinci_wait_bus_not_busy() uses schedule_timeout() without setting
state to STATE_(UN)INTERRUPTIBLE. As it is called in cycle without
checking of pending signals, use schedule_timeout_uninterruptible().

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/i2c/busses/i2c-davinci.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/i2c/busses/i2c-davinci.c b/drivers/i2c/busses/i2c-davinci.c
index 4523364..1d376a5 100644
--- a/drivers/i2c/busses/i2c-davinci.c
+++ b/drivers/i2c/busses/i2c-davinci.c
@@ -231,7 +231,7 @@ static int i2c_davinci_wait_bus_not_busy(struct davinci_i2c_dev *dev,
 			return -ETIMEDOUT;
 		}
 		if (allow_sleep)
-			schedule_timeout(1);
+			schedule_timeout_uninterruptible(1);
 	}
 
 	return 0;
-- 
1.7.0.4

