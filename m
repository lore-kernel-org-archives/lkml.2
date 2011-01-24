Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765Ab1AXMHW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 07:07:22 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:65517 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566Ab1AXMHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 07:07:20 -0500
From: Bernhard Walle <walle@corscience.de>
To: ben-linux@fluff.org
Cc: ddaney@caviumnetworks.com, ralf@linux-mips.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] i2c: octeon: Make the timeout 1*HZ instead of 1 jiffy
Date: Mon, 24 Jan 2011 13:05:41 +0100
Message-Id: <1295870741-19970-1-git-send-email-walle@corscience.de>
X-Mailer: git-send-email 1.7.1
X-Provags-ID: V02:K0:PtmzdNyzNYZ69YMN0wGE44jl9n7EakxnrGANbj2LlAj
 FidEfaba2dMxsTG3k9Q50ZkpcZ3SY2WQT0GYGsMTG1JovBFBBn
 OV4qyCLOSPkwgzEo2Xi1D7MiLhjp9GQc6x+xW+HflzlifCzL+A
 DA146Q56YKxtdBXp452jF4j/vnltYsRU0+yANU0rz/ldLJEwKO
 8FtRwfHG1LXciFf6SeUew==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the timeout in the struct i2c_adapter use jiffies as unit and a
timeout should be independent of CONFIG_HZ and most drivers that specify
a timeout here use just HZ, change the i2c-octeon driver to use 1*HZ
(which is a second), too.

Signed-off-by: Bernhard Walle <walle@corscience.de>
---
 drivers/i2c/busses/i2c-octeon.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/i2c/busses/i2c-octeon.c b/drivers/i2c/busses/i2c-octeon.c
index 0fe1102..537a4ee 100644
--- a/drivers/i2c/busses/i2c-octeon.c
+++ b/drivers/i2c/busses/i2c-octeon.c
@@ -460,7 +460,7 @@ static struct i2c_adapter octeon_i2c_ops = {
 	.owner = THIS_MODULE,
 	.name = "OCTEON adapter",
 	.algo = &octeon_i2c_algo,
-	.timeout = 2,
+	.timeout = HZ,
 };
 
 /**
-- 
1.7.1

