Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965902Ab2DLSpp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 14:45:45 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:1893 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965885Ab2DLSpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 14:45:42 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6678"; a="181149089"
From: David Brown <davidb@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-fbdev@vger.kernel.org
Subject: [PATCH 1/2] video: msm: Fix section mismatches in mddi.c
Date: Thu, 12 Apr 2012 11:45:33 -0700
Message-Id: <1334256334-8234-1-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The change
    commit 461cbe77d0a4f887c33a3a95ea68a7daf23b4302
    Author: Gregory Bean <gbean@codeaurora.org>
    Date:   Wed Jul 28 10:22:13 2010 -0700

        video: msm: Fix section mismatch in mddi.c.

fixes a section mismatch between the board file and the driver's probe
function, however, it misses the additional mismatches between the
probe function and some routines it calls.  Fix these up as well.

Signed-off-by: David Brown <davidb@codeaurora.org>
---
 drivers/video/msm/mddi.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/video/msm/mddi.c b/drivers/video/msm/mddi.c
index 4527cbf..b061d70 100644
--- a/drivers/video/msm/mddi.c
+++ b/drivers/video/msm/mddi.c
@@ -420,7 +420,7 @@ static void mddi_resume(struct msm_mddi_client_data *cdata)
 	mddi_set_auto_hibernate(&mddi->client_data, 1);
 }
 
-static int __init mddi_get_client_caps(struct mddi_info *mddi)
+static int __devinit mddi_get_client_caps(struct mddi_info *mddi)
 {
 	int i, j;
 
@@ -622,9 +622,9 @@ uint32_t mddi_remote_read(struct msm_mddi_client_data *cdata, uint32_t reg)
 
 static struct mddi_info mddi_info[2];
 
-static int __init mddi_clk_setup(struct platform_device *pdev,
-				 struct mddi_info *mddi,
-				 unsigned long clk_rate)
+static int __devinit mddi_clk_setup(struct platform_device *pdev,
+				    struct mddi_info *mddi,
+				    unsigned long clk_rate)
 {
 	int ret;
 
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

