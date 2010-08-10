Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933283Ab0HJWOu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 18:14:50 -0400
Received: from kroah.org ([198.145.64.141]:44783 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933260Ab0HJV7f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 17:59:35 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Yegor Yefremov <yegor_sub1@visionsystems.de>,
        Yegor Yefremov <yegorslists@googlemail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 04/68] serial: add UART_CAP_EFR and UART_CAP_SLEEP flags to 16C950 UARTs definition
Date: Tue, 10 Aug 2010 14:58:26 -0700
Message-Id: <1281477570-18944-4-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20100810214425.GB17385@kroah.com>
References: <20100810214425.GB17385@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yegor Yefremov <yegor_sub1@visionsystems.de>

Adding UART_CAP_EFR and UART_CAP_SLEEP flags will enable sleep mode
and automatic CTS flow control for 16C950 UARTs. It will also avoid
capabilities detection warning like this:

"ttyS0: detected caps 00000700 should be 00000100"

Signed-off-by: Yegor Yefremov <yegorslists@googlemail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/8250.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index 09ef570..bc8ed4b 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -241,7 +241,7 @@ static const struct serial8250_config uart_config[] = {
 		.fifo_size	= 128,
 		.tx_loadsz	= 128,
 		.fcr		= UART_FCR_ENABLE_FIFO | UART_FCR_R_TRIG_10,
-		.flags		= UART_CAP_FIFO,
+		.flags		= UART_CAP_FIFO | UART_CAP_EFR | UART_CAP_SLEEP,
 	},
 	[PORT_16654] = {
 		.name		= "ST16654",
-- 
1.7.2

