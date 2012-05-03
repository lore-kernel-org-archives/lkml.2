Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159Ab2ECAIv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 20:08:51 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:3805 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752768Ab2ECAIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 20:08:50 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-9.tower-132.messagelabs.com!1336003728!10388374!2
X-Originating-IP: [216.166.12.31]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten lin <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] vme: vme_tsi148.c: local functions should not be exposed globally
Date: Wed, 2 May 2012 17:08:38 -0700
User-Agent: KMail/1.9.9
CC: <gregkh@linuxfoundation.org>, <martyn.welch@ge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201205021708.38406.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Functions not referenced outside of a source file should be marked
static to prevent them from being exposed globally.

Quiets the sparse warnings:

warning: symbol 'tsi148_alloc_consistent' was not declared. Should it be static?
warning: symbol 'tsi148_free_consistent' was not declared. Should it be static?

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Martyn Welch <martyn.welch@ge.com>

---

diff --git a/drivers/vme/bridges/vme_tsi148.c b/drivers/vme/bridges/vme_tsi148.c
index 081e9c4..f6385f7 100644
--- a/drivers/vme/bridges/vme_tsi148.c
+++ b/drivers/vme/bridges/vme_tsi148.c
@@ -2141,7 +2141,7 @@ static int tsi148_slot_get(struct vme_bridge *tsi148_bridge)
 	return (int)slot;
 }
 
-void *tsi148_alloc_consistent(struct device *parent, size_t size,
+static void *tsi148_alloc_consistent(struct device *parent, size_t size,
 	dma_addr_t *dma)
 {
 	struct pci_dev *pdev;
@@ -2152,8 +2152,8 @@ void *tsi148_alloc_consistent(struct device *parent, size_t size,
 	return pci_alloc_consistent(pdev, size, dma);
 }
 
-void tsi148_free_consistent(struct device *parent, size_t size, void *vaddr,
-	dma_addr_t dma)
+static void tsi148_free_consistent(struct device *parent, size_t size,
+	void *vaddr, dma_addr_t dma)
 {
 	struct pci_dev *pdev;
 
