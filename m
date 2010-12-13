Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757828Ab0LMNRh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 08:17:37 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:57415 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757810Ab0LMNRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 08:17:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=e1mltK9cJFxZYSQOdLZJT9Oe9nofPrHyHtp2J7WplBaogayQRDwQpCS2gBjQ4kkpmb
         FIdFO7hDgv1wqrQrDW5humxPNdFlJMDbz1b+VxzyeTtZLeAY1ag8wFKWe+DpGfxxTszB
         nXLuA86/DGAT3Sb5AL5hn+WVsYrKDF8E3R4C0=
From: Namhyung Kim <namhyung@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, Martyn Welch <martyn.welch@ge.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 8/8] Staging: vme_tsi148: make functions static
Date: Mon, 13 Dec 2010 22:16:36 +0900
Message-Id: <1292246196-2332-8-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.3.3.400.g93cef
In-Reply-To: <1292246196-2332-1-git-send-email-namhyung@gmail.com>
References: <1292246196-2332-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Declare internal functions static.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 drivers/staging/vme/bridges/vme_tsi148.c |   49 +++++++++++++++--------------
 1 files changed, 25 insertions(+), 24 deletions(-)

diff --git a/drivers/staging/vme/bridges/vme_tsi148.c b/drivers/staging/vme/bridges/vme_tsi148.c
index a4c7f206cec6..1cb15e5c9923 100644
--- a/drivers/staging/vme/bridges/vme_tsi148.c
+++ b/drivers/staging/vme/bridges/vme_tsi148.c
@@ -391,7 +391,7 @@ static void tsi148_irq_exit(struct tsi148_driver *bridge, struct pci_dev *pdev)
 /*
  * Check to see if an IACk has been received, return true (1) or false (0).
  */
