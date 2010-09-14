Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754163Ab0INQ7c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 12:59:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27806 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753913Ab0INQ7b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 12:59:31 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] MN10300: Fix up the IRQ names for the on-chip serial ports
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-am33-list@redhat.com, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>
Date: Tue, 14 Sep 2010 17:59:15 +0100
Message-ID: <20100914165915.24553.26553.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix up the IRQ names for the MN10300 on-chip serial ports in the driver as
request_interrupt() no longer allows names containing slashes, giving a warning
like the following if one is encountered:

	------------[ cut here ]------------
	WARNING: at fs/proc/generic.c:323 __xlate_proc_name+0x62/0x7c()
	name 'ttySM0/Rx'

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/mn10300/kernel/mn10300-serial.c |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)


diff --git a/arch/mn10300/kernel/mn10300-serial.c b/arch/mn10300/kernel/mn10300-serial.c
index 9d49073..db509dd 100644
--- a/arch/mn10300/kernel/mn10300-serial.c
+++ b/arch/mn10300/kernel/mn10300-serial.c
@@ -156,17 +156,17 @@ struct mn10300_serial_port mn10300_serial_port_sif0 = {
 	._intr		= &SC0ICR,
 	._rxb		= &SC0RXB,
 	._txb		= &SC0TXB,
-	.rx_name	= "ttySM0/Rx",
-	.tx_name	= "ttySM0/Tx",
+	.rx_name	= "ttySM0:Rx",
+	.tx_name	= "ttySM0:Tx",
 #ifdef CONFIG_MN10300_TTYSM0_TIMER8
-	.tm_name	= "ttySM0/Timer8",
+	.tm_name	= "ttySM0:Timer8",
 	._tmxmd		= &TM8MD,
 	._tmxbr		= &TM8BR,
 	._tmicr		= &TM8ICR,
 	.tm_irq		= TM8IRQ,
 	.div_timer	= MNSCx_DIV_TIMER_16BIT,
 #else /* CONFIG_MN10300_TTYSM0_TIMER2 */
-	.tm_name	= "ttySM0/Timer2",
+	.tm_name	= "ttySM0:Timer2",
 	._tmxmd		= &TM2MD,
 	._tmxbr		= (volatile u16 *) &TM2BR,
 	._tmicr		= &TM2ICR,
@@ -209,17 +209,17 @@ struct mn10300_serial_port mn10300_serial_port_sif1 = {
 	._intr		= &SC1ICR,
 	._rxb		= &SC1RXB,
 	._txb		= &SC1TXB,
-	.rx_name	= "ttySM1/Rx",
-	.tx_name	= "ttySM1/Tx",
+	.rx_name	= "ttySM1:Rx",
+	.tx_name	= "ttySM1:Tx",
 #ifdef CONFIG_MN10300_TTYSM1_TIMER9
-	.tm_name	= "ttySM1/Timer9",
+	.tm_name	= "ttySM1:Timer9",
 	._tmxmd		= &TM9MD,
 	._tmxbr		= &TM9BR,
 	._tmicr		= &TM9ICR,
 	.tm_irq		= TM9IRQ,
 	.div_timer	= MNSCx_DIV_TIMER_16BIT,
 #else /* CONFIG_MN10300_TTYSM1_TIMER3 */
-	.tm_name	= "ttySM1/Timer3",
+	.tm_name	= "ttySM1:Timer3",
 	._tmxmd		= &TM3MD,
 	._tmxbr		= (volatile u16 *) &TM3BR,
 	._tmicr		= &TM3ICR,
@@ -260,9 +260,9 @@ struct mn10300_serial_port mn10300_serial_port_sif2 = {
 	.uart.lock	=
 	__SPIN_LOCK_UNLOCKED(mn10300_serial_port_sif2.uart.lock),
 	.name		= "ttySM2",
-	.rx_name	= "ttySM2/Rx",
-	.tx_name	= "ttySM2/Tx",
-	.tm_name	= "ttySM2/Timer10",
+	.rx_name	= "ttySM2:Rx",
+	.tx_name	= "ttySM2:Tx",
+	.tm_name	= "ttySM2:Timer10",
 	._iobase	= &SC2CTR,
 	._control	= &SC2CTR,
 	._status	= &SC2STR,

