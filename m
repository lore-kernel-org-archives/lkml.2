Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755431Ab0F2KQZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 06:16:25 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:47959 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755404Ab0F2KQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 06:16:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=tP3FHLhYJui5XUglbx4wyfWDfmNW62ppj1N2JTcgVZZv+gI8Pewz7F2SXPu+ygWwHJ
         cf9b8mLscEt+iD0EQENu4MSzB3CccepCFLNV4H7oApsBbYqVu/5Vy5AtKogXj4CWYzDa
         seZnxUAJDD8GsILfe3p9CE4NzYj+cIUuK9Bl0=
From: Kulikov Vasiliy <segooon@gmail.com>
To: Kernel Janitors <kernel-janitors@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Martyn Welch <martyn.welch@ge.com>,
       Julia Lawall <julia@diku.dk>, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 21/25] vme_ca91cx42: remove casts from void*
Date: Tue, 29 Jun 2010 14:16:16 +0400
Message-Id: <1277806577-31418-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unnesessary casts from void*.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/staging/vme/bridges/vme_ca91cx42.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/vme/bridges/vme_ca91cx42.c b/drivers/staging/vme/bridges/vme_ca91cx42.c
index 0c82eb4..ce05ffa 100644
--- a/drivers/staging/vme/bridges/vme_ca91cx42.c
+++ b/drivers/staging/vme/bridges/vme_ca91cx42.c
@@ -961,11 +961,11 @@ int ca91cx42_dma_list_add(struct vme_dma_list *list, struct vme_dma_attr *src,
 
 	if (dest->type == VME_DMA_VME) {
 		entry->descriptor.dctl |= CA91CX42_DCTL_L2V;
-		vme_attr = (struct vme_dma_vme *)dest->private;
-		pci_attr = (struct vme_dma_pci *)src->private;
+		vme_attr = dest->private;
+		pci_attr = src->private;
 	} else {
-		vme_attr = (struct vme_dma_vme *)src->private;
-		pci_attr = (struct vme_dma_pci *)dest->private;
+		vme_attr = src->private;
+		pci_attr = dest->private;
 	}
 
 	/* Check we can do fullfill required attributes */
-- 
1.7.0.4

