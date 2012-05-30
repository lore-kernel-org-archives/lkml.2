Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755750Ab2E3EtU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 00:49:20 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61499 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754320Ab2E3EtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 00:49:05 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, arnd@arndb.de,
        linus.walleij@stericsson.com, grant.likely@secretlab.ca,
        cjb@laptop.org, broonie@opensource.wolfsonmicro.com,
        sameo@linux.intel.com
Cc: Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 22/22] mfd: Enable DT probing of the DB8500 PRCMU
Date: Wed, 30 May 2012 12:47:40 +0800
Message-Id: <1338353260-10097-23-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1338353260-10097-1-git-send-email-lee.jones@linaro.org>
References: <1338353260-10097-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the correct compatible string for use during Device Tree
population. Without it the DB8500 PRCMU will not be probed.

Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/db8500-prcmu.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/mfd/db8500-prcmu.c b/drivers/mfd/db8500-prcmu.c
index 74595e1..01f01f3 100644
--- a/drivers/mfd/db8500-prcmu.c
+++ b/drivers/mfd/db8500-prcmu.c
@@ -2994,11 +2994,16 @@ static int __init db8500_prcmu_probe(struct platform_device *pdev)
 no_irq_return:
 	return err;
 }
+static const struct of_device_id db8500_prcmu_match[] = {
+	{ .compatible = "stericsson,db8500-prcmu"},
+	{ },
+};
 
 static struct platform_driver db8500_prcmu_driver = {
 	.driver = {
 		.name = "db8500-prcmu",
 		.owner = THIS_MODULE,
+		.of_match_table = db8500_prcmu_match,
 	},
 };
 
-- 
1.7.9.5

