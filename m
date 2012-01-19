Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073Ab2ASHwa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 02:52:30 -0500
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:44051
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753805Ab2ASHw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 02:52:26 -0500
X-SpamScore: 3
X-BigFish: VS3(zzzz1202h1082kzz8275bhz2dhc1bhc31hc1ah2a8h668h839h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-SS: 0,
From: Huang Shijie <b32955@freescale.com>
To: <shawn.guo@linaro.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <akpm@linux-foundation.org>, <u.kleine-koenig@pengutronix.de>,
        Huang Shijie <b32955@freescale.com>
Subject: [PATCH resent v2 1/2] ioport : add DEFINE_RES_DMA_SIZE_NAMED macro
Date: Thu, 19 Jan 2012 15:53:39 +0800
Message-ID: <1326959620-25920-2-git-send-email-b32955@freescale.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1326959620-25920-1-git-send-email-b32955@freescale.com>
References: <1326959620-25920-1-git-send-email-b32955@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some DMA resource does have the range more then ones.

Signed-off-by: Huang Shijie <b32955@freescale.com>
---
 include/linux/ioport.h |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/include/linux/ioport.h b/include/linux/ioport.h
index 9d57a71..9ea5de4 100644
--- a/include/linux/ioport.h
+++ b/include/linux/ioport.h
@@ -134,8 +134,10 @@ struct resource_list {
 #define DEFINE_RES_IRQ(_irq)						\
 	DEFINE_RES_IRQ_NAMED((_irq), NULL)
 
+#define DEFINE_RES_DMA_SIZE_NAMED(_dma, _size, _name)			\
+	DEFINE_RES_NAMED((_dma), (_size), (_name), IORESOURCE_DMA)
 #define DEFINE_RES_DMA_NAMED(_dma, _name)				\
-	DEFINE_RES_NAMED((_dma), 1, (_name), IORESOURCE_DMA)
+	DEFINE_RES_DMA_SIZE_NAMED((_dma), 1, (_name))
 #define DEFINE_RES_DMA(_dma)						\
 	DEFINE_RES_DMA_NAMED((_dma), NULL)
 
-- 
1.7.0.4


