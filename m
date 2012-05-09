Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754386Ab2EIGtI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 02:49:08 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:65087 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801Ab2EIGtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 02:49:04 -0400
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-serial@vger.kernel.org
Cc: horms@verge.net.au, arnd@arndb.de, linux-sh@vger.kernel.org,
        gregkh@linuxfoundation.org, swarren@wwwdotorg.org,
        linux-kernel@vger.kernel.org, rjw@sisk.pl,
        paul.gortmaker@windriver.com, lethal@linux-sh.org, olof@lixom.net,
        Magnus Damm <magnus.damm@gmail.com>, dan.j.williams@intel.com,
        alan@linux.intel.com
Date: Wed, 09 May 2012 15:49:57 +0900
Message-Id: <20120509064957.18494.11270.sendpatchset@w520>
Subject: [PATCH] serial8250-em: clk_get() IS_ERR() error handling fix
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

Update the 8250_em driver to correctly handle the case
where no clock is associated with the device.

The return value of clk_get() needs to be checked with
IS_ERR() to avoid NULL pointer referencing.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 Applies of top of "[PATCH] serial8250-em: Emma Mobile UART driver V2"
 included in linux-next 20120508.

 drivers/tty/serial/8250/8250_em.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- 0001/drivers/tty/serial/8250/8250_em.c
+++ work/drivers/tty/serial/8250/8250_em.c	2012-05-09 15:35:10.000000000 +0900
@@ -110,8 +110,9 @@ static int __devinit serial8250_em_probe
 	}
 
 	priv->sclk = clk_get(&pdev->dev, "sclk");
-	if (!priv->sclk) {
+	if (IS_ERR(priv->sclk)) {
 		dev_err(&pdev->dev, "unable to get clock\n");
+		ret = PTR_ERR(priv->sclk);
 		goto err1;
 	}
 
