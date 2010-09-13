Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559Ab0IMTu7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 15:50:59 -0400
Received: from mail.perches.com ([173.55.12.10]:1905 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755367Ab0IMTsh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 15:48:37 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org
Subject: [PATCH 18/25] drivers/serial/suncore.c: Use static const char arrays
Date: Mon, 13 Sep 2010 12:47:56 -0700
Message-Id: <0ab674aa32a5fcc364982c78efdf44864a61523b.1284406639.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.rc1
In-Reply-To: <cover.1284406638.git.joe@perches.com>
References: <cover.1284406638.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/serial/suncore.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/serial/suncore.c b/drivers/serial/suncore.c
index 6381a02..f2a5b54 100644
--- a/drivers/serial/suncore.c
+++ b/drivers/serial/suncore.c
@@ -84,8 +84,8 @@ EXPORT_SYMBOL(sunserial_console_match);
 
 void sunserial_console_termios(struct console *con, struct device_node *uart_dp)
 {
+	char mode_prop[sizeof("ttyX-mode")];
 	const char *mode, *s;
-	char mode_prop[] = "ttyX-mode";
 	int baud, bits, stop, cflag;
 	char parity;
 
@@ -106,7 +106,7 @@ void sunserial_console_termios(struct console *con, struct device_node *uart_dp)
 		if (of_console_options)
 			c = *of_console_options;
 
-		mode_prop[3] = c;
+		sprintf(mode_prop, "tty%c-mode", c);
 
 		dp = of_find_node_by_path("/options");
 		mode = of_get_property(dp, mode_prop, NULL);
-- 
1.7.3.rc1

