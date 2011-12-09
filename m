Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875Ab1LINrj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 08:47:39 -0500
Received: from mail.karo-electronics.de ([81.173.242.67]:65432 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693Ab1LINrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 08:47:37 -0500
From: =?utf-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: Wolfgang Grandegger <wg@grandegger.com>
Cc: linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?utf-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
Subject: [PATCH] flexcan: Acknowledge all interrupt sources in the IRQ handler
Date: Fri,  9 Dec 2011 14:47:34 +0100
Message-Id: <1323438454-6816-1-git-send-email-LW@KARO-electronics.de>
X-Mailer: git-send-email 1.5.6.5
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Otherwise the handler will get stuck in an endless IRQ loop when an
interrupt condition occurs that is not being acked (e.g. TWRN)

Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>
---
 drivers/net/can/flexcan.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index e023379..ea8f04d 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -577,7 +577,7 @@ static irqreturn_t flexcan_irq(int irq, void *dev_id)
 
 	reg_iflag1 = flexcan_read(&regs->iflag1);
 	reg_esr = flexcan_read(&regs->esr);
-	flexcan_write(FLEXCAN_ESR_ERR_INT, &regs->esr);	/* ACK err IRQ */
+	flexcan_write(reg_esr, &regs->esr);	/* ACK all IRQs */
 
 	/*
 	 * schedule NAPI in case of:
-- 
1.5.6.5

