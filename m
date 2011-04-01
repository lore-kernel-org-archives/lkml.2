Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756899Ab1DASEI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 14:04:08 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37972 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756391Ab1DASEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 14:04:04 -0400
From: Alan Cox <alan@linux.jf.intel.com>
Subject: [PATCH 3/9] gma500: Fix some set up bugs found by comparing driver
 versions
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Fri, 01 Apr 2011 18:41:22 +0100
Message-ID: <20110401174117.18112.92191.stgit@localhost.localdomain>
In-Reply-To: <20110401173554.18112.67483.stgit@localhost.localdomain>
References: <20110401173554.18112.67483.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/psb_drv.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/gma500/psb_drv.c b/drivers/staging/gma500/psb_drv.c
index 5f72e5a..0262977 100644
--- a/drivers/staging/gma500/psb_drv.c
+++ b/drivers/staging/gma500/psb_drv.c
@@ -670,6 +670,9 @@ static int psb_driver_load(struct drm_device *dev, unsigned long chipset)
 	if (ret)
 		return ret;
 
+	PSB_WSGX32(0x20000000, PSB_CR_PDS_EXEC_BASE);
+	PSB_WSGX32(0x30000000, PSB_CR_BIF_3D_REQ_BASE);
+
 /*	igd_opregion_init(&dev_priv->opregion_dev); */
 	acpi_video_register();
 	if (dev_priv->lid_state)

