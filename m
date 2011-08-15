Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751828Ab1HOKmW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 06:42:22 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61900 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287Ab1HOKmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 06:42:21 -0400
From: Johan Hovold <jhovold@gmail.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>,
        linux-kernel@vger.kernel.org, Johan Hovold <jhovold@gmail.com>,
        stable@kernel.org
Subject: [PATCH] mfd: tps65910: fix initialisation of interrupts
Date: Mon, 15 Aug 2011 12:42:03 +0200
Message-Id: <1313404923-2502-1-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix regression introduced by commit
a2974732ca7614aaf0baf9d6dd3ad893d50ce1c5 (TPS65911: Add new irq
definitions) which caused irq_num to be incorrectly set for tps65910.

Cc: stable@kernel.org
Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 drivers/mfd/tps65910-irq.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/tps65910-irq.c b/drivers/mfd/tps65910-irq.c
index 2bfad5c..a56be93 100644
--- a/drivers/mfd/tps65910-irq.c
+++ b/drivers/mfd/tps65910-irq.c
@@ -178,8 +178,10 @@ int tps65910_irq_init(struct tps65910 *tps65910, int irq,
 	switch (tps65910_chip_id(tps65910)) {
 	case TPS65910:
 		tps65910->irq_num = TPS65910_NUM_IRQ;
+		break;
 	case TPS65911:
 		tps65910->irq_num = TPS65911_NUM_IRQ;
+		break;
 	}
 
 	/* Register with genirq */
-- 
1.7.6

