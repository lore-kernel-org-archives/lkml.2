Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757779Ab0LMNR0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 08:17:26 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:51395 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757757Ab0LMNRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 08:17:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=BHo3oln2nV43aSUzypcTe6tWVTRJy/XI76uqe5anXmfGiMyJs9B/On8/p3nGMtsJSC
         O+v783dXWSb5KdhTag4SD28yxLrAaZ6W8DKK6+f9108+CSuZzlf5D+9rZD0NkBj/XmwZ
         odUeoPEQ9lqlH8qCSxhIyOLsW6xn1yDd/H2pU=
From: Namhyung Kim <namhyung@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, Martyn Welch <martyn.welch@ge.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/8] Staging: vme_ca91cx42: make functions static
Date: Mon, 13 Dec 2010 22:16:33 +0900
Message-Id: <1292246196-2332-5-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.3.3.400.g93cef
In-Reply-To: <1292246196-2332-1-git-send-email-namhyung@gmail.com>
References: <1292246196-2332-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Declare internal functions static.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 drivers/staging/vme/bridges/vme_ca91cx42.c |   54 ++++++++++++++--------------
 1 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/drivers/staging/vme/bridges/vme_ca91cx42.c b/drivers/staging/vme/bridges/vme_ca91cx42.c
index 1052a6d101cd..cfac1f128dea 100644
--- a/drivers/staging/vme/bridges/vme_ca91cx42.c
+++ b/drivers/staging/vme/bridges/vme_ca91cx42.c
@@ -260,8 +260,8 @@ static void ca91cx42_irq_exit(struct ca91cx42_driver *bridge,
 /*
  * Set up an VME interrupt
  */
-void ca91cx42_irq_set(struct vme_bridge *ca91cx42_bridge, int level, int state,
-	int sync)
+static void ca91cx42_irq_set(struct vme_bridge *ca91cx42_bridge, int level,
+	int state, int sync)
 
 {
 	struct pci_dev *pdev;
@@ -288,8 +288,8 @@ void ca91cx42_irq_set(struct vme_bridge *ca91cx42_bridge, int level, int state,
 	}
 }
 
-int ca91cx42_irq_generate(struct vme_bridge *ca91cx42_bridge, int level,
-	int statid)
+static int ca91cx42_irq_generate(struct vme_bridge *ca91cx42_bridge,
+	int level, int statid)
 {
 	u32 tmp;
 	struct ca91cx42_driver *bridge;
@@ -324,7 +324,7 @@ int ca91cx42_irq_generate(struct vme_bridge *ca91cx42_bridge, int level,
 	return 0;
 }
 
-int ca91cx42_slave_set(struct vme_slave_resource *image, int enabled,
+static int ca91cx42_slave_set(struct vme_slave_resource *image, int enabled,
 	unsigned long long vme_base, unsigned long long size,
 	dma_addr_t pci_base, vme_address_t aspace, vme_cycle_t cycle)
 {
@@ -430,7 +430,7 @@ int ca91cx42_slave_set(struct vme_slave_resource *image, int enabled,
 	return 0;
 }
 
-int ca91cx42_slave_get(struct vme_slave_resource *image, int *enabled,
+static int ca91cx42_slave_get(struct vme_slave_resource *image, int *enabled,
 	unsigned long long *vme_base, unsigned long long *size,
 	dma_addr_t *pci_base, vme_address_t *aspace, vme_cycle_t *cycle)
 {
@@ -582,7 +582,7 @@ static void ca91cx42_free_resource(struct vme_master_resource *image)
 }
 
 
-int ca91cx42_master_set(struct vme_master_resource *image, int enabled,
+static int ca91cx42_master_set(struct vme_master_resource *image, int enabled,
 	unsigned long long vme_base, unsigned long long size,
 	vme_address_t aspace, vme_cycle_t cycle, vme_width_t dwidth)
 {
@@ -739,8 +739,8 @@ err_window:
 	return retval;
 }
 
-int __ca91cx42_master_get(struct vme_master_resource *image, int *enabled,
-	unsigned long long *vme_base, unsigned long long *size,
+static int __ca91cx42_master_get(struct vme_master_resource *image,
+	int *enabled, unsigned long long *vme_base, unsigned long long *size,
 	vme_address_t *aspace, vme_cycle_t *cycle, vme_width_t *dwidth)
 {
 	unsigned int i, ctl;
@@ -826,7 +826,7 @@ int __ca91cx42_master_get(struct vme_master_resource *image, int *enabled,
 	return 0;
 }
 
-int ca91cx42_master_get(struct vme_master_resource *image, int *enabled,
+static int ca91cx42_master_get(struct vme_master_resource *image, int *enabled,
 	unsigned long long *vme_base, unsigned long long *size,
 	vme_address_t *aspace, vme_cycle_t *cycle, vme_width_t *dwidth)
 {
@@ -844,8 +844,8 @@ int ca91cx42_master_get(struct vme_master_resource *image, int *enabled,
 
 #define check_aligned(addr, align)	((unsigned long)addr & align)
 
-ssize_t ca91cx42_master_read(struct vme_master_resource *image, void *buf,
-	size_t count, loff_t offset)
+static ssize_t ca91cx42_master_read(struct vme_master_resource *image,
+	void *buf, size_t count, loff_t offset)
 {
 	ssize_t retval;
 	void __iomem *addr = image->kern_base + offset;
@@ -904,8 +904,8 @@ out:
 	return retval;
 }
 
-ssize_t ca91cx42_master_write(struct vme_master_resource *image, void *buf,
-	size_t count, loff_t offset)
+static ssize_t ca91cx42_master_write(struct vme_master_resource *image,
+	void *buf, size_t count, loff_t offset)
 {
 	ssize_t retval;
 	void __iomem *addr = image->kern_base + offset;
@@ -958,7 +958,7 @@ out:
 	return retval;
 }
 
-unsigned int ca91cx42_master_rmw(struct vme_master_resource *image,
+static unsigned int ca91cx42_master_rmw(struct vme_master_resource *image,
 	unsigned int mask, unsigned int compare, unsigned int swap,
 	loff_t offset)
 {
@@ -1014,8 +1014,8 @@ out:
 	return result;
 }
 
-int ca91cx42_dma_list_add(struct vme_dma_list *list, struct vme_dma_attr *src,
-	struct vme_dma_attr *dest, size_t count)
+static int ca91cx42_dma_list_add(struct vme_dma_list *list,
+	struct vme_dma_attr *src, struct vme_dma_attr *dest, size_t count)
 {
 	struct ca91cx42_dma_entry *entry, *prev;
 	struct vme_dma_pci *pci_attr;
@@ -1175,7 +1175,7 @@ static int ca91cx42_dma_busy(struct vme_bridge *ca91cx42_bridge)
 		return 1;
 }
 
-int ca91cx42_dma_list_exec(struct vme_dma_list *list)
+static int ca91cx42_dma_list_exec(struct vme_dma_list *list)
 {
 	struct vme_dma_resource *ctrlr;
 	struct ca91cx42_dma_entry *entry;
@@ -1257,7 +1257,7 @@ int ca91cx42_dma_list_exec(struct vme_dma_list *list)
 
 }
 
-int ca91cx42_dma_list_empty(struct vme_dma_list *list)
+static int ca91cx42_dma_list_empty(struct vme_dma_list *list)
 {
 	struct list_head *pos, *temp;
 	struct ca91cx42_dma_entry *entry;
@@ -1279,8 +1279,8 @@ int ca91cx42_dma_list_empty(struct vme_dma_list *list)
  * This does not enable the LM monitor - that should be done when the first
  * callback is attached and disabled when the last callback is removed.
  */
-int ca91cx42_lm_set(struct vme_lm_resource *lm, unsigned long long lm_base,
-	vme_address_t aspace, vme_cycle_t cycle)
+static int ca91cx42_lm_set(struct vme_lm_resource *lm,
+	unsigned long long lm_base, vme_address_t aspace, vme_cycle_t cycle)
 {
 	u32 temp_base, lm_ctl = 0;
 	int i;
@@ -1347,8 +1347,8 @@ int ca91cx42_lm_set(struct vme_lm_resource *lm, unsigned long long lm_base,
 /* Get configuration of the callback monitor and return whether it is enabled
  * or disabled.
  */
-int ca91cx42_lm_get(struct vme_lm_resource *lm, unsigned long long *lm_base,
-	vme_address_t *aspace, vme_cycle_t *cycle)
+static int ca91cx42_lm_get(struct vme_lm_resource *lm,
+	unsigned long long *lm_base, vme_address_t *aspace, vme_cycle_t *cycle)
 {
 	u32 lm_ctl, enabled = 0;
 	struct ca91cx42_driver *bridge;
@@ -1390,7 +1390,7 @@ int ca91cx42_lm_get(struct vme_lm_resource *lm, unsigned long long *lm_base,
  *
  * Callback will be passed the monitor triggered.
  */
-int ca91cx42_lm_attach(struct vme_lm_resource *lm, int monitor,
+static int ca91cx42_lm_attach(struct vme_lm_resource *lm, int monitor,
 	void (*callback)(int))
 {
 	u32 lm_ctl, tmp;
@@ -1439,7 +1439,7 @@ int ca91cx42_lm_attach(struct vme_lm_resource *lm, int monitor,
 /*
  * Detach a callback function forn a specific location monitor.
  */
-int ca91cx42_lm_detach(struct vme_lm_resource *lm, int monitor)
+static int ca91cx42_lm_detach(struct vme_lm_resource *lm, int monitor)
 {
 	u32 tmp;
 	struct ca91cx42_driver *bridge;
@@ -1472,7 +1472,7 @@ int ca91cx42_lm_detach(struct vme_lm_resource *lm, int monitor)
 	return 0;
 }
 
-int ca91cx42_slot_get(struct vme_bridge *ca91cx42_bridge)
+static int ca91cx42_slot_get(struct vme_bridge *ca91cx42_bridge)
 {
 	u32 slot = 0;
 	struct ca91cx42_driver *bridge;
@@ -1832,7 +1832,7 @@ err_struct:
 
 }
 
-void __devexit ca91cx42_remove(struct pci_dev *pdev)
+static void __devexit ca91cx42_remove(struct pci_dev *pdev)
 {
 	struct list_head *pos = NULL;
 	struct vme_master_resource *master_image;
-- 
1.7.3.3.400.g93cef

