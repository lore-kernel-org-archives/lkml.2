Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756528Ab0HIMJK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 08:09:10 -0400
Received: from eu1sys200aog109.obsmtp.com ([207.126.144.127]:42507 "EHLO
	eu1sys200aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756410Ab0HIMJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 08:09:04 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>, Jonas Aaberg <jonas.aberg@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 10/14] DMAENGINE: ste_dma40: fix possible use of uninitialized variable
Date: Mon, 9 Aug 2010 14:08:49 +0200
Message-ID: <1281355729-13464-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.3.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonas Aaberg <jonas.aberg@stericsson.com>

Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/dma/ste_dma40.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 2b209fa..ac325e9 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -684,12 +684,12 @@ static void d40_config_write(struct d40_chan *d40c)
 
 static void d40_desc_load(struct d40_chan *d40c, struct d40_desc *d40d)
 {
-	if (d40d->lli_phy.dst && d40d->lli_phy.src) {
+	if (d40c->log_num == D40_PHY_CHAN) {
 		d40_phy_lli_write(d40c->base->virtbase,
 				  d40c->phy_chan->num,
 				  d40d->lli_phy.dst,
 				  d40d->lli_phy.src);
-	} else if (d40d->lli_log.dst && d40d->lli_log.src) {
+	} else {
 		struct d40_log_lli *src = d40d->lli_log.src;
 		struct d40_log_lli *dst = d40d->lli_log.dst;
 		int s;
-- 
1.6.3.3

