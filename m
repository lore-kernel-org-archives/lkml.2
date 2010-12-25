Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924Ab0LYKR6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Dec 2010 05:17:58 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:42179 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751774Ab0LYKR5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Dec 2010 05:17:57 -0500
X-Authenticated: #71072403
X-Provags-ID: V01U2FsdGVkX1/62vYmDkX6vvoOX6inNos1skIAZcvrVqK71jczZT
	Vgvj7eTks/4dXl
From: Tobias Ollmann <tobias.ollmann@gmx.at>
To: gregkh@suse.de
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tobias Ollmann <tobias.ollmann@gmx.at>
Subject: [PATCH] USB: Core: Fix minor coding style issues
Date: Sat, 25 Dec 2010 11:17:01 +0100
Message-Id: <1293272221-9921-1-git-send-email-tobias.ollmann@gmx.at>
X-Mailer: git-send-email 1.7.1
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixing all coding style issues in buffer.c

Signed-off-by: Tobias Ollmann <tobias.ollmann@gmx.at>
---
 drivers/usb/core/buffer.c |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/usb/core/buffer.c b/drivers/usb/core/buffer.c
index 2c69654..b0585e6 100644
--- a/drivers/usb/core/buffer.c
+++ b/drivers/usb/core/buffer.c
@@ -10,7 +10,7 @@
 #include <linux/slab.h>
 #include <linux/device.h>
 #include <linux/mm.h>
-#include <asm/io.h>
+#include <linux/io.h>
 #include <linux/dma-mapping.h>
 #include <linux/dmapool.h>
 #include <linux/usb.h>
@@ -22,7 +22,7 @@
  */
 
 /* FIXME tune these based on pool statistics ... */
-static const size_t	pool_max [HCD_BUFFER_POOLS] = {
+static const size_t	pool_max[HCD_BUFFER_POOLS] = {
 	/* platforms without dma-friendly caches might need to
 	 * prevent cacheline sharing...
 	 */
@@ -51,7 +51,7 @@ static const size_t	pool_max [HCD_BUFFER_POOLS] = {
 int hcd_buffer_create(struct usb_hcd *hcd)
 {
 	char		name[16];
-	int 		i, size;
+	int		i, size;
 
 	if (!hcd->self.controller->dma_mask &&
 	    !(hcd->driver->flags & HCD_LOCAL_MEM))
@@ -64,7 +64,7 @@ int hcd_buffer_create(struct usb_hcd *hcd)
 		snprintf(name, sizeof name, "buffer-%d", size);
 		hcd->pool[i] = dma_pool_create(name, hcd->self.controller,
 				size, size, 0);
-		if (!hcd->pool [i]) {
+		if (!hcd->pool[i]) {
 			hcd_buffer_destroy(hcd);
 			return -ENOMEM;
 		}
@@ -99,14 +99,14 @@ void hcd_buffer_destroy(struct usb_hcd *hcd)
  */
 
 void *hcd_buffer_alloc(
-	struct usb_bus 	*bus,
+	struct usb_bus		*bus,
 	size_t			size,
 	gfp_t			mem_flags,
 	dma_addr_t		*dma
 )
 {
 	struct usb_hcd		*hcd = bus_to_hcd(bus);
-	int 			i;
+	int			i;
 
 	/* some USB hosts just use PIO */
 	if (!bus->controller->dma_mask &&
@@ -116,21 +116,21 @@ void *hcd_buffer_alloc(
 	}
 
 	for (i = 0; i < HCD_BUFFER_POOLS; i++) {
-		if (size <= pool_max [i])
-			return dma_pool_alloc(hcd->pool [i], mem_flags, dma);
+		if (size <= pool_max[i])
+			return dma_pool_alloc(hcd->pool[i], mem_flags, dma);
 	}
 	return dma_alloc_coherent(hcd->self.controller, size, dma, mem_flags);
 }
 
 void hcd_buffer_free(
-	struct usb_bus 	*bus,
+	struct usb_bus		*bus,
 	size_t			size,
-	void 			*addr,
+	void			*addr,
 	dma_addr_t		dma
 )
 {
 	struct usb_hcd		*hcd = bus_to_hcd(bus);
-	int 			i;
+	int			i;
 
 	if (!addr)
 		return;
@@ -142,8 +142,8 @@ void hcd_buffer_free(
 	}
 
 	for (i = 0; i < HCD_BUFFER_POOLS; i++) {
-		if (size <= pool_max [i]) {
-			dma_pool_free(hcd->pool [i], addr, dma);
+		if (size <= pool_max[i]) {
+			dma_pool_free(hcd->pool[i], addr, dma);
 			return;
 		}
 	}
-- 
1.7.1

