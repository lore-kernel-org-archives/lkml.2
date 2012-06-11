Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755603Ab2FKPZe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 11:25:34 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:61246 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755444Ab2FKPZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 11:25:32 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: linus.walleij@stericsson.com, arnd@arndb.de, grant.likely@secretlab.ca,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 05/14] mfd: Enable DT probing of the DB8500 PRCMU
Date: Mon, 11 Jun 2012 16:24:58 +0100
Message-Id: <1339428307-3850-6-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1339428307-3850-1-git-send-email-lee.jones@linaro.org>
References: <1339428307-3850-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the correct compatible string for use during Device Tree
population. Without it the DB8500 PRCMU will not be probed.

Cc: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/db8500-prcmu.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/mfd/db8500-prcmu.c b/drivers/mfd/db8500-prcmu.c
index 50e83dc5..c702f18 100644
--- a/drivers/mfd/db8500-prcmu.c
+++ b/drivers/mfd/db8500-prcmu.c
@@ -3004,11 +3004,16 @@ static int __devinit db8500_prcmu_probe(struct platform_device *pdev)
 no_irq_return:
 	return err;
 }
+static const struct of_device_id db8500_prcmu_match[] = {
+	{ .compatible = "stericsson,db8500-prcmu", },
+	{ },
+};
 
 static struct platform_driver db8500_prcmu_driver = {
 	.driver = {
 		.name = "db8500-prcmu",
 		.owner = THIS_MODULE,
+		.of_match_table = db8500_prcmu_match,
 	},
 	.probe = db8500_prcmu_probe,
 };
-- 
1.7.9.5

