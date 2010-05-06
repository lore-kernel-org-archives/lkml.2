Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756492Ab0EFJ7A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 05:59:00 -0400
Received: from mx1.zhaw.ch ([160.85.104.50]:37525 "EHLO mx1.zhaw.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751360Ab0EFJ66 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 05:58:58 -0400
From: Tobias Klauser <tklauser@distanz.ch>
To: dan.j.williams@intel.com
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       Tobias Klauser <tklauser@distanz.ch>
Subject: [PATCH] dmaengine: mpc512x: Use resource_size
Date: Thu,  6 May 2010 11:58:55 +0200
Message-Id: <1273139935-26789-1-git-send-email-tklauser@distanz.ch>
X-Mailer: git-send-email 1.6.3.3
X-PMX-Version: 5.5.9.395186, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2010.5.6.94514
X-PerlMx-Spam: Gauge=IIIIIIII, Probability=8%, Report='
 BODYTEXTP_SIZE_3000_LESS 0, BODY_SIZE_1000_LESS 0, BODY_SIZE_2000_LESS 0, BODY_SIZE_5000_LESS 0, BODY_SIZE_7000_LESS 0, BODY_SIZE_700_799 0, TO_NO_NAME 0, __HAS_MSGID 0, __HAS_X_MAILER 0, __MIME_TEXT_ONLY 0, __SANE_MSGID 0, __TO_MALFORMED_2 0, __URI_NO_PATH 0, __URI_NO_WWW 0, __URI_NS '
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the resource_size function instead of manually calculating the
resource size.  This reduces the chance of introducing off-by-one
errors.

Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
---
 drivers/dma/mpc512x_dma.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/mpc512x_dma.c b/drivers/dma/mpc512x_dma.c
index 84326c9..201e6e1 100644
--- a/drivers/dma/mpc512x_dma.c
+++ b/drivers/dma/mpc512x_dma.c
@@ -658,7 +658,7 @@ static int __devinit mpc_dma_probe(struct of_device *op,
 	}
 
 	regs_start = res.start;
-	regs_size = res.end - res.start + 1;
+	regs_size = resource_size(&res);
 
 	if (!devm_request_mem_region(dev, regs_start, regs_size, DRV_NAME)) {
 		dev_err(dev, "Error requesting memory region!\n");
-- 
1.6.3.3

