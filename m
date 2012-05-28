Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640Ab2E1Qmz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 12:42:55 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:47412 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897Ab2E1Qmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 12:42:54 -0400
From: Andi Shyti <andi.shyti@gmail.com>
To: debora@linux.vnet.ibm.com, srajiv@linux.vnet.ibm.com
Cc: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        peterhuewe@gmx.de, oatilla@gmail.com
Subject: [PATCH v2] tpm: check the chip reference before using it
Date: Mon, 28 May 2012 18:42:45 +0200
Message-Id: <ceaabebd8265ee107c7237e4f69d9f0852e69ae9.1338222878.git.andi.shyti@gmail.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a driver calls tpm_dev_vendor_release for a device already released
then the driver will oops.

Signed-off-by: Andi Shyti <andi.shyti@gmail.com>
Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/char/tpm/tpm.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
index ad7c732..f5cabf5 100644
--- a/drivers/char/tpm/tpm.c
+++ b/drivers/char/tpm/tpm.c
@@ -1322,6 +1322,9 @@ EXPORT_SYMBOL_GPL(tpm_pm_resume);
 
 void tpm_dev_vendor_release(struct tpm_chip *chip)
 {
+	if (!chip)
+		return;
+
 	if (chip->vendor.release)
 		chip->vendor.release(chip->dev);
 
@@ -1339,6 +1342,9 @@ void tpm_dev_release(struct device *dev)
 {
 	struct tpm_chip *chip = dev_get_drvdata(dev);
 
+	if (!chip)
+		return;
+
 	tpm_dev_vendor_release(chip);
 
 	chip->release(dev);
-- 
1.7.10

