Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600Ab1LMGff (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 01:35:35 -0500
Received: from smtp3-g21.free.fr ([212.27.42.3]:54432 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754012Ab1LMGce (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 01:32:34 -0500
From: =?UTF-8?q?Eric=20B=C3=A9nard?= <eric@eukrea.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Sascha Hauer <kernel@pengutronix.de>, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 08/19] dma: MX3_IPU fix depends
Date: Tue, 13 Dec 2011 07:31:40 +0100
Message-Id: <1323757911-25217-8-git-send-email-eric@eukrea.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1323757911-25217-1-git-send-email-eric@eukrea.com>
References: <1323757911-25217-1-git-send-email-eric@eukrea.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ARCH_MX3 was removed in e760b5260d39113794da17c64cbd6e6311155b66
thus preventing to select MX3_IPU, thus preventing IPU and display
to work on i.MX3x SOC.

Signed-off-by: Eric Bénard <eric@eukrea.com>
Cc: Sascha Hauer <kernel@pengutronix.de>
Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dma/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index ab8f469..0b59fea 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -124,7 +124,7 @@ config MV_XOR
 
 config MX3_IPU
 	bool "MX3x Image Processing Unit support"
-	depends on ARCH_MX3
+	depends on SOC_IMX31 || SOC_IMX35
 	select DMA_ENGINE
 	default y
 	help
-- 
1.7.6.4

