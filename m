Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757270Ab0HaMOR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 08:14:17 -0400
Received: from eu1sys200aog110.obsmtp.com ([207.126.144.129]:37799 "EHLO
	eu1sys200aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756930Ab0HaMNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 08:13:07 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>,
        <linux-arm-kernel@lists.infradead.org>, <yuanyabin1978@sina.com>
Cc: <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 09/12] DMAENGINE: remove pointless module safeguard on PL08X
Date: Tue, 31 Aug 2010 14:12:11 +0200
Message-ID: <1283256734-3408-10-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1283256734-3408-9-git-send-email-linus.walleij@stericsson.com>
References: <1283256734-3408-1-git-send-email-linus.walleij@stericsson.com>
 <1283256734-3408-2-git-send-email-linus.walleij@stericsson.com>
 <1283256734-3408-3-git-send-email-linus.walleij@stericsson.com>
 <1283256734-3408-4-git-send-email-linus.walleij@stericsson.com>
 <1283256734-3408-5-git-send-email-linus.walleij@stericsson.com>
 <1283256734-3408-6-git-send-email-linus.walleij@stericsson.com>
 <1283256734-3408-7-git-send-email-linus.walleij@stericsson.com>
 <1283256734-3408-8-git-send-email-linus.walleij@stericsson.com>
 <1283256734-3408-9-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PL08X driver safeguards itself from being compiled as a module
for no reason: the Kconfig option is a bool anyway.

Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/dma/amba-pl08x.c |   12 ------------
 1 files changed, 0 insertions(+), 12 deletions(-)

diff --git a/drivers/dma/amba-pl08x.c b/drivers/dma/amba-pl08x.c
index a7ce08e..f80fc4b 100644
--- a/drivers/dma/amba-pl08x.c
+++ b/drivers/dma/amba-pl08x.c
@@ -130,18 +130,6 @@ struct pl08x_driver_data {
 	spinlock_t lock;
 };
 
-#ifdef MODULE
-
-# error "AMBA PL08X DMA CANNOT BE COMPILED AS A LOADABLE MODULE AT PRESENT"
-
-/*
-	a) Some devices might make use of DMA during boot
-	   (esp true for DMAENGINE implementation)
-	b) Memory allocation will need much more attention
-	   before load/unload can be supported
- */
-#endif
-
 /*
  * PL08X specific defines
  */
-- 
1.6.3.3

