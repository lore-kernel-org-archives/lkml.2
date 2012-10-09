Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756856Ab2JISk6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 14:40:58 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:59379 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754273Ab2JISky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 14:40:54 -0400
From: "Vincent Penquerc'h" <vincent.penquerch@collabora.co.uk>
To: gregkh@linuxfoundation.org, dri-devel@lists.freedesktop.org
Cc: rob@ti.com, linux-kernel@vger.kernel.org,
        "Vincent Penquerc'h" <vincent.penquerch@collabora.co.uk>
Subject: [PATCH] drm/omap: fix allocation size for page addresses array
Date: Tue,  9 Oct 2012 19:40:39 +0100
Message-Id: <1349808039-16124-1-git-send-email-vincent.penquerch@collabora.co.uk>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Rob Clark <rob@ti.com>
Signed-off-by: Vincent Penquerc'h <vincent.penquerch@collabora.co.uk>
---
 drivers/staging/omapdrm/omap_gem.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/omapdrm/omap_gem.c b/drivers/staging/omapdrm/omap_gem.c
index c828743..4c1472c 100644
--- a/drivers/staging/omapdrm/omap_gem.c
+++ b/drivers/staging/omapdrm/omap_gem.c
@@ -246,7 +246,7 @@ static int omap_gem_attach_pages(struct drm_gem_object *obj)
 	 * DSS, GPU, etc. are not cache coherent:
 	 */
 	if (omap_obj->flags & (OMAP_BO_WC|OMAP_BO_UNCACHED)) {
-		addrs = kmalloc(npages * sizeof(addrs), GFP_KERNEL);
+		addrs = kmalloc(npages * sizeof(*addrs), GFP_KERNEL);
 		if (!addrs) {
 			ret = -ENOMEM;
 			goto free_pages;
@@ -257,7 +257,7 @@ static int omap_gem_attach_pages(struct drm_gem_object *obj)
 					0, PAGE_SIZE, DMA_BIDIRECTIONAL);
 		}
 	} else {
-		addrs = kzalloc(npages * sizeof(addrs), GFP_KERNEL);
+		addrs = kzalloc(npages * sizeof(*addrs), GFP_KERNEL);
 		if (!addrs) {
 			ret = -ENOMEM;
 			goto free_pages;
-- 
1.7.9.5

