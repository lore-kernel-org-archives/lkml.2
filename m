Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756170Ab1AaQbS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 11:31:18 -0500
Received: from kroah.org ([198.145.64.141]:46370 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754954Ab1AaQbQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 11:31:16 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Pavel Machek <pavel@ucw.cz>, stable <stable@kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 3/5] serial: unbreak billionton CF card
Date: Mon, 31 Jan 2011 08:31:08 -0800
Message-Id: <1296491470-23096-3-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20110131162852.GA22875@kroah.com>
References: <20110131162852.GA22875@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavel Machek <pavel@ucw.cz>

Unbreak Billionton CF bluetooth card. This actually fixes a regression
on zaurus.

Signed-off-by: Pavel Machek <pavel@ucw.cz>
Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/tty/serial/8250.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/tty/serial/8250.c b/drivers/tty/serial/8250.c
index b25e6e4..3975df6 100644
--- a/drivers/tty/serial/8250.c
+++ b/drivers/tty/serial/8250.c
@@ -236,7 +236,8 @@ static const struct serial8250_config uart_config[] = {
 		.fifo_size	= 128,
 		.tx_loadsz	= 128,
 		.fcr		= UART_FCR_ENABLE_FIFO | UART_FCR_R_TRIG_10,
-		.flags		= UART_CAP_FIFO | UART_CAP_EFR | UART_CAP_SLEEP,
+		/* UART_CAP_EFR breaks billionon CF bluetooth card. */
+		.flags		= UART_CAP_FIFO | UART_CAP_SLEEP,
 	},
 	[PORT_16654] = {
 		.name		= "ST16654",
-- 
1.7.1

