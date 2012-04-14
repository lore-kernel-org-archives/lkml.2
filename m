Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456Ab2DNQZm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 12:25:42 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43366 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581Ab2DNQZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 12:25:13 -0400
From: mathieu.poirier@linaro.org
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, mathieu.poirier@linaro.org
Subject: [PATCH 1/2] misc: add missing __devexit_p() annotations
Date: Sat, 14 Apr 2012 10:25:03 -0600
Message-Id: <1334420704-22079-2-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1334420704-22079-1-git-send-email-mathieu.poirier@linaro.org>
References: <1334420704-22079-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

Drivers that refer to a __devexit function in an operations
structure need to annotate that pointer with __devexit_p so it
is replaced with a NULL pointer when the section gets discarded.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 drivers/misc/bh1780gli.c |    2 +-
 drivers/misc/pti.c       |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/bh1780gli.c b/drivers/misc/bh1780gli.c
index 54f6f39..f1f9877 100644
--- a/drivers/misc/bh1780gli.c
+++ b/drivers/misc/bh1780gli.c
@@ -248,7 +248,7 @@ static const struct i2c_device_id bh1780_id[] = {
 
 static struct i2c_driver bh1780_driver = {
 	.probe		= bh1780_probe,
-	.remove		= bh1780_remove,
+	.remove		= __devexit_p(bh1780_remove),
 	.id_table	= bh1780_id,
 	.driver = {
 		.name = "bh1780",
diff --git a/drivers/misc/pti.c b/drivers/misc/pti.c
index 383133b..b7eb545 100644
--- a/drivers/misc/pti.c
+++ b/drivers/misc/pti.c
@@ -888,7 +888,7 @@ static struct pci_driver pti_pci_driver = {
 	.name		= PCINAME,
 	.id_table	= pci_ids,
 	.probe		= pti_pci_probe,
-	.remove		= pti_pci_remove,
+	.remove		= __devexit_p(pti_pci_remove),
 };
 
 /**
-- 
1.7.5.4

