Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428Ab2F1NJH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 09:09:07 -0400
Received: from mail-ey0-f202.google.com ([209.85.215.202]:37848 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754850Ab2F1NIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 09:08:32 -0400
From: Daniel Kurtz <djkurtz@chromium.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Nick Dyer <nick.dyer@itdev.co.uk>, Yufeng Shen <miletus@chromium.org>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>, Benson Leung <bleung@chromium.org>,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 02/23 v6] Input: atmel_mxt_ts - use client name for irq
Date: Thu, 28 Jun 2012 21:08:03 +0800
Message-Id: <1340888904-15620-3-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1340888904-15620-1-git-send-email-djkurtz@chromium.org>
References: <1340888904-15620-1-git-send-email-djkurtz@chromium.org>
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

