Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458Ab0F2KQc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 06:16:32 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33660 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755429Ab0F2KQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 06:16:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ugwguE46ny3ufs/KciCwXioJa7s1ppP7rXNthyB1T4aRAYa5F2WbT6fevSngZUa4Nm
         cSXEUSi4Qvbpl3kXgdbL79ccaAT+klrjzdDxvJ7JWBAWd225CJsQlda+nWd12xswFhRC
         o4Udjw7n7oAhaBXI0JouOhOX75SpJ/8UCZDMU=
From: Kulikov Vasiliy <segooon@gmail.com>
To: Kernel Janitors <kernel-janitors@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Martyn Welch <martyn.welch@ge.com>,
       Julia Lawall <julia@diku.dk>, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 22/25] vme_tsi148: remove casts from void*
Date: Tue, 29 Jun 2010 14:16:20 +0400
Message-Id: <1277806581-31452-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unnesessary casts from void*.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/staging/vme/bridges/vme_tsi148.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/vme/bridges/vme_tsi148.c b/drivers/staging/vme/bridges/vme_tsi148.c
index abe88a3..4685a31 100644
--- a/drivers/staging/vme/bridges/vme_tsi148.c
+++ b/drivers/staging/vme/bridges/vme_tsi148.c
@@ -1649,7 +1649,7 @@ int tsi148_dma_list_add(struct vme_dma_list *list, struct vme_dma_attr *src,
 	/* Fill out source part */
 	switch (src->type) {
 	case VME_DMA_PATTERN:
-		pattern_attr = (struct vme_dma_pattern *)src->private;
+		pattern_attr = src->private;
 
 		entry->descriptor.dsal = pattern_attr->pattern;
 		entry->descriptor.dsat = TSI148_LCSR_DSAT_TYP_PAT;
@@ -1663,7 +1663,7 @@ int tsi148_dma_list_add(struct vme_dma_list *list, struct vme_dma_attr *src,
 
 		break;
 	case VME_DMA_PCI:
-		pci_attr = (struct vme_dma_pci *)src->private;
+		pci_attr = src->private;
 
 		reg_split((unsigned long long)pci_attr->address, &address_high,
 			&address_low);
@@ -1672,7 +1672,7 @@ int tsi148_dma_list_add(struct vme_dma_list *list, struct vme_dma_attr *src,
 		entry->descriptor.dsat = TSI148_LCSR_DSAT_TYP_PCI;
 		break;
 	case VME_DMA_VME:
-		vme_attr = (struct vme_dma_vme *)src->private;
+		vme_attr = src->private;
 
 		reg_split((unsigned long long)vme_attr->address, &address_high,
 			&address_low);
@@ -1701,7 +1701,7 @@ int tsi148_dma_list_add(struct vme_dma_list *list, struct vme_dma_attr *src,
 	/* Fill out destination part */
 	switch (dest->type) {
 	case VME_DMA_PCI:
-		pci_attr = (struct vme_dma_pci *)dest->private;
+		pci_attr = dest->private;
 
 		reg_split((unsigned long long)pci_attr->address, &address_high,
 			&address_low);
@@ -1710,7 +1710,7 @@ int tsi148_dma_list_add(struct vme_dma_list *list, struct vme_dma_attr *src,
 		entry->descriptor.ddat = TSI148_LCSR_DDAT_TYP_PCI;
 		break;
 	case VME_DMA_VME:
-		vme_attr = (struct vme_dma_vme *)dest->private;
+		vme_attr = dest->private;
 
 		reg_split((unsigned long long)vme_attr->address, &address_high,
 			&address_low);
-- 
1.7.0.4

