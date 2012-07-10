Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277Ab2GJL3F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 07:29:05 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:6157 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755202Ab2GJL14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 07:27:56 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 10 Jul 2012 04:27:19 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <w.sang@pengutronix.de>, <khali@linux-fr.org>, <ben-linux@fluff.org>
CC: <swarren@nvidia.com>, <linux-i2c@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 3/5] i2c: tegra: use of_match_ptr() for match_table initialization
Date: Tue, 10 Jul 2012 16:50:42 +0530
Message-ID: <1341919244-23327-4-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1341919244-23327-1-git-send-email-ldewangan@nvidia.com>
References: <1341919244-23327-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In place of defining match_table for non-DT based as NULL,
use of_match_ptr() for initialzing the of_match_table.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/i2c/busses/i2c-tegra.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/i2c/busses/i2c-tegra.c b/drivers/i2c/busses/i2c-tegra.c
index d071cf0..0792674 100644
--- a/drivers/i2c/busses/i2c-tegra.c
+++ b/drivers/i2c/busses/i2c-tegra.c
@@ -754,8 +754,6 @@ static const struct of_device_id tegra_i2c_of_match[] __devinitconst = {
 	{},
 };
 MODULE_DEVICE_TABLE(of, tegra_i2c_of_match);
-#else
-#define tegra_i2c_of_match NULL
 #endif
 
 static struct platform_driver tegra_i2c_driver = {
@@ -768,7 +766,7 @@ static struct platform_driver tegra_i2c_driver = {
 	.driver  = {
 		.name  = "tegra-i2c",
 		.owner = THIS_MODULE,
-		.of_match_table = tegra_i2c_of_match,
+		.of_match_table = of_match_ptr(tegra_i2c_of_match),
 	},
 };
 
-- 
1.7.1.1