-int tsi148_iack_received(struct tsi148_driver *bridge)
+static int tsi148_iack_received(struct tsi148_driver *bridge)
 {
 	u32 tmp;
 
@@ -406,7 +406,7 @@ int tsi148_iack_received(struct tsi148_driver *bridge)
 /*
  * Configure VME interrupt
  */
-void tsi148_irq_set(struct vme_bridge *tsi148_bridge, int level,
+static void tsi148_irq_set(struct vme_bridge *tsi148_bridge, int level,
 	int state, int sync)
 {
 	struct pci_dev *pdev;
@@ -446,7 +446,8 @@ void tsi148_irq_set(struct vme_bridge *tsi148_bridge, int level,
  * Generate a VME bus interrupt at the requested level & vector. Wait for
  * interrupt to be acked.
  */
-int tsi148_irq_generate(struct vme_bridge *tsi148_bridge, int level, int statid)
+static int tsi148_irq_generate(struct vme_bridge *tsi148_bridge, int level,
+	int statid)
 {
 	u32 tmp;
 	struct tsi148_driver *bridge;
@@ -546,7 +547,7 @@ static void tsi148_clear_errors(struct vme_bridge *tsi148_bridge,
 /*
  * Initialize a slave window with the requested attributes.
  */
-int tsi148_slave_set(struct vme_slave_resource *image, int enabled,
+static int tsi148_slave_set(struct vme_slave_resource *image, int enabled,
 	unsigned long long vme_base, unsigned long long size,
 	dma_addr_t pci_base, vme_address_t aspace, vme_cycle_t cycle)
 {
@@ -696,7 +697,7 @@ int tsi148_slave_set(struct vme_slave_resource *image, int enabled,
 /*
  * Get slave window configuration.
  */
-int tsi148_slave_get(struct vme_slave_resource *image, int *enabled,
+static int tsi148_slave_get(struct vme_slave_resource *image, int *enabled,
 	unsigned long long *vme_base, unsigned long long *size,
 	dma_addr_t *pci_base, vme_address_t *aspace, vme_cycle_t *cycle)
 {
@@ -889,7 +890,7 @@ static void tsi148_free_resource(struct vme_master_resource *image)
 /*
  * Set the attributes of an outbound window.
  */
-int tsi148_master_set(struct vme_master_resource *image, int enabled,
+static int tsi148_master_set(struct vme_master_resource *image, int enabled,
 	unsigned long long vme_base, unsigned long long size,
 	vme_address_t aspace, vme_cycle_t cycle, vme_width_t dwidth)
 {
@@ -1125,7 +1126,7 @@ err_window:
  *
  * XXX Not parsing prefetch information.
  */
-int __tsi148_master_get(struct vme_master_resource *image, int *enabled,
+static int __tsi148_master_get(struct vme_master_resource *image, int *enabled,
 	unsigned long long *vme_base, unsigned long long *size,
 	vme_address_t *aspace, vme_cycle_t *cycle, vme_width_t *dwidth)
 {
@@ -1235,7 +1236,7 @@ int __tsi148_master_get(struct vme_master_resource *image, int *enabled,
 }
 
 
-int tsi148_master_get(struct vme_master_resource *image, int *enabled,
+static int tsi148_master_get(struct vme_master_resource *image, int *enabled,
 	unsigned long long *vme_base, unsigned long long *size,
 	vme_address_t *aspace, vme_cycle_t *cycle, vme_width_t *dwidth)
 {
@@ -1251,8 +1252,8 @@ int tsi148_master_get(struct vme_master_resource *image, int *enabled,
 	return retval;
 }
 
-ssize_t tsi148_master_read(struct vme_master_resource *image, void *buf,
-	size_t count, loff_t offset)
+static ssize_t tsi148_master_read(struct vme_master_resource *image,
+	void *buf, size_t count, loff_t offset)
 {
 	int retval, enabled;
 	unsigned long long vme_base, size;
@@ -1293,8 +1294,8 @@ skip_chk:
 }
 
 
-ssize_t tsi148_master_write(struct vme_master_resource *image, void *buf,
-	size_t count, loff_t offset)
+static ssize_t tsi148_master_write(struct vme_master_resource *image,
+	void *buf, size_t count, loff_t offset)
 {
 	int retval = 0, enabled;
 	unsigned long long vme_base, size;
@@ -1360,7 +1361,7 @@ skip_chk:
  *
  * Requires a previously configured master window, returns final value.
  */
-unsigned int tsi148_master_rmw(struct vme_master_resource *image,
+static unsigned int tsi148_master_rmw(struct vme_master_resource *image,
 	unsigned int mask, unsigned int compare, unsigned int swap,
 	loff_t offset)
 {
@@ -1607,8 +1608,8 @@ static int tsi148_dma_set_vme_dest_attributes(struct device *dev, u32 *attr,
 /*
  * Add a link list descriptor to the list
  */
-int tsi148_dma_list_add(struct vme_dma_list *list, struct vme_dma_attr *src,
-	struct vme_dma_attr *dest, size_t count)
+static int tsi148_dma_list_add(struct vme_dma_list *list,
+	struct vme_dma_attr *src, struct vme_dma_attr *dest, size_t count)
 {
 	struct tsi148_dma_entry *entry, *prev;
 	u32 address_high, address_low;
@@ -1780,7 +1781,7 @@ static int tsi148_dma_busy(struct vme_bridge *tsi148_bridge, int channel)
  *
  * XXX Need to provide control register configuration.
  */
-int tsi148_dma_list_exec(struct vme_dma_list *list)
+static int tsi148_dma_list_exec(struct vme_dma_list *list)
 {
 	struct vme_dma_resource *ctrlr;
 	int channel, retval = 0;
@@ -1860,7 +1861,7 @@ int tsi148_dma_list_exec(struct vme_dma_list *list)
  *
  * We have a separate function, don't assume that the chain can't be reused.
  */
-int tsi148_dma_list_empty(struct vme_dma_list *list)
+static int tsi148_dma_list_empty(struct vme_dma_list *list)
 {
 	struct list_head *pos, *temp;
 	struct tsi148_dma_entry *entry;
@@ -1882,8 +1883,8 @@ int tsi148_dma_list_empty(struct vme_dma_list *list)
  * This does not enable the LM monitor - that should be done when the first
  * callback is attached and disabled when the last callback is removed.
  */
-int tsi148_lm_set(struct vme_lm_resource *lm, unsigned long long lm_base,
-	vme_address_t aspace, vme_cycle_t cycle)
+static int tsi148_lm_set(struct vme_lm_resource *lm,
+	unsigned long long lm_base, vme_address_t aspace, vme_cycle_t cycle)
 {
 	u32 lm_base_high, lm_base_low, lm_ctl = 0;
 	int i;
@@ -1949,8 +1950,8 @@ int tsi148_lm_set(struct vme_lm_resource *lm, unsigned long long lm_base,
 /* Get configuration of the callback monitor and return whether it is enabled
  * or disabled.
  */
-int tsi148_lm_get(struct vme_lm_resource *lm, unsigned long long *lm_base,
-	vme_address_t *aspace, vme_cycle_t *cycle)
+static int tsi148_lm_get(struct vme_lm_resource *lm,
+	unsigned long long *lm_base, vme_address_t *aspace, vme_cycle_t *cycle)
 {
 	u32 lm_base_high, lm_base_low, lm_ctl, enabled = 0;
 	struct tsi148_driver *bridge;
@@ -2000,7 +2001,7 @@ int tsi148_lm_get(struct vme_lm_resource *lm, unsigned long long *lm_base,
  *
  * Callback will be passed the monitor triggered.
  */
-int tsi148_lm_attach(struct vme_lm_resource *lm, int monitor,
+static int tsi148_lm_attach(struct vme_lm_resource *lm, int monitor,
 	void (*callback)(int))
 {
 	u32 lm_ctl, tmp;
@@ -2055,7 +2056,7 @@ int tsi148_lm_attach(struct vme_lm_resource *lm, int monitor,
 /*
  * Detach a callback function forn a specific location monitor.
  */
-int tsi148_lm_detach(struct vme_lm_resource *lm, int monitor)
+static int tsi148_lm_detach(struct vme_lm_resource *lm, int monitor)
 {
 	u32 lm_en, tmp;
 	struct tsi148_driver *bridge;
@@ -2095,7 +2096,7 @@ int tsi148_lm_detach(struct vme_lm_resource *lm, int monitor)
 /*
  * Determine Geographical Addressing
  */
-int tsi148_slot_get(struct vme_bridge *tsi148_bridge)
+static int tsi148_slot_get(struct vme_bridge *tsi148_bridge)
 {
 	u32 slot = 0;
 	struct tsi148_driver *bridge;
-- 
1.7.3.3.400.g93cef

