Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030382Ab2HIOdW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 10:33:22 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:30780 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932419Ab2HIOdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 10:33:18 -0400
X-AuditID: cbfee61a-b7fc66d0000043b7-75-5023ca2c15bc
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: core: request only valid gpio pins for regulator
 enable
Date: Thu, 09 Aug 2012 16:33:00 +0200
Message-id: <1344522780-32079-1-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.10
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFJMWRmVeSWpSXmKPExsVy+t9jAV2dU8oBBrc71C0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfG1Bdv2Au6OCuuTVzH2MB4lL2LkZNDQsBEYsuXpSwQtpjEhXvr
	2UBsIYFFjBILrxZ2MXIB2auZJG5M3Q9WxCZgKNH1tgusSERAQWJz7zNWkCJmgQmMEs9OnwZL
	CAuESsyb9BjMZhFQlfiyfy8riM0r4CHx5v0iJoht8hJP7/exTWDkXsDIsIpRNLUguaA4KT3X
	UK84Mbe4NC9dLzk/dxMj2IfPpHYwrmywOMQowMGoxMOrsUEpQIg1say4MvcQowQHs5II750+
	5QAh3pTEyqrUovz4otKc1OJDjNIcLErivMbeX/2FBNITS1KzU1MLUotgskwcnFINjKWvN4QL
	X7q4hEHqxiPTc2v098YFvT94xnrtu4N6C55cfbnvwlPR6oSHW4tdFc4xbpv7eU/RqU9qapw8
	e0Lec8ywedqlr+BdyzX569MwnakqGuxs0/Iq9vxjPCPLIlxSOFPTXeHxZ6YaJXFHdwMBPzme
	Am6zIutK8c9pSx4sWZu4apnyqpyTW5VYijMSDbWYi4oTAU7NFyTdAQAA
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 65f735082de3 ("regulator: core: Add core support for GPIO controlled
enable lines") introduced enable gpio entry in regulator configuration
structure. Some drivers use '-1' as a placeholder for marking that such
gpio line is not available, because '0' is considered as a valid gpio
number. This patch fixes initialization of such drivers (like MAX8952
on UniversalC210 board), when '-1' is provided as enable gpio pin in the
regulator's platform data.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/regulator/core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index f092588..4838531 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -3217,7 +3217,7 @@ regulator_register(const struct regulator_desc *regulator_desc,
 
 	dev_set_drvdata(&rdev->dev, rdev);
 
-	if (config->ena_gpio) {
+	if (config->ena_gpio && gpio_is_valid(config->ena_gpio)) {
 		ret = gpio_request_one(config->ena_gpio,
 				       GPIOF_DIR_OUT | config->ena_gpio_flags,
 				       rdev_get_name(rdev));
-- 
1.7.1.569.g6f426

