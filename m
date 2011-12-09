Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835Ab1LIUct (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 15:32:49 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51651 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922Ab1LIUcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 15:32:47 -0500
From: Wolfram Sang <w.sang@pengutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net
Subject: [PATCH 1/4] spi/ath79: fix compile error due to missing include
Date: Fri,  9 Dec 2011 21:32:32 +0100
Message-Id: <1323462755-14369-2-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1323462755-14369-1-git-send-email-w.sang@pengutronix.de>
References: <1323462755-14369-1-git-send-email-w.sang@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gabor Juhos <juhosg@openwrt.org>

Whithout including 'linux/module.h' spi-ath79 driver fails to compile
with the these errors:

drivers/spi/spi-ath79.c:273:12: error: 'THIS_MODULE' undeclared here (not in a function)
drivers/spi/spi-ath79.c:278:20: error: expected declaration specifiers or '...' before string constant
drivers/spi/spi-ath79.c:278:1: warning: data definition has no type or storage class
drivers/spi/spi-ath79.c:278:1: warning: type defaults to 'int' in declaration of 'MODULE_DESCRIPTION'
drivers/spi/spi-ath79.c:278:20: warning: function declaration isn't a prototype
drivers/spi/spi-ath79.c:279:15: error: expected declaration specifiers or '...' before string constant
drivers/spi/spi-ath79.c:279:1: warning: data definition has no type or storage class
drivers/spi/spi-ath79.c:279:1: warning: type defaults to 'int' in declaration of 'MODULE_AUTHOR'
drivers/spi/spi-ath79.c:279:15: warning: function declaration isn't a prototype
drivers/spi/spi-ath79.c:280:16: error: expected declaration specifiers or '...' before string constant
drivers/spi/spi-ath79.c:280:1: warning: data definition has no type or storage class
drivers/spi/spi-ath79.c:280:1: warning: type defaults to 'int' in declaration of 'MODULE_LICENSE'
drivers/spi/spi-ath79.c:280:16: warning: function declaration isn't a prototype
drivers/spi/spi-ath79.c:281:14: error: expected declaration specifiers or '...' before string constant
drivers/spi/spi-ath79.c:281:1: warning: data definition has no type or storage class
drivers/spi/spi-ath79.c:281:1: warning: type defaults to 'int' in declaration of 'MODULE_ALIAS'
drivers/spi/spi-ath79.c:281:14: warning: function declaration isn't a prototype

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
---
 drivers/spi/spi-ath79.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/spi/spi-ath79.c b/drivers/spi/spi-ath79.c
index 024b48a..acc88b4 100644
--- a/drivers/spi/spi-ath79.c
+++ b/drivers/spi/spi-ath79.c
@@ -13,6 +13,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/module.h>
 #include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/spinlock.h>
-- 
1.7.2.5

