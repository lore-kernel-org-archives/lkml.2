Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755561Ab2F1NKF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 09:10:05 -0400
Received: from mail-ee0-f74.google.com ([74.125.83.74]:45789 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754557Ab2F1NIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 09:08:31 -0400
From: Daniel Kurtz <djkurtz@chromium.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Nick Dyer <nick.dyer@itdev.co.uk>, Yufeng Shen <miletus@chromium.org>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>, Benson Leung <bleung@chromium.org>,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 01/23 v6] Input: atmel_mxt_ts - derive phys from i2c client adapter
Date: Thu, 28 Jun 2012 21:08:02 +0800
Message-Id: <1340888904-15620-2-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1340888904-15620-1-git-send-email-djkurtz@chromium.org>
References: <1340888904-15620-1-git-send-email-djkurtz@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows userspace to more easily distinguish which bus a particular
atmel_mxt_ts device is attached to.

The resulting phys will be something like:
 i2c-1-0067/input0

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index 42e6450..b1108ca 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -250,6 +250,7 @@ struct mxt_finger {
 struct mxt_data {
 	struct i2c_client *client;
 	struct input_dev *input_dev;
+	char phys[64];		/* device physical location */
 	const struct mxt_platform_data *pdata;
 	struct mxt_object *object_table;
 	struct mxt_info info;
@@ -1106,6 +1107,10 @@ static int __devinit mxt_probe(struct i2c_client *client,
 	}
 
 	input_dev->name = "Atmel maXTouch Touchscreen";
+	snprintf(data->phys, sizeof(data->phys), "i2c-%u-%04x/input0",
+		 client->adapter->nr, client->addr);
+	input_dev->phys = data->phys;
+
 	input_dev->id.bustype = BUS_I2C;
 	input_dev->dev.parent = &client->dev;
 	input_dev->open = mxt_input_open;
-- 
1.7.7.3

