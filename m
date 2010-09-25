Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496Ab0IYNt5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 09:49:57 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:50772 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754693Ab0IYNt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 09:49:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=n3oZ+gxjHPaK6kw0INdzc0sekTnNAJdr98eAj1XRmrrDmVCG+3a2ZN48LUaKQ5bu8z
         3gaUkHNJ4qyjdAozUd+we8EVQ51xpV0R9vJZ/oFzO4Ze1+lMXeRw93xlL4m6X4u2kfmt
         3ONou6efvUlNaQMRKCMcN49tCowFyeFS0hE30=
From: Rahul Ruikar <rahul.ruikar@gmail.com>
To: jirislaby@gmail.com
Cc: ak@linux.intel.com, adobriyan@gmail.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, Rahul Ruikar <rahul.ruikar@gmail.com>
Subject: [PATCH] misc: phantom: Added missing warning messages in phantom_probe
Date: Sat, 25 Sep 2010 19:18:25 +0530
Message-Id: <1285422505-7128-1-git-send-email-rahul.ruikar@gmail.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

phantom_probe can fail at many places. missing warning messages
have been added for 2 cases.
pci_enable_device()
pci_request_regions()

Signed-off-by: Rahul Ruikar <rahul.ruikar@gmail.com>
---
 drivers/misc/phantom.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/phantom.c b/drivers/misc/phantom.c
index 75ee0d3..b4c105f 100644
--- a/drivers/misc/phantom.c
+++ b/drivers/misc/phantom.c
@@ -341,8 +341,10 @@ static int __devinit phantom_probe(struct pci_dev *pdev,
 	int retval;
 
 	retval = pci_enable_device(pdev);
-	if (retval)
+	if (retval) {
+		dev_err(&pdev->dev, "pci_enable_device failed!\n");
 		goto err;
+	}
 
 	minor = phantom_get_free();
 	if (minor == PHANTOM_MAX_MINORS) {
@@ -354,8 +356,10 @@ static int __devinit phantom_probe(struct pci_dev *pdev,
 	phantom_devices[minor] = 1;
 
 	retval = pci_request_regions(pdev, "phantom");
-	if (retval)
+	if (retval) {
+		dev_err(&pdev->dev, "pci_request_regions failed!\n");
 		goto err_null;
+	}
 
 	retval = -ENOMEM;
 	pht = kzalloc(sizeof(*pht), GFP_KERNEL);
-- 
1.7.2.3

