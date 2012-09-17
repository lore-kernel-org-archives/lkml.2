Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882Ab2IQAtS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 20:49:18 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33293 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752304Ab2IQAtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 20:49:09 -0400
Message-Id: <20120917003626.469953833@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 17 Sep 2012 01:36:27 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Heiko Stuebner <heiko@sntech.de>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: [ 002/135] ARM: S3C24XX: Fix s3c2410_dma_enqueue parameters
In-Reply-To: <20120917003625.784119135@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Stuebner <heiko@sntech.de>

commit b01858c7806e7e6f6121da2e51c9222fc4d21dc6 upstream.

Commit d670ac019f60 (ARM: SAMSUNG: DMA Cleanup as per sparse) changed the
prototype of the s3c2410_dma_* functions to use the enum dma_ch instead
of an generic unsigned int.

In the s3c24xx dma.c s3c2410_dma_enqueue seems to have been forgotten,
the other functions there were changed correctly.

Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/arm/plat-s3c24xx/dma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/plat-s3c24xx/dma.c b/arch/arm/plat-s3c24xx/dma.c
index 28f898f..db98e70 100644
--- a/arch/arm/plat-s3c24xx/dma.c
+++ b/arch/arm/plat-s3c24xx/dma.c
@@ -430,7 +430,7 @@ s3c2410_dma_canload(struct s3c2410_dma_chan *chan)
  * when necessary.
 */
 
-int s3c2410_dma_enqueue(unsigned int channel, void *id,
+int s3c2410_dma_enqueue(enum dma_ch channel, void *id,
 			dma_addr_t data, int size)
 {
 	struct s3c2410_dma_chan *chan = s3c_dma_lookup_channel(channel);


