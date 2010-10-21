Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757512Ab0JUTE4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 15:04:56 -0400
Received: from eu1sys200aog105.obsmtp.com ([207.126.144.119]:58061 "EHLO
	eu1sys200aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753954Ab0JUTE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 15:04:56 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH] DMAENGINE: move COH901318 to arch_initcall
Date: Thu, 21 Oct 2010 21:04:38 +0200
Message-ID: <1287687878-27016-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.3.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After moving the PL022 driver to subsys_initcall() due to the need
of having stuff like regulators on the other end of the SPI link,
I noticed that the COH901318 DMA engine will get probed before
the DMA engine, so move it to an arch_initcall().

Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/dma/coh901318.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/coh901318.c b/drivers/dma/coh901318.c
index ae2b871..a665683 100644
--- a/drivers/dma/coh901318.c
+++ b/drivers/dma/coh901318.c
@@ -1610,7 +1610,7 @@ int __init coh901318_init(void)
 {
 	return platform_driver_probe(&coh901318_driver, coh901318_probe);
 }
-subsys_initcall(coh901318_init);
+arch_initcall(coh901318_init);
 
 void __exit coh901318_exit(void)
 {
-- 
1.6.3.3

