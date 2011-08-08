Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752544Ab1HHTOe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 15:14:34 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:56382 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139Ab1HHTOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 15:14:33 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Rob Herring <rob.herring@calxeda.com>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Vinod Koul <vkoul@infradead.org>
Subject: [PATCH] dmaengine: pl330: add missing include of scatterlist.h
Date: Mon,  8 Aug 2011 14:14:26 -0500
Message-Id: <1312830866-2932-1-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

scatterlist.h was getting implicitly included and now is not which
causes this compile error:

drivers/dma/pl330.c: In function ‘pl330_prep_slave_sg’:
drivers/dma/pl330.c:603:2: error: implicit declaration of function
‘for_each_sg’

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Cc: Jassi Brar <jassisinghbrar@gmail.com>
Cc: Vinod Koul <vkoul@infradead.org>
---
 drivers/dma/pl330.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
index 00eee59..4e2ccde 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -15,6 +15,7 @@
 #include <linux/module.h>
 #include <linux/dmaengine.h>
 #include <linux/interrupt.h>
+#include <linux/scatterlist.h>
 #include <linux/amba/bus.h>
 #include <linux/amba/pl330.h>
 
-- 
1.7.4.1

