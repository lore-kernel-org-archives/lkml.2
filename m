Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933335Ab2ILXzw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 19:55:52 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:58620 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933178Ab2ILXnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 19:43:10 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, Heiko Stuebner <heiko@sntech.de>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: [ 07/46] ARM: S3C24XX: Fix s3c2410_dma_enqueue parameters
Date: Wed, 12 Sep 2012 16:38:57 -0700
Message-Id: <20120912233818.432460711@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120912233817.662663809@linuxfoundation.org>
References: <20120912233817.662663809@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/plat-s3c24xx/dma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/plat-s3c24xx/dma.c
+++ b/arch/arm/plat-s3c24xx/dma.c
@@ -431,7 +431,7 @@ s3c2410_dma_canload(struct s3c2410_dma_c
  * when necessary.
 */
 
-int s3c2410_dma_enqueue(unsigned int channel, void *id,
+int s3c2410_dma_enqueue(enum dma_ch channel, void *id,
 			dma_addr_t data, int size)
 {
 	struct s3c2410_dma_chan *chan = s3c_dma_lookup_channel(channel);


