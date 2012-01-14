Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062Ab2ANLet (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jan 2012 06:34:49 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57878 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613Ab2ANLes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jan 2012 06:34:48 -0500
Message-ID: <1326540874.12848.1.camel@phoenix>
Subject: [PATCH] watchdog: via_wdt: Staticise wdt_pci_table
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Marc Vertes <marc.vertes@sigfox.com>, Wim Van Sebroeck <wim@iguana.be>,
        linux-watchdog@vger.kernel.org
Date: Sat, 14 Jan 2012 19:34:34 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is only used in this driver, so no need to make the symbol global.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/watchdog/via_wdt.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/watchdog/via_wdt.c b/drivers/watchdog/via_wdt.c
index 026b4bb..8b24b00 100644
--- a/drivers/watchdog/via_wdt.c
+++ b/drivers/watchdog/via_wdt.c
@@ -233,7 +233,7 @@ static void __devexit wdt_remove(struct pci_dev *pdev)
 	pci_disable_device(pdev);
 }
 
-DEFINE_PCI_DEVICE_TABLE(wdt_pci_table) = {
+static DEFINE_PCI_DEVICE_TABLE(wdt_pci_table) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_CX700) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_VX800) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_VX855) },
-- 
1.7.5.4



