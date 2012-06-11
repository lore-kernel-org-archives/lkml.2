Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755915Ab2FKP11 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 11:27:27 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:35417 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755696Ab2FKPZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 11:25:42 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: linus.walleij@stericsson.com, arnd@arndb.de, grant.likely@secretlab.ca,
        Lee Jones <lee.jones@linaro.org>, linux-input@vger.kernel.org
Subject: [PATCH 10/14] Input: Add Device Tree support to the ab8500-ponkey driver
Date: Mon, 11 Jun 2012 16:25:03 +0100
Message-Id: <1339428307-3850-11-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1339428307-3850-1-git-send-email-lee.jones@linaro.org>
References: <1339428307-3850-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch will allow the ab8500-ponkey driver to be probed during
boot when Device Tree is enabled.

Cc: linux-input@vger.kernel.org
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/input/misc/ab8500-ponkey.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/input/misc/ab8500-ponkey.c b/drivers/input/misc/ab8500-ponkey.c
index 350fd0c..394aa1f 100644
--- a/drivers/input/misc/ab8500-ponkey.c
+++ b/drivers/input/misc/ab8500-ponkey.c
@@ -131,10 +131,16 @@ static int __devexit ab8500_ponkey_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static const struct of_device_id ab8500_ponkey_match[] = {
+	{ .compatible = "stericsson,ab8500-ponkey", },
+	{}
+};
+
 static struct platform_driver ab8500_ponkey_driver = {
 	.driver		= {
 		.name	= "ab8500-poweron-key",
 		.owner	= THIS_MODULE,
+		.of_match_table = ab8500_ponkey_match,
 	},
 	.probe		= ab8500_ponkey_probe,
 	.remove		= __devexit_p(ab8500_ponkey_remove),
-- 
1.7.9.5

