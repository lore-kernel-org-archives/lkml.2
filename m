Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965826Ab2EOCTA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:19:00 -0400
Received: from mail1.windriver.com ([147.11.146.13]:53354 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965069Ab2EOCRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:17:13 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 090/179] i2c-taos-evm: Fix log messages
Date: Mon, 14 May 2012 22:13:06 -0400
Message-ID: <1337048075-6132-91-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean Delvare <khali@linux-fr.org>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 9b640f2e154268cb516efcaf9c434f2e73c6783e upstream.

* Print all error and information messages even when debugging is
  disabled.
* Don't use adapter device to log messages before it is ready.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/i2c/busses/i2c-taos-evm.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/i2c/busses/i2c-taos-evm.c b/drivers/i2c/busses/i2c-taos-evm.c
index dd39c1e..26c352a 100644
--- a/drivers/i2c/busses/i2c-taos-evm.c
+++ b/drivers/i2c/busses/i2c-taos-evm.c
@@ -234,7 +234,7 @@ static int taos_connect(struct serio *serio, struct serio_driver *drv)
 
 	if (taos->state != TAOS_STATE_IDLE) {
 		err = -ENODEV;
-		dev_dbg(&serio->dev, "TAOS EVM reset failed (state=%d, "
+		dev_err(&serio->dev, "TAOS EVM reset failed (state=%d, "
 			"pos=%d)\n", taos->state, taos->pos);
 		goto exit_close;
 	}
@@ -255,7 +255,7 @@ static int taos_connect(struct serio *serio, struct serio_driver *drv)
 					 msecs_to_jiffies(250));
 	if (taos->state != TAOS_STATE_IDLE) {
 		err = -ENODEV;
-		dev_err(&adapter->dev, "Echo off failed "
+		dev_err(&serio->dev, "TAOS EVM echo off failed "
 			"(state=%d)\n", taos->state);
 		goto exit_close;
 	}
@@ -263,7 +263,7 @@ static int taos_connect(struct serio *serio, struct serio_driver *drv)
 	err = i2c_add_adapter(adapter);
 	if (err)
 		goto exit_close;
-	dev_dbg(&serio->dev, "Connected to TAOS EVM\n");
+	dev_info(&serio->dev, "Connected to TAOS EVM\n");
 
 	taos->client = taos_instantiate_device(adapter);
 	return 0;
@@ -288,7 +288,7 @@ static void taos_disconnect(struct serio *serio)
 	serio_set_drvdata(serio, NULL);
 	kfree(taos);
 
-	dev_dbg(&serio->dev, "Disconnected from TAOS EVM\n");
+	dev_info(&serio->dev, "Disconnected from TAOS EVM\n");
 }
 
 static struct serio_device_id taos_serio_ids[] = {
-- 
1.7.9.6

