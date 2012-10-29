Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933181Ab2J2VpV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 17:45:21 -0400
Received: from mail.kernel.org ([198.145.19.201]:48864 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932998Ab2J2Vlw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 17:41:52 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Vinod Koul <vinod.koul@linux.intel.com>
Subject: [ 44/54] dmaengine: imx-dma: fix missing unlock on error in imxdma_xfer_desc()
Date: Mon, 29 Oct 2012 14:40:45 -0700
Message-Id: <20121029213807.659418169@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121029213802.697479610@linuxfoundation.org>
References: <20121029213802.697479610@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

commit 720dfd250e48a8c7fd1b2b8645955413989c4ee0 upstream.

Add the missing unlock on the error handling path in function
imxdma_xfer_desc().

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Signed-off-by: Vinod Koul <vinod.koul@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/dma/imx-dma.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/dma/imx-dma.c
+++ b/drivers/dma/imx-dma.c
@@ -473,8 +473,10 @@ static int imxdma_xfer_desc(struct imxdm
 			slot = i;
 			break;
 		}
-		if (slot < 0)
+		if (slot < 0) {
+			spin_unlock_irqrestore(&imxdma->lock, flags);
 			return -EBUSY;
+		}
 
 		imxdma->slots_2d[slot].xsr = d->x;
 		imxdma->slots_2d[slot].ysr = d->y;


