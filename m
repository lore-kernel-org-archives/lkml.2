Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759209Ab2FAJN4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 05:13:56 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:4447 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759169Ab2FAJNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 05:13:49 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 01 Jun 2012 02:13:46 -0700
From: Prashant Gaikwad <pgaikwad@nvidia.com>
To: <swarren@nvidia.com>, <linux-tegra@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
CC: <linux-kernel@vger.kernel.org>, <olof@lixom.net>,
        Prashant Gaikwad <pgaikwad@nvidia.com>, <linux-input@vger.kernel.org>
Subject: [PATCH 5/9] Input: tegra-kbc - add clk_prepare/clk_unprepare
Date: Fri, 1 Jun 2012 14:42:44 +0530
Message-ID: <1338541968-7961-6-git-send-email-pgaikwad@nvidia.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1338541968-7961-1-git-send-email-pgaikwad@nvidia.com>
References: <1338541968-7961-1-git-send-email-pgaikwad@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use clk_prepare/clk_unprepare as required by the generic clk framework.

This patch should go through Tegra tree since other patches to port tegra
to generic clock framework are dependent on it. Posting here to get ack from
the maintainers.

Signed-off-by: Prashant Gaikwad <pgaikwad@nvidia.com>
---
 drivers/input/keyboard/tegra-kbc.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/input/keyboard/tegra-kbc.c b/drivers/input/keyboard/tegra-kbc.c
index 4ffe64d..2c1c9ed 100644
--- a/drivers/input/keyboard/tegra-kbc.c
+++ b/drivers/input/keyboard/tegra-kbc.c
@@ -492,7 +492,7 @@ static int tegra_kbc_start(struct tegra_kbc *kbc)
 	unsigned int debounce_cnt;
 	u32 val = 0;
 
-	clk_enable(kbc->clk);
+	clk_prepare_enable(kbc->clk);
 
 	/* Reset the KBC controller to clear all previous status.*/
 	tegra_periph_reset_assert(kbc->clk);
@@ -556,7 +556,7 @@ static void tegra_kbc_stop(struct tegra_kbc *kbc)
 	disable_irq(kbc->irq);
 	del_timer_sync(&kbc->timer);
 
-	clk_disable(kbc->clk);
+	clk_disable_unprepare(kbc->clk);
 }
 
 static int tegra_kbc_open(struct input_dev *dev)
-- 
1.7.4.1

