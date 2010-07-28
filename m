Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904Ab0G1RWV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 13:22:21 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:11783 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753706Ab0G1RWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 13:22:16 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6057"; a="49089612"
From: Gregory Bean <gbean@codeaurora.org>
To: dwalker@codeaurora.org
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Gregory Bean <gbean@codeaurora.org>
Subject: [PATCH 2/2] video: msm: Fix section mismatch in mddi.c.
Date: Wed, 28 Jul 2010 10:22:13 -0700
Message-Id: <1280337733-18707-2-git-send-email-gbean@codeaurora.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1280337733-18707-1-git-send-email-gbean@codeaurora.org>
References: <1280337733-18707-1-git-send-email-gbean@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Repair a section mismatch between the mddi driver's
platform_driver structure and its probe method.

Signed-off-by: Gregory Bean <gbean@codeaurora.org>
---
 drivers/video/msm/mddi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/msm/mddi.c b/drivers/video/msm/mddi.c
index 844eff3..7c316c3 100644
--- a/drivers/video/msm/mddi.c
+++ b/drivers/video/msm/mddi.c
@@ -668,7 +668,7 @@ static int __init mddi_rev_data_setup(struct mddi_info *mddi)
 	return 0;
 }
 
-static int __init mddi_probe(struct platform_device *pdev)
+static int __devinit mddi_probe(struct platform_device *pdev)
 {
 	struct msm_mddi_platform_data *pdata = pdev->dev.platform_data;
 	struct mddi_info *mddi = &mddi_info[pdev->id];
-- 
1.7.0.4

--
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
