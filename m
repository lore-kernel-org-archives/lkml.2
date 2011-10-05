Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934167Ab1JEJTv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 05:19:51 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:32920 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934139Ab1JEJTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 05:19:50 -0400
Subject: [PATCH] leds: leds-lp5521: Avoid writing uninitialized value to
 LP5521_REG_OP_MODE register
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Samu Onkalo <samu.p.onkalo@nokia.com>, Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 05 Oct 2011 17:19:38 +0800
Message-ID: <1317806378.2834.6.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If lp5521_read fails, engine_state variable is not initialized.
If lp5521_read fails, we should return error.
This patch fixes below warning.

  CC      drivers/leds/leds-lp5521.o
drivers/leds/leds-lp5521.c: In function 'lp5521_set_engine_mode':
drivers/leds/leds-lp5521.c:168: warning: 'engine_state' may be used uninitialized in this function

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/leds/leds-lp5521.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/leds/leds-lp5521.c b/drivers/leds/leds-lp5521.c
index 9fc122c..89134d9 100644
--- a/drivers/leds/leds-lp5521.c
+++ b/drivers/leds/leds-lp5521.c
@@ -175,6 +175,8 @@ static int lp5521_set_engine_mode(struct lp5521_engine *engine, u8 mode)
 		mode = LP5521_CMD_DIRECT;
 
 	ret = lp5521_read(client, LP5521_REG_OP_MODE, &engine_state);
+	if (ret < 0)
+		return ret;
 
 	/* set mode only for this engine */
 	engine_state &= ~(engine->engine_mask);
-- 
1.7.4.1



