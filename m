Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757841Ab2DYJwF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 05:52:05 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:48419 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757167Ab2DYJwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 05:52:03 -0400
From: Peter Korsgaard <jacmet@sunsite.dk>
To: grant.likely@secretlab.ca, linux-kernel@vger.kernel.org
Cc: Peter Korsgaard <jacmet@sunsite.dk>
Subject: [PATCH] gpio-mcp23s08: dbg_show: fix pullup configuration display
Date: Wed, 25 Apr 2012 11:51:53 +0200
Message-Id: <1335347513-5831-1-git-send-email-jacmet@sunsite.dk>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pullups are enabled when bits are set, not when cleared.

Signed-off-by: Peter Korsgaard <jacmet@sunsite.dk>
---
 drivers/gpio/gpio-mcp23s08.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-mcp23s08.c b/drivers/gpio/gpio-mcp23s08.c
index c5d83a8..0f42518 100644
--- a/drivers/gpio/gpio-mcp23s08.c
+++ b/drivers/gpio/gpio-mcp23s08.c
@@ -353,7 +353,7 @@ static void mcp23s08_dbg_show(struct seq_file *s, struct gpio_chip *chip)
 			chip->base + t, bank, t, label,
 			(mcp->cache[MCP_IODIR] & mask) ? "in " : "out",
 			(mcp->cache[MCP_GPIO] & mask) ? "hi" : "lo",
-			(mcp->cache[MCP_GPPU] & mask) ? "  " : "up");
+			(mcp->cache[MCP_GPPU] & mask) ? "up" : "  ");
 		/* NOTE:  ignoring the irq-related registers */
 		seq_printf(s, "\n");
 	}
-- 
1.7.10

