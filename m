Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757333Ab2FZHCN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 03:02:13 -0400
Received: from mail-lb0-f202.google.com ([209.85.217.202]:44558 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757049Ab2FZG5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 02:57:19 -0400
From: Daniel Kurtz <djkurtz@chromium.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Nick Dyer <nick.dyer@itdev.co.uk>, linux-input@vger.kernel.org
Cc: Iiro Valkonen <iiro.valkonen@atmel.com>,
        Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Olof Johansson <olofj@chromium.org>, linux-kernel@vger.kernel.org,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 02/21 v5] Input: atmel_mxt_ts - use client name for irq
Date: Tue, 26 Jun 2012 14:56:50 +0800
Message-Id: <1340693829-18665-3-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1340693829-18665-1-git-send-email-djkurtz@chromium.org>
References: <1340693829-18665-1-git-send-email-djkurtz@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The atmel_mxt_ts driver can support multiple devices simultaneously.
Use the i2c_client name instead of the driver name when requesting an
interrupt to make the different interrupts distinguishable in
/proc/interrupts and top.

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index b1108ca..8b33f3a 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -1154,7 +1154,7 @@ static int __devinit mxt_probe(struct i2c_client *client,
 		goto err_free_object;
 
 	error = request_threaded_irq(client->irq, NULL, mxt_interrupt,
-			pdata->irqflags, client->dev.driver->name, data);
+			pdata->irqflags, client->name, data);
 	if (error) {
 		dev_err(&client->dev, "Failed to register interrupt\n");
 		goto err_free_object;
-- 
1.7.7.3

