Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933624Ab0KOULJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 15:11:09 -0500
Received: from canuck.infradead.org ([134.117.69.58]:49235 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755498Ab0KOULI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 15:11:08 -0500
Subject: serial8250: Mark console as CON_ANYTIME
From: Peter Zijlstra <peterz@infradead.org>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>, tglx <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, linux-serial@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 15 Nov 2010 21:11:12 +0100
Message-ID: <1289851872.2109.550.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


While trying to debug a cpu-hotplug issue I noticed printk() stopped
working once the cpu got marked offline, since the 8250 serial console
doesn't have any per-cpu resources the CON_ANYTIME bit is the safe and
documented way to make it work again.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 drivers/serial/8250.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index 4d8e14b..09a5508 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -2872,7 +2872,7 @@ static struct console serial8250_console = {
 	.device		= uart_console_device,
 	.setup		= serial8250_console_setup,
 	.early_setup	= serial8250_console_early_setup,
-	.flags		= CON_PRINTBUFFER,
+	.flags		= CON_PRINTBUFFER | CON_ANYTIME,
 	.index		= -1,
 	.data		= &serial8250_reg,
 };

