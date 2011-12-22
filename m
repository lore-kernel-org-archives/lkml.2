Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755004Ab1LVSrR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 13:47:17 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:41183 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753614Ab1LVSrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 13:47:16 -0500
Subject: [PATCH] staging, gma500: Fix warning in power.c
From: Rakib Mullick <rakib.mullick@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Alan Cox <alan@linux.intel.com>,
        akpm@linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 23 Dec 2011 00:46:45 +0600
Message-ID: <1324579605.19018.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 gma_resume_display() wants 'struct pci_dev *' as it's parameter, so lets pass dev->pdev instead of dev. Fixes the following warning.

drivers/staging/gma500/power.c: In function ‘gma_power_begin’:
drivers/staging/gma500/power.c:269:3: warning: passing argument 1 of ‘gma_resume_display’ from incompatible pointer type
drivers/staging/gma500/power.c:99:13: note: expected ‘struct pci_dev *’ but argument is of type ‘struct drm_device *’ 

Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
---

diff --git a/drivers/staging/gma500/power.c b/drivers/staging/gma500/power.c
index 436fe97..4082570 100644
--- a/drivers/staging/gma500/power.c
+++ b/drivers/staging/gma500/power.c
@@ -266,7 +266,7 @@ bool gma_power_begin(struct drm_device *dev, bool force_on)
 	ret = gma_resume_pci(dev->pdev);
 	if (ret == 0) {
 		/* FIXME: we want to defer this for Medfield/Oaktrail */
-		gma_resume_display(dev);
+		gma_resume_display(dev->pdev);
 		psb_irq_preinstall(dev);
 		psb_irq_postinstall(dev);
 		pm_runtime_get(&dev->pdev->dev);


