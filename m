Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755930Ab1G0Vyv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 17:54:51 -0400
Received: from mga02.intel.com ([134.134.136.20]:16729 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755720Ab1G0VtT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 17:49:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,279,1309762800"; 
   d="scan'208";a="32826561"
From: Andi Kleen <andi@firstfloor.org>
References: <20110727247.325703029@firstfloor.org>
In-Reply-To: <20110727247.325703029@firstfloor.org>
To: khali@linux-fr.org, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [79/99] i2c-taos-evm: Fix log messages
Message-Id: <20110727214918.B49B02403FF@tassilo.jf.intel.com>
Date: Wed, 27 Jul 2011 14:49:18 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Jean Delvare <khali@linux-fr.org>

commit 9b640f2e154268cb516efcaf9c434f2e73c6783e upstream.

* Print all error and information messages even when debugging is
  disabled.
* Don't use adapter device to log messages before it is ready.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/i2c/busses/i2c-taos-evm.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux-2.6.35.y/drivers/i2c/busses/i2c-taos-evm.c
===================================================================
--- linux-2.6.35.y.orig/drivers/i2c/busses/i2c-taos-evm.c
+++ linux-2.6.35.y/drivers/i2c/busses/i2c-taos-evm.c
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
