Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758003Ab2IKW6n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 18:58:43 -0400
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:51244 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755563Ab2IKW6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 18:58:19 -0400
From: "Ira W. Snyder" <iws@ovro.caltech.edu>
To: linux-kernel@vger.kernel.org
Cc: linux-can@vger.kernel.org, sameo@linux.intel.com,
        "Ira W. Snyder" <iws@ovro.caltech.edu>
Subject: [PATCH 1/2] mfd/janz-cmodio: fix MODULBus number sysfs entry
Date: Tue, 11 Sep 2012 15:58:14 -0700
Message-Id: <1347404295-7985-2-git-send-email-iws@ovro.caltech.edu>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1347404295-7985-1-git-send-email-iws@ovro.caltech.edu>
References: <1347404295-7985-1-git-send-email-iws@ovro.caltech.edu>
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (ovro.ovro.caltech.edu); Tue, 11 Sep 2012 15:58:16 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ira W. Snyder" <iws@ovro.caltech.edu>

Revision 1.0 of the Janz CMOD-IO Carrier Board does not contain zeroes
in the top 4 bits of the modulbus_num (int_enable) register. Mask off
the unused bits so that the correct value is displayed in sysfs.

Cc: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Ira W. Snyder <iws@ovro.caltech.edu>
---
 drivers/mfd/janz-cmodio.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/janz-cmodio.c b/drivers/mfd/janz-cmodio.c
index 2ea9998..32d0efd 100644
--- a/drivers/mfd/janz-cmodio.c
+++ b/drivers/mfd/janz-cmodio.c
@@ -216,7 +216,7 @@ static int __devinit cmodio_pci_probe(struct pci_dev *dev,
 	}
 
 	/* Read the hex switch on the carrier board */
-	priv->hex = ioread8(&priv->ctrl->int_enable);
+	priv->hex = ioread8(&priv->ctrl->int_enable) & 0x0f;
 
 	/* Add the MODULbus number (hex switch value) to the device's sysfs */
 	ret = sysfs_create_group(&dev->dev.kobj, &cmodio_sysfs_attr_group);
-- 
1.7.8.6

