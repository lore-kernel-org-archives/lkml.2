Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756561Ab0HIMJs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 08:09:48 -0400
Received: from eu1sys200aog105.obsmtp.com ([207.126.144.119]:54477 "EHLO
	eu1sys200aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756336Ab0HIMJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 08:09:19 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>, Jonas Aaberg <jonas.aberg@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 13/14] DMAENGINE: ste_dma40: don't pause/resume non-executing channels
Date: Mon, 9 Aug 2010 14:09:12 +0200
Message-ID: <1281355752-13618-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.3.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonas Aaberg <jonas.aberg@stericsson.com>

There is no point in pausing what isn't running.

Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/dma/ste_dma40.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index c9f485e..05d0a99 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -768,6 +768,9 @@ static int d40_pause(struct dma_chan *chan)
 	int res = 0;
 	unsigned long flags;
 
+	if (!d40c->busy)
+		return 0;
+
 	spin_lock_irqsave(&d40c->lock, flags);
 
 	res = d40_channel_execute_command(d40c, D40_DMA_SUSPEND_REQ);
@@ -792,6 +795,9 @@ static int d40_resume(struct dma_chan *chan)
 	int res = 0;
 	unsigned long flags;
 
+	if (!d40c->busy)
+		return 0;
+
 	spin_lock_irqsave(&d40c->lock, flags);
 
 	if (d40c->base->rev == 0)
-- 
1.6.3.3

