Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757128Ab1F0H2L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 03:28:11 -0400
Received: from www.linutronix.de ([62.245.132.108]:57633 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756402Ab1F0H00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 03:26:26 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, sodaville@linutronix.de
Subject: [PATCH 1/2] gpio/gpio-generic: read set register for caching if available
Date: Mon, 27 Jun 2011 09:26:22 +0200
Message-Id: <1309159583-11339-1-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.7.4.4
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ->data is a shadow copy which is used during the ->set callback in
order to avoid a read of the register before write.
If ->reg_set is set then we write to this location therefore we should
cache that value.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/gpio/gpio-generic.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/gpio/gpio-generic.c b/drivers/gpio/gpio-generic.c
index 231714d..9f8b5c6 100644
--- a/drivers/gpio/gpio-generic.c
+++ b/drivers/gpio/gpio-generic.c
@@ -398,7 +398,10 @@ int __devinit bgpio_init(struct bgpio_chip *bgc,
 	if (ret)
 		return ret;
 
-	bgc->data = bgc->read_reg(bgc->reg_dat);
+	if (bgc->reg_set)
+		bgc->data = bgc->read_reg(bgc->reg_set);
+	else
+		bgc->data = bgc->read_reg(bgc->reg_dat);
 
 	return ret;
 }
-- 
1.7.4.4

