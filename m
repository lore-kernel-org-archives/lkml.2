Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932966Ab1LFHY1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 02:24:27 -0500
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:6114
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932414Ab1LFHYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 02:24:25 -0500
X-SpamScore: 1
X-BigFish: VS1(zzzz1202hzz8275bhz2ei87h2a8h668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:137.71.25.55;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta1.analog.com;RD:nwd2mail10.analog.com;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
From: Sonic Zhang <sonic.adi@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, <linux-serial@vger.kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        <uclinux-dist-devel@blackfin.uclinux.org>,
        Sonic Zhang <sonic.zhang@analog.com>
Subject: [PATCH 1/2] tty: bfin-sport-uart: Rx interrupt is not called always with irq disabled.
Date: Tue, 6 Dec 2011 15:16:33 +0800
Message-ID: <1323155794-14696-1-git-send-email-sonic.adi@gmail.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

Replace local_irq_disable by local_irq_save.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
---
 drivers/tty/serial/bfin_sport_uart.h |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/bfin_sport_uart.h b/drivers/tty/serial/bfin_sport_uart.h
index 6d06ce1..e4510ea 100644
--- a/drivers/tty/serial/bfin_sport_uart.h
+++ b/drivers/tty/serial/bfin_sport_uart.h
@@ -45,11 +45,12 @@
 #define SPORT_GET_RX32(sport) \
 ({ \
 	unsigned int __ret; \
+	unsigned long flags; \
 	if (ANOMALY_05000473) \
-		local_irq_disable(); \
+		local_irq_save(flags); \
 	__ret = bfin_read32((sport)->port.membase + OFFSET_RX); \
 	if (ANOMALY_05000473) \
-		local_irq_enable(); \
+		local_irq_restore(flags); \
 	__ret; \
 })
 #define SPORT_GET_RCR1(sport)		bfin_read16(((sport)->port.membase + OFFSET_RCR1))
-- 
1.7.0.4


