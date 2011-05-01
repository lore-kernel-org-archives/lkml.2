Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760903Ab1EAQNn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 12:13:43 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:56724 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752739Ab1EAQNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 12:13:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=LbfW3zd4jjlbGjP+mGCV0FWJrTiz60kDJkoHAVQnpr/mJxiFElkC4UMIsbSE8WUpJZ
         uCHi5gPeE41YnY0LUlFbWB0WhMIrKQIsgA7TqUWTSwfMguZuQPx0yqBVn4SXLZ4PD7Wx
         iAUJ9gjoMNh9hf+ZXulEVFXdB0Fpkj/atzbJE=
Subject: [PATCH] Input: h3600_ts: fix a leak of the IRQ during init failure
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 02 May 2011 00:13:32 +0800
Message-ID: <1304266412.3000.4.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In h3600ts_connect error path, free_irq() was using ts->dev rather than the
&ts->dev as the data pointer so free_irq() wouldn't have matched.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/input/touchscreen/h3600_ts_input.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/input/touchscreen/h3600_ts_input.c b/drivers/input/touchscreen/h3600_ts_input.c
index 45f93d0..e45ae38 100644
--- a/drivers/input/touchscreen/h3600_ts_input.c
+++ b/drivers/input/touchscreen/h3600_ts_input.c
@@ -424,8 +424,8 @@ static int h3600ts_connect(struct serio *serio, struct serio_driver *drv)
 
 fail4:	serio_close(serio);
 fail3:	serio_set_drvdata(serio, NULL);
-	free_irq(IRQ_GPIO_BITSY_NPOWER_BUTTON, ts->dev);
-fail2:	free_irq(IRQ_GPIO_BITSY_ACTION_BUTTON, ts->dev);
+	free_irq(IRQ_GPIO_BITSY_NPOWER_BUTTON, &ts->dev);
+fail2:	free_irq(IRQ_GPIO_BITSY_ACTION_BUTTON, &ts->dev);
 fail1:	input_free_device(input_dev);
 	kfree(ts);
 	return err;
-- 
1.7.1



