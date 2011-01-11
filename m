Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756041Ab1AKMoo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 07:44:44 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:45693 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754139Ab1AKMok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 07:44:40 -0500
From: Jamie Iles <jamie@jamieiles.com>
To: linux-kernel@vger.kernel.org
Cc: Jamie Iles <jamie@jamieiles.com>, Kukjin Kim <kgene.kim@samsung.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 08/16] ARM: samsung: serial: don't treat NULL clk as an error
Date: Tue, 11 Jan 2011 12:43:45 +0000
Message-Id: <1294749833-32019-9-git-send-email-jamie@jamieiles.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1294749833-32019-1-git-send-email-jamie@jamieiles.com>
References: <1294749833-32019-1-git-send-email-jamie@jamieiles.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

clk_get() returns a struct clk cookie to the driver and some platforms
may return NULL if they only support a single clock.  clk_get() has only
failed if it returns a ERR_PTR() encoded pointer.

Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org
Signed-off-by: Jamie Iles <jamie@jamieiles.com>
---
 drivers/serial/samsung.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/samsung.c b/drivers/serial/samsung.c
index 7ac2bf5..be93d2f 100644
--- a/drivers/serial/samsung.c
+++ b/drivers/serial/samsung.c
@@ -42,6 +42,7 @@
 #include <linux/serial.h>
 #include <linux/delay.h>
 #include <linux/clk.h>
+#include <linux/err.h>
 #include <linux/cpufreq.h>
 
 #include <asm/irq.h>
@@ -522,7 +523,7 @@ static int s3c24xx_serial_calcbaud(struct baud_calc *calc,
 	unsigned long rate;
 
 	calc->src = clk_get(port->dev, clksrc->name);
-	if (calc->src == NULL || IS_ERR(calc->src))
+	if (IS_ERR(calc->src))
 		return 0;
 
 	rate = clk_get_rate(calc->src);
-- 
1.7.3.4

