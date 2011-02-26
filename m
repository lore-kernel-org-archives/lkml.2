Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751571Ab1BZWgo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 17:36:44 -0500
Received: from cernmx32.cern.ch ([137.138.144.178]:16113 "EHLO
	CERNMX32.cern.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891Ab1BZWgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 17:36:41 -0500
From: Manohar Vanga <manohar.vanga@cern.ch>
To: <martyn.welch@ge.com>
CC: <gregkh@suse.de>, <wfp5p@virginia.edu>, <cota@braap.org>,
        <devel@driverdev.osuosl.org>, <linux-kernel@vger.kernel.org>,
        Manohar Vanga <manohar.vanga@cern.ch>
Subject: [PATCH 1/1] staging: vme: remove unreachable code
Date: Sat, 26 Feb 2011 23:36:15 +0100
Message-ID: <1298759775-7822-2-git-send-email-manohar.vanga@cern.ch>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1298759775-7822-1-git-send-email-manohar.vanga@cern.ch>
References: <1298759775-7822-1-git-send-email-manohar.vanga@cern.ch>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [137.138.192.18]
Keywords: CERN SpamKiller Note: -50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove some unreachable code (kfree calls) from vme.c

Signed-off-by: Manohar Vanga <manohar.vanga@cern.ch>
---
 drivers/staging/vme/vme.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/vme/vme.c b/drivers/staging/vme/vme.c
index d9fc864..bbf58dc 100644
--- a/drivers/staging/vme/vme.c
+++ b/drivers/staging/vme/vme.c
@@ -441,7 +441,6 @@ struct vme_resource *vme_master_request(struct device *dev,
 
 	return resource;
 
-	kfree(resource);
 err_alloc:
 	/* Unlock image */
 	spin_lock(&master_image->lock);
@@ -768,7 +767,6 @@ struct vme_dma_attr *vme_dma_pattern_attribute(u32 pattern,
 
 	return attributes;
 
-	kfree(pattern_attr);
 err_pat:
 	kfree(attributes);
 err_attr:
@@ -809,7 +807,6 @@ struct vme_dma_attr *vme_dma_pci_attribute(dma_addr_t address)
 
 	return attributes;
 
-	kfree(pci_attr);
 err_pci:
 	kfree(attributes);
 err_attr:
@@ -851,7 +848,6 @@ struct vme_dma_attr *vme_dma_vme_attribute(unsigned long long address,
 
 	return attributes;
 
-	kfree(vme_attr);
 err_vme:
 	kfree(attributes);
 err_attr:
-- 
1.7.1

