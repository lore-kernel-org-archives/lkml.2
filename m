Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754294Ab2ECAMd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 20:12:33 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:41483 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752356Ab2ECAMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 20:12:31 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-13.tower-127.messagelabs.com!1336003950!4570695!1
X-Originating-IP: [216.166.12.32]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] vme: vme_ca91cx42.c: local functions should not be exposed globally
Date: Wed, 2 May 2012 17:12:22 -0700
User-Agent: KMail/1.9.9
CC: <gregkh@linuxfoundation.org>, <martyn.welch@ge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201205021712.22325.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Functions not referenced outside of a source file should be marked
static to prevent them from being exposed globally.

Quiets the sparse warnings:

warning: symbol 'ca91cx42_alloc_consistent' was not declared. Should it be static?
warning: symbol 'ca91cx42_free_consistent' was not declared. Should it be static?

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Martyn Welch <martyn.welch@ge.com>

---

diff --git a/drivers/vme/bridges/vme_ca91cx42.c b/drivers/vme/bridges/vme_ca91cx42.c
index a3c0f84..e0df92e 100644
--- a/drivers/vme/bridges/vme_ca91cx42.c
+++ b/drivers/vme/bridges/vme_ca91cx42.c
@@ -1501,7 +1501,7 @@ static int ca91cx42_slot_get(struct vme_bridge *ca91cx42_bridge)
 
 }
 
-void *ca91cx42_alloc_consistent(struct device *parent, size_t size,
+static void *ca91cx42_alloc_consistent(struct device *parent, size_t size,
 	dma_addr_t *dma)
 {
 	struct pci_dev *pdev;
@@ -1512,8 +1512,8 @@ void *ca91cx42_alloc_consistent(struct device *parent, size_t size,
 	return pci_alloc_consistent(pdev, size, dma);
 }
 
-void ca91cx42_free_consistent(struct device *parent, size_t size, void *vaddr,
-	dma_addr_t dma)
+static void ca91cx42_free_consistent(struct device *parent, size_t size,
+	void *vaddr, dma_addr_t dma)
 {
 	struct pci_dev *pdev;
 
