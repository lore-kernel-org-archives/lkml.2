Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667Ab1IFOC2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 10:02:28 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:2686
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754618Ab1IFOCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 10:02:23 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bh8275dhz32i668h839h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-FB-SS: 13,
X-WSS-ID: 0LR3TNR-01-EVV-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: Joerg Roedel <joerg.roedel@amd.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        <linux-media@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] arm: omap: Fix build error in ispccdc.c
Date: Tue, 6 Sep 2011 16:02:15 +0200
Message-ID: <1315317735-5255-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following build error occurs with 3.1-rc5:

  CC      drivers/media/video/omap3isp/ispccdc.o
/home/data/repos/linux.trees.git/drivers/media/video/omap3isp/ispccdc.c: In function 'ccdc_lsc_config':
/home/data/repos/linux.trees.git/drivers/media/video/omap3isp/ispccdc.c:427:2: error: implicit declaration of function 'kzalloc' [-Werror=implicit-function-declaration]
/home/data/repos/linux.trees.git/drivers/media/video/omap3isp/ispccdc.c:427:6: warning: assignment makes pointer from integer without a cast [enabled by default]

This patch adds the missing 'linux/slab.h' include to fix the problem.

Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Cc: linux-omap@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/media/video/omap3isp/ispccdc.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/omap3isp/ispccdc.c b/drivers/media/video/omap3isp/ispccdc.c
index 9d3459d..80796eb 100644
--- a/drivers/media/video/omap3isp/ispccdc.c
+++ b/drivers/media/video/omap3isp/ispccdc.c
@@ -31,6 +31,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/mm.h>
 #include <linux/sched.h>
+#include <linux/slab.h>
 #include <media/v4l2-event.h>
 
 #include "isp.h"
-- 
1.7.4.1


