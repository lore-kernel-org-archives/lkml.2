Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751843Ab2DCBZx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 21:25:53 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50529 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121Ab2DCBZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 21:25:52 -0400
Message-ID: <1333416346.18133.4.camel@phoenix>
Subject: [PATCH] hwmon: use module_pci_driver
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>,
        Clemens Ladisch <clemens@ladisch.de>,
        Rudolf Marek <r.marek@assembler.cz>, Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>, lm-sensors@lm-sensors.org
Date: Tue, 03 Apr 2012 09:25:46 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts the drivers in drivers/hwmon/* to use module_pci_driver()
macro which makes the code smaller and a bit simpler.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Clemens Ladisch <clemens@ladisch.de>
Cc: Rudolf Marek <r.marek@assembler.cz>
---
 drivers/hwmon/fam15h_power.c |   13 +------------
 drivers/hwmon/k10temp.c      |   13 +------------
 drivers/hwmon/k8temp.c       |   13 +------------
 3 files changed, 3 insertions(+), 36 deletions(-)

diff --git a/drivers/hwmon/fam15h_power.c b/drivers/hwmon/fam15h_power.c
index b7494af..2f44988 100644
--- a/drivers/hwmon/fam15h_power.c
+++ b/drivers/hwmon/fam15h_power.c
@@ -215,15 +215,4 @@ static struct pci_driver fam15h_power_driver = {
 	.remove = __devexit_p(fam15h_power_remove),
 };
 
-static int __init fam15h_power_init(void)
-{
-	return pci_register_driver(&fam15h_power_driver);
-}
-
-static void __exit fam15h_power_exit(void)
-{
-	pci_unregister_driver(&fam15h_power_driver);
-}
-
-module_init(fam15h_power_init)
-module_exit(fam15h_power_exit)
+module_pci_driver(fam15h_power_driver);
diff --git a/drivers/hwmon/k10temp.c b/drivers/hwmon/k10temp.c
index 307bb32..7356b5e 100644
--- a/drivers/hwmon/k10temp.c
+++ b/drivers/hwmon/k10temp.c
@@ -225,15 +225,4 @@ static struct pci_driver k10temp_driver = {
 	.remove = __devexit_p(k10temp_remove),
 };
 
-static int __init k10temp_init(void)
-{
-	return pci_register_driver(&k10temp_driver);
-}
-
-static void __exit k10temp_exit(void)
-{
-	pci_unregister_driver(&k10temp_driver);
-}
-
-module_init(k10temp_init)
-module_exit(k10temp_exit)
+module_pci_driver(k10temp_driver);
diff --git a/drivers/hwmon/k8temp.c b/drivers/hwmon/k8temp.c
index 5751019..35aac82 100644
--- a/drivers/hwmon/k8temp.c
+++ b/drivers/hwmon/k8temp.c
@@ -339,19 +339,8 @@ static struct pci_driver k8temp_driver = {
 	.remove = __devexit_p(k8temp_remove),
 };
 
-static int __init k8temp_init(void)
-{
-	return pci_register_driver(&k8temp_driver);
-}
-
-static void __exit k8temp_exit(void)
-{
-	pci_unregister_driver(&k8temp_driver);
-}
+module_pci_driver(k8temp_driver);
 
 MODULE_AUTHOR("Rudolf Marek <r.marek@assembler.cz>");
 MODULE_DESCRIPTION("AMD K8 core temperature monitor");
 MODULE_LICENSE("GPL");
-
-module_init(k8temp_init)
-module_exit(k8temp_exit)
-- 
1.7.5.4



