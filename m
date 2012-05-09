Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518Ab2EIGyY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 02:54:24 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52041 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646Ab2EIGyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 02:54:21 -0400
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-serial@vger.kernel.org
Cc: horms@verge.net.au, arnd@arndb.de, linux-sh@vger.kernel.org,
        gregkh@linuxfoundation.org, swarren@wwwdotorg.org,
        linux-kernel@vger.kernel.org, rjw@sisk.pl,
        paul.gortmaker@windriver.com, lethal@linux-sh.org, olof@lixom.net,
        Magnus Damm <magnus.damm@gmail.com>, dan.j.williams@intel.com,
        alan@linux.intel.com
Date: Wed, 09 May 2012 15:55:14 +0900
Message-Id: <20120509065514.18528.83245.sendpatchset@w520>
Subject: [PATCH] serial8250-em: Add DT support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

Update the 8250_em driver to support DT.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 Applies of top of "[PATCH] serial8250-em: Emma Mobile UART driver V2"
 (included in linux-next 20120508) and the recently posted
 "[PATCH] serial8250-em: clk_get() IS_ERR() error handling fix".

 drivers/tty/serial/8250/8250_em.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- 0002/drivers/tty/serial/8250/8250_em.c
+++ work/drivers/tty/serial/8250/8250_em.c	2012-05-09 15:39:22.000000000 +0900
@@ -163,9 +163,16 @@ static int __devexit serial8250_em_remov
 	return 0;
 }
 
+static const struct of_device_id serial8250_em_dt_ids[] __devinitconst = {
+	{ .compatible = "renesas,em-uart", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, serial8250_em_dt_ids);
+
 static struct platform_driver serial8250_em_platform_driver = {
 	.driver = {
 		.name		= "serial8250-em",
+		.of_match_table = serial8250_em_dt_ids,
 		.owner		= THIS_MODULE,
 	},
 	.probe			= serial8250_em_probe,
