Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755676Ab0GCQNK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jul 2010 12:13:10 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:53464 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754682Ab0GCQNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jul 2010 12:13:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=EnMcQ2xWhSVCJcpxFvfXst//Mken0+5dvCljww1uMq0ougYbXbVCJpYIuZ7Chgl4W5
         o3ECCpjdPetaaFK07iaunaw6CPogLroRW2dygwC/IwQrPoeml4mDLwTfGgjGEIgBp7Fg
         SwUuvbwLVrTcGkBfbO6tN+7gwLhSRDWuHeV98=
From: Kulikov Vasiliy <segooon@gmail.com>
To: Kernel Janitors <kernel-janitors@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       =?UTF-8?q?Charles=20Cl=C3=A9ment?= <caratorn@gmail.com>,
       Jim Lieb <lieb@canonical.com>, "David S. Miller" <davem@davemloft.net>,
       Alexander Beregalov <a.beregalov@gmail.com>, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 18/19] drivers/staging/vt6655: use for_each_pci_dev()
Date: Sat,  3 Jul 2010 20:04:43 +0400
Message-Id: <1278173084-12017-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use for_each_pci_dev() to simplify the code.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/staging/vt6655/device_main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 0d697d0..d498442 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -3655,7 +3655,7 @@ device_notify_reboot(struct notifier_block *nb, unsigned long event, void *p)
     case SYS_DOWN:
     case SYS_HALT:
     case SYS_POWER_OFF:
-        while ((pdev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, pdev)) != NULL) {
+	for_each_pci_dev(pdev) {
             if(pci_dev_driver(pdev) == &device_driver) {
                 if (pci_get_drvdata(pdev))
                     viawget_suspend(pdev, PMSG_HIBERNATE);
-- 
1.7.0.4

