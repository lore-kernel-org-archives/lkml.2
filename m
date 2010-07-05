Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752744Ab0GEIfm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 04:35:42 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:60519 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413Ab0GEIfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 04:35:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=sZ5tOOIaHH15KGiVS1y1j3rDVEURffs7KtFWXFEXgZqpiQT1vp8Osf+JNmS68jUW5N
         k+HOvsg0zfxLF6veqZKRWLrvJ2ANDeaYjq7bgCt/CP8+5iIoBj6XpIoV3ANTWW7dmiQO
         7jXSkk9Ly5Dq63KmrCPYHTdTX9HHgTlV3JY2w=
MIME-Version: 1.0
Date: Mon, 5 Jul 2010 09:35:38 +0100
Message-ID: <AANLkTilPtW_hOG01qvQHBWMC4b0QJZ8SAL0bZi6j56ns@mail.gmail.com>
Subject: [2.6.35-rc3] select useful number of entries for DMA debugging...
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When booting 2.6.35-rc3 on some different x86 boxes with DMA debugging
enabled, I've consistently seen it exhaust the allocated entries during
boot, giving 'DMA-API: debugging out of memory - disabling'.

Increase number of entries to allow DMA debugging again.

Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>

diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index 4b7e3d8..5ff7f12 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -53,7 +53,7 @@ struct device x86_dma_fallback_dev = {
 EXPORT_SYMBOL(x86_dma_fallback_dev);

 /* Number of entries preallocated for DMA-API debugging */
-#define PREALLOC_DMA_DEBUG_ENTRIES       32768
+#define PREALLOC_DMA_DEBUG_ENTRIES       65536

 int dma_set_mask(struct device *dev, u64 mask)
 {
-- 
Daniel J Blueman
