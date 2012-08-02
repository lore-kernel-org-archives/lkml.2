Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850Ab2HBJSE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 05:18:04 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:18961 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753775Ab2HBJSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 05:18:02 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 02 Aug 2012 02:18:01 -0700
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: <swarren@nvidia.com>, <rob.herring@calxeda.com>,
        <linus.walleij@linaro.org>
CC: <vbyravarasu@nvidia.com>, <linux-i2c@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] i2c: muxes: fix build break
Date: Thu, 2 Aug 2012 14:42:17 +0530
Message-ID: <1343898737-24386-1-git-send-email-vbyravarasu@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seems a new parameter is added to i2c_add_mux_adapter().
All its references, except for the one present in
i2c-mux-pinctrl.c, were updated.
As this is causing build break, pushing current patch to fix it.

Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
---
 drivers/i2c/muxes/i2c-mux-pinctrl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/i2c/muxes/i2c-mux-pinctrl.c b/drivers/i2c/muxes/i2c-mux-pinctrl.c
index 46a6697..5f097f3 100644
--- a/drivers/i2c/muxes/i2c-mux-pinctrl.c
+++ b/drivers/i2c/muxes/i2c-mux-pinctrl.c
@@ -221,7 +221,7 @@ static int __devinit i2c_mux_pinctrl_probe(struct platform_device *pdev)
 				(mux->pdata->base_bus_num + i) : 0;
 
 		mux->busses[i] = i2c_add_mux_adapter(mux->parent, &pdev->dev,
-						     mux, bus, i,
+						     mux, bus, i, 0,
 						     i2c_mux_pinctrl_select,
 						     deselect);
 		if (!mux->busses[i]) {
-- 
1.7.1.1

