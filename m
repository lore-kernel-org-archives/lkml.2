Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756581Ab1EIAdY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 20:33:24 -0400
Received: from mga11.intel.com ([192.55.52.93]:62381 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755357Ab1EIAdV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 20:33:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,337,1301900400"; 
   d="scan'208";a="919712978"
From: Samuel Ortiz <sameo@linux.intel.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Philipp Zabel <philipp.zabel@gmail.com>
Subject: [PATCH 06/19] mfd: Pass htc-pasic3 led platform data through the cell platform_data
Date: Mon,  9 May 2011 02:31:58 +0200
Message-Id: <1304901131-7104-7-git-send-email-sameo@linux.intel.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1304901131-7104-1-git-send-email-sameo@linux.intel.com>
References: <1304901131-7104-1-git-send-email-sameo@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Philipp Zabel <philipp.zabel@gmail.com>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/mfd/htc-pasic3.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/htc-pasic3.c b/drivers/mfd/htc-pasic3.c
index 95a4ff4..2808bd1 100644
--- a/drivers/mfd/htc-pasic3.c
+++ b/drivers/mfd/htc-pasic3.c
@@ -173,6 +173,8 @@ static int __init pasic3_probe(struct platform_device *pdev)
 	}
 
 	if (pdata && pdata->led_pdata) {
+		led_cell.platform_data = pdata->led_pdata;
+		led_cell.pdata_size = sizeof(struct pasic3_leds_machinfo);
 		ret = mfd_add_devices(&pdev->dev, pdev->id, &led_cell, 1, r, 0);
 		if (ret < 0)
 			dev_warn(dev, "failed to register LED device\n");
-- 
1.7.2.3

