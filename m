Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760362Ab2ILQ0U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 12:26:20 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:37917 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037Ab2ILQ0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 12:26:19 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: Samuel Ortiz <sameo@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Marc Dietrich <marvin24@gmx.de>
Subject: [PATCH] staging: nvec: adjust for mfd_add_devices() API change
Date: Wed, 12 Sep 2012 10:26:00 -0600
Message-Id: <1347467160-22724-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

Commit 6607bad "mfd: core: Push irqdomain mapping out into devices"
added a new parameter to mfd_add_devices(), but missed updating the
nvec driver in staging.

Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Marc Dietrich <marvin24@gmx.de>
Signed-off-by: Stephen Warren <swarren@nvidia.com>
--
Samuel, I wonder if this patch should be squashed into the commit mentioned
above in the MFD tree?
---
 drivers/staging/nvec/nvec.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/nvec/nvec.c b/drivers/staging/nvec/nvec.c
index b0972d0..24d8eeb 100644
--- a/drivers/staging/nvec/nvec.c
+++ b/drivers/staging/nvec/nvec.c
@@ -837,7 +837,7 @@ static int __devinit tegra_nvec_probe(struct platform_device *pdev)
 	}
 
 	ret = mfd_add_devices(nvec->dev, -1, nvec_devices,
-			      ARRAY_SIZE(nvec_devices), base, 0);
+			      ARRAY_SIZE(nvec_devices), base, 0, NULL);
 	if (ret)
 		dev_err(nvec->dev, "error adding subdevices\n");
 
-- 
1.7.0.4

