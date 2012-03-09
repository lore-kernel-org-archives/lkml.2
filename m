Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031601Ab2CITwM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 14:52:12 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53292 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031557Ab2CITv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 14:51:59 -0500
Message-Id: <20120309190216.590631738@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 09 Mar 2012 11:02:34 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Gusakov Andrey <dron0gus@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>, Kukjin Kim <kgene.kim@samsung.com>
Subject: [ 20/68] ARM: S3C24XX: DMA resume regression fix
In-Reply-To: <20120309194409.GA2069@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gusakov Andrey <dron0gus@gmail.com>

commit e39d40c65dfd8390b50c03482ae9e289b8a8f351 upstream.

s3c2410_dma_suspend suspends channels from 0 to dma_channels.
s3c2410_dma_resume resumes channels in reverse order. So
pointer should be decremented instead of being incremented.

Signed-off-by: Gusakov Andrey <dron0gus@gmail.com>
Reviewed-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/plat-s3c24xx/dma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/plat-s3c24xx/dma.c
+++ b/arch/arm/plat-s3c24xx/dma.c
@@ -1249,7 +1249,7 @@ static void s3c2410_dma_resume(void)
 	struct s3c2410_dma_chan *cp = s3c2410_chans + dma_channels - 1;
 	int channel;
 
-	for (channel = dma_channels - 1; channel >= 0; cp++, channel--)
+	for (channel = dma_channels - 1; channel >= 0; cp--, channel--)
 		s3c2410_dma_resume_chan(cp);
 }
 


