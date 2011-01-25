Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489Ab1AYKTx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 05:19:53 -0500
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:35145 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753468Ab1AYKTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 05:19:50 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>, Lee Jones <lee.jones@linaro.org>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 26/32] dma40: make d40_log_buf_to_lli static
Date: Tue, 25 Jan 2011 11:18:29 +0100
Message-ID: <1295950715-22340-27-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1295950715-22340-1-git-send-email-linus.walleij@stericsson.com>
References: <1295950715-22340-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rabin Vincent <rabin.vincent@stericsson.com>

Acked-by: Per Forlin <per.forlin@stericsson.com>
Acked-by: Jonas Aaberg <jonas.aberg@stericsson.com>
Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/dma/ste_dma40_ll.c |    2 +-
 drivers/dma/ste_dma40_ll.h |    7 -------
 2 files changed, 1 insertions(+), 8 deletions(-)

diff --git a/drivers/dma/ste_dma40_ll.c b/drivers/dma/ste_dma40_ll.c
index 509a130..876aad2 100644
--- a/drivers/dma/ste_dma40_ll.c
+++ b/drivers/dma/ste_dma40_ll.c
@@ -363,7 +363,7 @@ static void d40_log_fill_lli(struct d40_log_lli *lli,
 
 }
 
-struct d40_log_lli *d40_log_buf_to_lli(struct d40_log_lli *lli_sg,
+static struct d40_log_lli *d40_log_buf_to_lli(struct d40_log_lli *lli_sg,
 				       dma_addr_t addr,
 				       int size,
 				       u32 lcsp13, /* src or dst*/
diff --git a/drivers/dma/ste_dma40_ll.h b/drivers/dma/ste_dma40_ll.h
index cd94afd..4626c88 100644
--- a/drivers/dma/ste_dma40_ll.h
+++ b/drivers/dma/ste_dma40_ll.h
@@ -313,13 +313,6 @@ int d40_phy_sg_to_lli(struct scatterlist *sg,
 
 /* Logical channels */
 
-struct d40_log_lli *d40_log_buf_to_lli(struct d40_log_lli *lli_sg,
-				       dma_addr_t addr,
-				       int size,
-				       u32 lcsp13, /* src or dst*/
-				       u32 data_width1, u32 data_width2,
-				       bool addr_inc);
-
 int d40_log_sg_to_lli(struct scatterlist *sg,
 		      int sg_len,
 		      dma_addr_t dev_addr,
-- 
1.7.3.2

