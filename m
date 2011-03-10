Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751989Ab1CJIsk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 03:48:40 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:40696 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678Ab1CJIsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 03:48:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=YrLVe6HuSAQ7w3YJyM48HT+avptJHdKO0YsmCvg7Yl70KhqNrJs+UFWXkcfWT1lvtU
         QrU4kjc9mLyUY3Tdf1HnSXre5ovaYLVsHOpm8paUXeefspMKBJppk/8norekAFAJBnhX
         cQXxDuQIfEbfSvPizESu2nytfsYB1kgDBKwnQ=
Subject: [PATCH] gpio: add MODULE_DEVICE_TABLE
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 10 Mar 2011 16:48:34 +0800
Message-Id: <1299746914.18619.3.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The device table is required to load modules based on modaliases.
After adding MODULE_DEVICE_TABLE, below entries will be added to modules.pcimap:

pch_gpio             0x00008086 0x00008803 0xffffffff 0xffffffff 0x00000000 0x00000000 0x0
ml_ioh_gpio          0x000010db 0x0000802e 0xffffffff 0xffffffff 0x00000000 0x00000000 0x0

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
---
 drivers/gpio/ml_ioh_gpio.c |    1 +
 drivers/gpio/pch_gpio.c    |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/gpio/ml_ioh_gpio.c b/drivers/gpio/ml_ioh_gpio.c
index cead8e6..7f6f01a 100644
--- a/drivers/gpio/ml_ioh_gpio.c
+++ b/drivers/gpio/ml_ioh_gpio.c
@@ -326,6 +326,7 @@ static DEFINE_PCI_DEVICE_TABLE(ioh_gpio_pcidev_id) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_ROHM, 0x802E) },
 	{ 0, }
 };
+MODULE_DEVICE_TABLE(pci, ioh_gpio_pcidev_id);
 
 static struct pci_driver ioh_gpio_driver = {
 	.name = "ml_ioh_gpio",
diff --git a/drivers/gpio/pch_gpio.c b/drivers/gpio/pch_gpio.c
index 0eba0a7..2c6af87 100644
--- a/drivers/gpio/pch_gpio.c
+++ b/drivers/gpio/pch_gpio.c
@@ -286,6 +286,7 @@ static DEFINE_PCI_DEVICE_TABLE(pch_gpio_pcidev_id) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x8803) },
 	{ 0, }
 };
+MODULE_DEVICE_TABLE(pci, pch_gpio_pcidev_id);
 
 static struct pci_driver pch_gpio_driver = {
 	.name = "pch_gpio",
-- 
1.7.2



