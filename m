Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756647Ab2IFIip (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 04:38:45 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:56784 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755460Ab2IFIim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 04:38:42 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: peter.senna@gmail.com, Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] drivers/media/platform/s5p-tv/sdo_drv.c: fix error return code
Date: Thu,  6 Sep 2012 10:38:29 +0200
Message-Id: <1346920709-8711-1-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1346775269-12191-4-git-send-email-peter.senna@gmail.com>
References: <1346775269-12191-4-git-send-email-peter.senna@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Senna Tschudin <peter.senna@gmail.com>

Convert a nonnegative error return code to a negative one, as returned
elsewhere in the function.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
(
if@p1 (\(ret < 0\|ret != 0\))
 { ... return ret; }
|
ret@p1 = 0
)
... when != ret = e1
    when != &ret
*if(...)
{
  ... when != ret = e2
      when forall
 return ret;
}

// </smpl>

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>

---
 drivers/media/platform/s5p-tv/sdo_drv.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/platform/s5p-tv/sdo_drv.c b/drivers/media/platform/s5p-tv/sdo_drv.c
index ad68bbe..58cf56d 100644
--- a/drivers/media/platform/s5p-tv/sdo_drv.c
+++ b/drivers/media/platform/s5p-tv/sdo_drv.c
@@ -369,6 +369,7 @@ static int __devinit sdo_probe(struct platform_device *pdev)
 	sdev->fout_vpll = clk_get(dev, "fout_vpll");
 	if (IS_ERR_OR_NULL(sdev->fout_vpll)) {
 		dev_err(dev, "failed to get clock 'fout_vpll'\n");
+		ret = -ENXIO;
 		goto fail_dacphy;
 	}
 	dev_info(dev, "fout_vpll.rate = %lu\n", clk_get_rate(sclk_vpll));
@@ -377,11 +378,13 @@ static int __devinit sdo_probe(struct platform_device *pdev)
 	sdev->vdac = devm_regulator_get(dev, "vdd33a_dac");
 	if (IS_ERR_OR_NULL(sdev->vdac)) {
 		dev_err(dev, "failed to get regulator 'vdac'\n");
+		ret = -ENXIO;
 		goto fail_fout_vpll;
 	}
 	sdev->vdet = devm_regulator_get(dev, "vdet");
 	if (IS_ERR_OR_NULL(sdev->vdet)) {
 		dev_err(dev, "failed to get regulator 'vdet'\n");
+		ret = -ENXIO;
 		goto fail_fout_vpll;
 	}
 

