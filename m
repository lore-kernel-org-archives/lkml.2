Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194Ab1EZG1A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 02:27:00 -0400
Received: from db3ehsobe006.messaging.microsoft.com ([213.199.154.144]:26581
	"EHLO DB3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751165Ab1EZG06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 02:26:58 -0400
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275dhz2dh87h2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
From: Shawn Guo <shawn.guo@linaro.org>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <vinod.koul@intel.com>,
        <dan.j.williams@intel.com>, <patches@linaro.org>,
        Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH 1/3] dmaengine: add new dma API for max_segment_number
Date: Thu, 26 May 2011 14:31:31 +0800
Message-ID: <1306391493-29425-1-git-send-email-shawn.guo@linaro.org>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Like dma_set(get)_max_seg_size for max_segment_size, the patch adds
max_segment_number into device_dma_parameters and creates the
corresponding dmaengine API dma_set(get)_max_seg_number for it.

Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
---
 include/linux/device.h      |    1 +
 include/linux/dma-mapping.h |   15 +++++++++++++++
 2 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/include/linux/device.h b/include/linux/device.h
index c66111a..44cb2528 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -487,6 +487,7 @@ struct device_dma_parameters {
 	 * sg limitations.
 	 */
 	unsigned int max_segment_size;
+	unsigned int max_segment_number;
 	unsigned long segment_boundary_mask;
 };
 
diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index ba8319a..fd314f4 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -131,6 +131,21 @@ static inline unsigned int dma_set_max_seg_size(struct device *dev,
 		return -EIO;
 }
 
+static inline unsigned int dma_get_max_seg_number(struct device *dev)
+{
+	return dev->dma_parms ? dev->dma_parms->max_segment_number : 1;
+}
+
+static inline unsigned int dma_set_max_seg_number(struct device *dev,
+						  unsigned int number)
+{
+	if (dev->dma_parms) {
+		dev->dma_parms->max_segment_number = number;
+		return 0;
+	} else
+		return -EIO;
+}
+
 static inline unsigned long dma_get_seg_boundary(struct device *dev)
 {
 	return dev->dma_parms ?
-- 
1.7.4.1


