Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741Ab0FADXb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 23:23:31 -0400
Received: from mail.perches.com ([173.55.12.10]:2472 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753232Ab0FADX1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 23:23:27 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>,
       "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
       linux-i2c@vger.kernel.org
Subject: [PATCH 06/21] drivers/i2c/i2c-dev.c: Remove unnecessary kmalloc casts
Date: Mon, 31 May 2010 20:23:08 -0700
Message-Id: <ce6e7e3183f0756b14765076e63251e269e2c9f6.1275360951.git.joe@perches.com>
X-Mailer: git-send-email 1.7.0.3.311.g6a6955
In-Reply-To: <cover.1275360951.git.joe@perches.com>
References: <cover.1275360951.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/i2c/i2c-dev.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/i2c/i2c-dev.c b/drivers/i2c/i2c-dev.c
index e0694e4..b3fcb59 100644
--- a/drivers/i2c/i2c-dev.c
+++ b/drivers/i2c/i2c-dev.c
@@ -219,9 +219,7 @@ static noinline int i2cdev_ioctl_rdrw(struct i2c_client *client,
 	if (rdwr_arg.nmsgs > I2C_RDRW_IOCTL_MAX_MSGS)
 		return -EINVAL;
 
-	rdwr_pa = (struct i2c_msg *)
-		kmalloc(rdwr_arg.nmsgs * sizeof(struct i2c_msg),
-		GFP_KERNEL);
+	rdwr_pa = kmalloc(rdwr_arg.nmsgs * sizeof(struct i2c_msg), GFP_KERNEL);
 	if (!rdwr_pa)
 		return -ENOMEM;
 
-- 
1.7.0.3.311.g6a6955

