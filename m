Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737Ab2E1QXY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 12:23:24 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:42093 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914Ab2E1QXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 12:23:23 -0400
From: Andi Shyti <andi.shyti@gmail.com>
To: debora@linux.vnet.ibm.com, srajiv@linux.vnet.ibm.com,
        m.selhorst@sirrix.com
Cc: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        peterhuewe@gmx.de, andi.shyti@gmail.com, oatilla@gmail.com
Subject: [PATCH] tpm: check the chip reference before using it
Date: Mon, 28 May 2012 18:23:12 +0200
Message-Id: <172ab3cfdd755d047e6366cc56b942820e02ffee.1338221569.git.andi.shyti@gmail.com>
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
index ad7c732..66e4c12 100644
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
 
@@ -1337,6 +1340,9 @@ EXPORT_SYMBOL_GPL(tpm_dev_vendor_release);
  */
 void tpm_dev_release(struct device *dev)
 {
+	if (!chip)
+		return;
+
 	struct tpm_chip *chip = dev_get_drvdata(dev);
 
 	tpm_dev_vendor_release(chip);
-- 
1.7.10

