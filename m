Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758285Ab2FZHC5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 03:02:57 -0400
Received: from mail-ee0-f74.google.com ([74.125.83.74]:42589 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756593Ab2FZHCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 03:02:55 -0400
From: Daniel Kurtz <djkurtz@chromium.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Nick Dyer <nick.dyer@itdev.co.uk>, linux-input@vger.kernel.org
Cc: Iiro Valkonen <iiro.valkonen@atmel.com>,
        Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Olof Johansson <olofj@chromium.org>, linux-kernel@vger.kernel.org,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 03/21 v5] Input: atmel_mxt_ts - detect OOM when creating mt slots
Date: Tue, 26 Jun 2012 14:56:51 +0800
Message-Id: <1340693829-18665-4-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1340693829-18665-1-git-send-email-djkurtz@chromium.org>
References: <1340693829-18665-1-git-send-email-djkurtz@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hopefully this new code path will never be used, but better safe than
sorry...

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index 8b33f3a..926209c 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -1136,7 +1136,9 @@ static int __devinit mxt_probe(struct i2c_client *client,
 			     0, 255, 0, 0);
 
 	/* For multi touch */
-	input_mt_init_slots(input_dev, MXT_MAX_FINGER);
+	error = input_mt_init_slots(input_dev, MXT_MAX_FINGER);
+	if (error)
+		goto err_free_mem;
 	input_set_abs_params(input_dev, ABS_MT_TOUCH_MAJOR,
 			     0, MXT_MAX_AREA, 0, 0);
 	input_set_abs_params(input_dev, ABS_MT_POSITION_X,
-- 
1.7.7.3

