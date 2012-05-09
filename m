Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932262Ab2EIOi6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 10:38:58 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:65199 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932197Ab2EIOiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 10:38:55 -0400
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, horms@verge.net.au, linux-sh@vger.kernel.org,
        johnstul@us.ibm.com, rjw@sisk.pl, lethal@linux-sh.org,
        gregkh@linuxfoundation.org, olof@lixom.net,
        Magnus Damm <magnus.damm@gmail.com>, tglx@linutronix.de
Date: Wed, 09 May 2012 23:39:50 +0900
Message-Id: <20120509143950.27521.7949.sendpatchset@w520>
In-Reply-To: <20120509143926.27521.20342.sendpatchset@w520>
References: <20120509143926.27521.20342.sendpatchset@w520>
Subject: [PATCH 03/03] clocksource: em_sti: Add DT support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

Update the em-sti driver to support DT.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 drivers/clocksource/em_sti.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- 0015/drivers/clocksource/em_sti.c
+++ work/drivers/clocksource/em_sti.c	2012-05-09 22:52:47.000000000 +0900
@@ -403,11 +403,18 @@ static int __devexit em_sti_remove(struc
 	return -EBUSY; /* cannot unregister clockevent and clocksource */
 }
 
+static const struct of_device_id em_sti_dt_ids[] __devinitconst = {
+	{ .compatible = "renesas,em-sti", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, em_sti_dt_ids);
+
 static struct platform_driver em_sti_device_driver = {
 	.probe		= em_sti_probe,
 	.remove		= __devexit_p(em_sti_remove),
 	.driver		= {
 		.name	= "em_sti",
+		.of_match_table = em_sti_dt_ids,
 	}
 };
 
