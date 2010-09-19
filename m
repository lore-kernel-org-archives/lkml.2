Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754703Ab0ISMzN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 08:55:13 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:58608 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754619Ab0ISMzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 08:55:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=pnrCY4JDnsdxiMkL+XY9vuS9wUAABegUhonD/taNaGA9hSmYkTSEitL1S9QmuGwWWF
         AQrMfAjaeqPgqHzrQoYLeqdc8Z75SlbZXXdxwuP1Uen7GBXubo5xnZ2EAc6+93kC/qp9
         i64WCmRt0a03Z+9d+Gg87wqFtY9UMGQt02CSU=
From: Vasiliy Kulikov <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Alessandro Zummo <a.zummo@towertech.it>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Aaro Koskinen <aaro.koskinen@nokia.com>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 09/14] rtc: fix device_register() error handling
Date: Sun, 19 Sep 2010 16:55:04 +0400
Message-Id: <1284900904-24579-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If device_register() fails then call put_device().
See comment to device_register.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
---
 compile tested.

 drivers/rtc/class.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/rtc/class.c b/drivers/rtc/class.c
index 565562b..e6539cb 100644
--- a/drivers/rtc/class.c
+++ b/drivers/rtc/class.c
@@ -158,8 +158,10 @@ struct rtc_device *rtc_device_register(const char *name, struct device *dev,
 	rtc_dev_prepare(rtc);
 
 	err = device_register(&rtc->dev);
-	if (err)
+	if (err) {
+		put_device(&rtc->dev);
 		goto exit_kfree;
+	}
 
 	rtc_dev_add_device(rtc);
 	rtc_sysfs_add_device(rtc);
-- 
1.7.0.4

