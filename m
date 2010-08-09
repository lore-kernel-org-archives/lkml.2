Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756755Ab0HIUWh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 16:22:37 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:51827 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752713Ab0HIUWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 16:22:36 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6069"; a="50419006"
Subject: [GIT PULL] MSM video fixes for v2.6.36
From: Daniel Walker <dwalker@codeaurora.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 Aug 2010 13:22:23 -0700
Message-ID: <1281385343.4256.33.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull a couple of trial fixes for the MSM video driver.

Thanks!

The following changes since commit 7e27d6e778cd87b6f2415515d7127eba53fe5d02:

  Linux 2.6.35-rc3 (2010-06-11 19:14:04 -0700)

are available in the git repository at:
  git://codeaurora.org/quic/kernel/dwalker/linux-msm.git msm-video

Daniel Walker (1):
      drivers: video: msm: drop some unused variables

Gregory Bean (1):
      video: msm: Fix section mismatch in mddi.c.

 drivers/video/msm/mddi.c |    4 +---
 drivers/video/msm/mdp.c  |    1 -
 2 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/video/msm/mddi.c b/drivers/video/msm/mddi.c
index c1ff271..7c316c3 100644
--- a/drivers/video/msm/mddi.c
+++ b/drivers/video/msm/mddi.c
@@ -187,10 +187,8 @@ static void mddi_wait_interrupt(struct mddi_info *mddi, uint32_t intmask);
 
 static void mddi_handle_rev_data_avail(struct mddi_info *mddi)
 {
-	union mddi_rev *rev = mddi->rev_data;
 	uint32_t rev_data_count;
 	uint32_t rev_crc_err_count;
-	int i;
 	struct reg_read_info *ri;
 	size_t prev_offset;
 	uint16_t length;
@@ -670,7 +668,7 @@ static int __init mddi_rev_data_setup(struct mddi_info *mddi)
 	return 0;
 }
 
-static int __init mddi_probe(struct platform_device *pdev)
+static int __devinit mddi_probe(struct platform_device *pdev)
 {
 	struct msm_mddi_platform_data *pdata = pdev->dev.platform_data;
 	struct mddi_info *mddi = &mddi_info[pdev->id];
diff --git a/drivers/video/msm/mdp.c b/drivers/video/msm/mdp.c
index 19c01c6..3c28db0 100644
--- a/drivers/video/msm/mdp.c
+++ b/drivers/video/msm/mdp.c
@@ -258,7 +258,6 @@ int get_img(struct mdp_img *img, struct fb_info *info,
 {
 	int put_needed, ret = 0;
 	struct file *file;
-	unsigned long vstart;
 
 	file = fget_light(img->memory_id, &put_needed);
 	if (file == NULL)

-- 
Sent by an consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

