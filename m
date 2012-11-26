Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756631Ab2KZRDJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:03:09 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47264 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756573Ab2KZRDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:03:05 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jaehoon Chung <jh80.chung@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>, Chris Ball <cjb@laptop.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 053/270] mmc: sdhci-s3c: fix the wrong number of max bus clocks
Date: Mon, 26 Nov 2012 14:55:43 -0200
Message-Id: <1353949160-26803-54-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jaehoon Chung <jh80.chung@samsung.com>

commit 5feb54a1ab91a237e247c013b8c4fb100ea347b1 upstream.

We can use up to four bus-clocks; but on module remove, we didn't
disable the fourth bus clock.

Signed-off-by: Jaehoon Chung <jh80.chung@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Chris Ball <cjb@laptop.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/mmc/host/sdhci-s3c.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mmc/host/sdhci-s3c.c b/drivers/mmc/host/sdhci-s3c.c
index a50c205..02b7a4a 100644
--- a/drivers/mmc/host/sdhci-s3c.c
+++ b/drivers/mmc/host/sdhci-s3c.c
@@ -656,7 +656,7 @@ static int __devexit sdhci_s3c_remove(struct platform_device *pdev)
 
 	pm_runtime_disable(&pdev->dev);
 
-	for (ptr = 0; ptr < 3; ptr++) {
+	for (ptr = 0; ptr < MAX_BUS_CLK; ptr++) {
 		if (sc->clk_bus[ptr]) {
 			clk_disable(sc->clk_bus[ptr]);
 			clk_put(sc->clk_bus[ptr]);
-- 
1.7.9.5

