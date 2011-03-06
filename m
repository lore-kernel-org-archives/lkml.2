Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831Ab1CFL0O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 06:26:14 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58339 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752196Ab1CFL0M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 06:26:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=XQmRYY07TawcTZIghIxpR4DW51YvRwcGa8gOHVA9Z1NmvZrgivcPtRWKF4Dof2fBXF
         tnkL3UWoiQGUQTspWdCyoHhaagakOcLJDiMc8/zBTdN8PzIQjHJbt5/KDeEi0iFrcIK4
         Q26ys1tqG3xogwRGYpHRgpD57XIc+FRWbks4c=
MIME-Version: 1.0
Date: Sun, 6 Mar 2011 17:26:10 +0600
Message-ID: <AANLkTimPwqTnjNNZx6zVef6n=X00+G5dZSzp2aOSRp1b@mail.gmail.com>
Subject: [PATCH] drivers, pch_dma: Fix warning when CONFIG_PM=n.
From: Rakib Mullick <rakib.mullick@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When CONFIG_PM=n, we get the following warning:

drivers/dma/pch_dma.c:741: warning: ‘pch_dma_suspend’ defined but not used
drivers/dma/pch_dma.c:755: warning: ‘pch_dma_resume’ defined but not used

To fix it, wrap pch_dma_{suspend,resume} and
pch_dma_{save,restore}_regs functions with CONFIG_PM.

Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
---

diff --git a/drivers/dma/pch_dma.c b/drivers/dma/pch_dma.c
index 1c38418..33073cc 100644
--- a/drivers/dma/pch_dma.c
+++ b/drivers/dma/pch_dma.c
@@ -694,6 +694,7 @@ static irqreturn_t pd_irq(int irq, void *devid)
 	return ret;
 }

+#ifdef	CONFIG_PM
 static void pch_dma_save_regs(struct pch_dma *pd)
 {
 	struct pch_dma_chan *pd_chan;
@@ -771,6 +772,7 @@ static int pch_dma_resume(struct pci_dev *pdev)

 	return 0;
 }
+#endif

 static int __devinit pch_dma_probe(struct pci_dev *pdev,
 				   const struct pci_device_id *id)
