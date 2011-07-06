Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004Ab1GFF7L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 01:59:11 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:58733 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622Ab1GFF7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 01:59:10 -0400
Subject: [PATCH] backlight: aat2870_bl: fix error checking for
 backlight_device_register
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Richard Purdie <rpurdie@rpsys.net>, Jin Park <jinyoungp@nvidia.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Jul 2011 13:59:00 +0800
Message-ID: <1309931940.6088.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

backlight_device_register() returns ERR_PTR() on error.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/video/backlight/aat2870_bl.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/video/backlight/aat2870_bl.c b/drivers/video/backlight/aat2870_bl.c
index 4952a61..f13a3f7 100644
--- a/drivers/video/backlight/aat2870_bl.c
+++ b/drivers/video/backlight/aat2870_bl.c
@@ -158,10 +158,10 @@ static int aat2870_bl_probe(struct platform_device *pdev)
 	props.type = BACKLIGHT_RAW;
 	bd = backlight_device_register("aat2870-backlight", &pdev->dev,
 				       aat2870_bl, &aat2870_bl_ops, &props);
-	if (!bd) {
+	if (IS_ERR(bd)) {
 		dev_err(&pdev->dev,
 			"Failed allocate memory for backlight device\n");
-		ret = -ENOMEM;
+		ret = PTR_ERR(bd);
 		goto out_kfree;
 	}
 
-- 
1.7.4.1



