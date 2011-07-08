Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384Ab1GIF5E (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 01:57:04 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:37162 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752339Ab1GIFym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 01:54:42 -0400
X-Sasl-enc: 0piSMMY2MJhXYUoXQ9DcFuEX/JrLfIPNzYfGyt1vgQqp 1310190881
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Jul  8 15:51:20 2011
Message-Id: <20110708225120.376132309@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 08 Jul 2011 15:50:05 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jean Delvare <khali@linux-fr.org>
Subject: [16/35] i2c-taos-evm: Fix log messages
In-Reply-To: <20110708225343.GA14402@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Jean Delvare <khali@linux-fr.org>

commit 9b640f2e154268cb516efcaf9c434f2e73c6783e upstream.

* Print all error and information messages even when debugging is
  disabled.
* Don't use adapter device to log messages before it is ready.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/i2c/busses/i2c-taos-evm.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/i2c/busses/i2c-taos-evm.c
+++ b/drivers/i2c/busses/i2c-taos-evm.c
@@ -234,7 +234,7 @@ static int taos_connect(struct serio *se
 
 	if (taos->state != TAOS_STATE_IDLE) {
 		err = -ENODEV;
-		dev_dbg(&serio->dev, "TAOS EVM reset failed (state=%d, "
+		dev_err(&serio->dev, "TAOS EVM reset failed (state=%d, "
 			"pos=%d)\n", taos->state, taos->pos);
 		goto exit_close;
 	}
@@ -255,7 +255,7 @@ static int taos_connect(struct serio *se
 					 msecs_to_jiffies(250));
 	if (taos->state != TAOS_STATE_IDLE) {
 		err = -ENODEV;
-		dev_err(&adapter->dev, "Echo off failed "
+		dev_err(&serio->dev, "TAOS EVM echo off failed "
 			"(state=%d)\n", taos->state);
 		goto exit_close;
 	}
@@ -263,7 +263,7 @@ static int taos_connect(struct serio *se
 	err = i2c_add_adapter(adapter);
 	if (err)
 		goto exit_close;
-	dev_dbg(&serio->dev, "Connected to TAOS EVM\n");
+	dev_info(&serio->dev, "Connected to TAOS EVM\n");
 
 	taos->client = taos_instantiate_device(adapter);
 	return 0;
@@ -288,7 +288,7 @@ static void taos_disconnect(struct serio
 	serio_set_drvdata(serio, NULL);
 	kfree(taos);
 
-	dev_dbg(&serio->dev, "Disconnected from TAOS EVM\n");
+	dev_info(&serio->dev, "Disconnected from TAOS EVM\n");
 }
 
 static struct serio_device_id taos_serio_ids[] = {


