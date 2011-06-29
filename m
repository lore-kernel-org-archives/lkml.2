Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758508Ab1F3HLt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 03:11:49 -0400
Received: from us7.mainehost.net ([65.126.238.4]:39051 "EHLO us7.mainehost.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751523Ab1F3HLn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 03:11:43 -0400
X-Greylist: delayed 11328 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Jun 2011 03:11:43 EDT
Subject: [PATCH] DMA: OMAP: Remove extra looping from omap_request_dma
From: Scott Ellis <scott@jumpnowtek.com>
To: linux-omap@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 29 Jun 2011 10:09:09 -0400
Message-ID: <1309356549.3995.13.camel@quad>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - us7.mainehost.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - jumpnowtek.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Break from dma channel search when a free one is found.

Signed-off-by: Scott Ellis <scott@jumpnowtek.com>
---
 arch/arm/plat-omap/dma.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/arm/plat-omap/dma.c b/arch/arm/plat-omap/dma.c
index c22217c..3d36fcf 100644
--- a/arch/arm/plat-omap/dma.c
+++ b/arch/arm/plat-omap/dma.c
@@ -678,10 +678,9 @@ int omap_request_dma(int dev_id, const char *dev_name,
 
 	spin_lock_irqsave(&dma_chan_lock, flags);
 	for (ch = 0; ch < dma_chan_count; ch++) {
-		if (free_ch == -1 && dma_chan[ch].dev_id == -1) {
+		if (dma_chan[ch].dev_id == -1) {
 			free_ch = ch;
-			if (dev_id == 0)
-				break;
+			break;
 		}
 	}
 	if (free_ch == -1) {

