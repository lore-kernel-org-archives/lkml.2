Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919Ab1HIQhB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 12:37:01 -0400
Received: from relay.pcl-ipout02.plus.net ([212.159.7.100]:7208 "EHLO
	relay.pcl-ipout02.plus.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752673Ab1HIQhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 12:37:00 -0400
X-Greylist: delayed 571 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Aug 2011 12:36:59 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap4lABpfQU7Unw4S/2dsb2JhbABCgh2CbJJmNY8ad4JAcTUYE4dvrXECh1OJLQ6GOASYDoRmhnw
Subject: [PATCH] mfd: asic3: Fix SD card resume after suspend
From: "Paul Parsons" <lost.distance@yahoo.com>
To: <linux-kernel@vger.kernel.org>
Cc: <philipp.zabel@gmail.com>, <sameo@linux.intel.com>, <mad_soft@inbox.ru>,
        <koen@dominion.thruhere.net>
Date: Tue, 09 Aug 2011 16:27:24 +0000
Content-Type: text/plain
Mime-Version: 1.0
X-Mailer: email v2.5.0 (Linux 2.6.39 x86_64 [http://email.cleancode.org])
Message-Id: <E1Qqp9K-0000wd-O4@outmx06.plus.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The mfd/asic3 driver did not define the suspend/resume handlers for the mmc cell
driver. Consequently the mmc driver did not resume properly after returning from
suspend, making sd cards unusable and preventing suspend from being entered a
second time. This patch adds the suspend/resume handlers, fixing the problem.

Signed-off-by: Paul Parsons <lost.distance@yahoo.com>
---

Thanks to Dmitry Artamonow for this fix.

diff -uprN clean-3.0.1/drivers/mfd/asic3.c linux-3.0.1/drivers/mfd/asic3.c
--- clean-3.0.1/drivers/mfd/asic3.c	2011-08-05 05:59:21.000000000 +0100
+++ linux-3.0.1/drivers/mfd/asic3.c	2011-08-07 23:34:38.036672007 +0100
@@ -779,6 +779,8 @@ static struct mfd_cell asic3_cell_mmc =
 	.name          = "tmio-mmc",
 	.enable        = asic3_mmc_enable,
 	.disable       = asic3_mmc_disable,
+	.suspend       = asic3_mmc_disable,
+	.resume        = asic3_mmc_enable,
 	.platform_data = &asic3_mmc_data,
 	.pdata_size    = sizeof(asic3_mmc_data),
 	.num_resources = ARRAY_SIZE(asic3_mmc_resources),

