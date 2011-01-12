Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932564Ab1ALN3T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 08:29:19 -0500
Received: from mail.atmel.fr ([81.80.104.162]:36331 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932413Ab1ALN3O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 08:29:14 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: dan.j.williams@intel.com, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, hong.xu@atmel.com,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 4/6] dmaengine: at_hdmac: use subsys_initcall instead of module_init
Date: Wed, 12 Jan 2011 15:39:08 +0100
Message-Id: <1294843150-6962-3-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <1292435416-16927-1-git-send-email-nicolas.ferre@atmel.com>
References: <1292435416-16927-1-git-send-email-nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Xu <hong.xu@atmel.com>

Use subsys_initcall instead of module_init in order to keep DMA engine rolling
before other peripheral drivers.

Signed-off-by: Eric Xu <hong.xu@atmel.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/dma/at_hdmac.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
index 4f83431..a1a0fc6 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -1209,7 +1209,7 @@ static int __init at_dma_init(void)
 {
 	return platform_driver_probe(&at_dma_driver, at_dma_probe);
 }
-module_init(at_dma_init);
+subsys_initcall(at_dma_init);
 
 static void __exit at_dma_exit(void)
 {
-- 
1.7.3

