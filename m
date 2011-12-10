Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751482Ab1LJN2U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Dec 2011 08:28:20 -0500
Received: from www.linutronix.de ([62.245.132.108]:49300 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152Ab1LJN2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Dec 2011 08:28:00 -0500
Message-Id: <20111210132438.986999582@linutronix.de>
User-Agent: quilt/0.48-1
Date: Sat, 10 Dec 2011 13:27:56 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Pekka Enberg <penberg@kernel.org>, Sasha Levin <levinsasha928@gmail.com>
Subject: [patch 1/3] kvm tool: serial: Cleanup coding style
References: <20111210132220.083204833@linutronix.de>
Content-Disposition: inline; filename=kvm-tool-cleanup-serial-c.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's nice to align struct initializers, but random tab insertion into
the code flow is a horrible idea.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 tools/kvm/hw/serial.c |   69 ++++++++++++++++++++++++--------------------------
 1 file changed, 34 insertions(+), 35 deletions(-)

Index: linux-kvm/tools/kvm/hw/serial.c
===================================================================
--- linux-kvm.orig/tools/kvm/hw/serial.c
+++ linux-kvm/tools/kvm/hw/serial.c
@@ -91,13 +91,13 @@ static void serial8250__sysrq(struct kvm
 {
 	switch (sysrq_pending) {
 	case SYSRQ_PENDING_BREAK:
-		dev->lsr	|= UART_LSR_DR | UART_LSR_BI;
+		dev->lsr |= UART_LSR_DR | UART_LSR_BI;
 
-		sysrq_pending	= SYSRQ_PENDING_CMD;
+		sysrq_pending = SYSRQ_PENDING_CMD;
 		break;
 	case SYSRQ_PENDING_CMD:
-		dev->rbr	= 'p';
-		dev->lsr	|= UART_LSR_DR;
+		dev->rbr = 'p';
+		dev->lsr |= UART_LSR_DR;
 
 		sysrq_pending	= SYSRQ_PENDING_NONE;
 		break;
@@ -124,8 +124,8 @@ static void serial8250__receive(struct k
 	if (c < 0)
 		return;
 
-	dev->rbr	= c;
-	dev->lsr	|= UART_LSR_DR;
+	dev->rbr = c;
+	dev->lsr |= UART_LSR_DR;
 }
 
 void serial8250__inject_interrupt(struct kvm *kvm)
@@ -140,11 +140,11 @@ void serial8250__inject_interrupt(struct
 		serial8250__receive(kvm, dev);
 
 		if (dev->ier & UART_IER_RDI && dev->lsr & UART_LSR_DR)
-			dev->iir		= UART_IIR_RDI;
+			dev->iir = UART_IIR_RDI;
 		else if (dev->ier & UART_IER_THRI)
-			dev->iir		= UART_IIR_THRI;
+			dev->iir = UART_IIR_THRI;
 		else
-			dev->iir		= UART_IIR_NO_INT;
+			dev->iir = UART_IIR_NO_INT;
 
 		if (dev->iir != UART_IIR_NO_INT) {
 			kvm__irq_line(kvm, dev->irq, 0);
@@ -179,30 +179,30 @@ static bool serial8250_out(struct ioport
 	u16 offset;
 	bool ret = true;
 
-	dev		= find_device(port);
+	dev = find_device(port);
 	if (!dev)
 		return false;
 
 	mutex_lock(&dev->mutex);
 
-	offset		= port - dev->iobase;
+	offset = port - dev->iobase;
 
 	if (dev->lcr & UART_LCR_DLAB) {
 		switch (offset) {
 		case UART_DLL:
-			dev->dll	= ioport__read8(data);
+			dev->dll = ioport__read8(data);
 			break;
 		case UART_DLM:
-			dev->dlm	= ioport__read8(data);
+			dev->dlm = ioport__read8(data);
 			break;
 		case UART_FCR:
-			dev->fcr	= ioport__read8(data);
+			dev->fcr = ioport__read8(data);
 			break;
 		case UART_LCR:
-			dev->lcr	= ioport__read8(data);
+			dev->lcr = ioport__read8(data);
 			break;
 		case UART_MCR:
-			dev->mcr	= ioport__read8(data);
+			dev->mcr = ioport__read8(data);
 			break;
 		case UART_LSR:
 			/* Factory test */
@@ -211,11 +211,11 @@ static bool serial8250_out(struct ioport
 			/* Not used */
 			break;
 		case UART_SCR:
-			dev->scr	= ioport__read8(data);
+			dev->scr = ioport__read8(data);
 			break;
 		default:
-			ret		= false;
-			goto out_unlock;
+			ret = false;
+			break;
 		}
 	} else {
 		switch (offset) {
@@ -225,21 +225,21 @@ static bool serial8250_out(struct ioport
 			if (!(dev->mcr & UART_MCR_LOOP))
 				term_putc(CONSOLE_8250, addr, size, dev->id);
 
-			dev->iir		= UART_IIR_NO_INT;
+			dev->iir = UART_IIR_NO_INT;
 			break;
 		}
 		case UART_FCR:
-			dev->fcr	= ioport__read8(data);
+			dev->fcr = ioport__read8(data);
 			break;
 		case UART_IER:
-			dev->ier	= ioport__read8(data) & 0x3f;
+			dev->ier = ioport__read8(data) & 0x3f;
 			kvm__irq_line(kvm, dev->irq, dev->ier ? 1 : 0);
 			break;
 		case UART_LCR:
-			dev->lcr	= ioport__read8(data);
+			dev->lcr = ioport__read8(data);
 			break;
 		case UART_MCR:
-			dev->mcr	= ioport__read8(data);
+			dev->mcr = ioport__read8(data);
 			break;
 		case UART_LSR:
 			/* Factory test */
@@ -248,15 +248,14 @@ static bool serial8250_out(struct ioport
 			/* Not used */
 			break;
 		case UART_SCR:
-			dev->scr	= ioport__read8(data);
+			dev->scr = ioport__read8(data);
 			break;
 		default:
-			ret		= false;
-			goto out_unlock;
+			ret = false;
+			break;
 		}
 	}
 
-out_unlock:
 	mutex_unlock(&dev->mutex);
 
 	return ret;
@@ -268,13 +267,13 @@ static bool serial8250_in(struct ioport
 	u16 offset;
 	bool ret = true;
 
-	dev		= find_device(port);
+	dev = find_device(port);
 	if (!dev)
 		return false;
 
 	mutex_lock(&dev->mutex);
 
-	offset		= port - dev->iobase;
+	offset = port - dev->iobase;
 
 	if (dev->lcr & UART_LCR_DLAB) {
 		switch (offset) {
@@ -293,8 +292,8 @@ static bool serial8250_in(struct ioport
 		switch (offset) {
 		case UART_RX:
 			ioport__write8(data, dev->rbr);
-			dev->lsr		&= ~UART_LSR_DR;
-			dev->iir		= UART_IIR_NO_INT;
+			dev->lsr &= ~UART_LSR_DR;
+			dev->iir = UART_IIR_NO_INT;
 			goto out_unlock;
 
 		case UART_IER:
@@ -311,7 +310,7 @@ static bool serial8250_in(struct ioport
 		u8 iir = dev->iir;
 
 		if (dev->fcr & UART_FCR_ENABLE_FIFO)
-			iir		|= 0xc0;
+			iir |= 0xc0;
 
 		ioport__write8(data, iir);
 		break;
@@ -324,7 +323,7 @@ static bool serial8250_in(struct ioport
 		break;
 	case UART_LSR:
 		ioport__write8(data, dev->lsr);
-		dev->lsr		&= ~(UART_LSR_OE|UART_LSR_PE|UART_LSR_FE|UART_LSR_BI);
+		dev->lsr &= ~(UART_LSR_OE|UART_LSR_PE|UART_LSR_FE|UART_LSR_BI);
 		break;
 	case UART_MSR:
 		ioport__write8(data, dev->msr);
@@ -333,7 +332,7 @@ static bool serial8250_in(struct ioport
 		ioport__write8(data, dev->scr);
 		break;
 	default:
-		ret		= false;
+		ret = false;
 		goto out_unlock;
 	}
 out_unlock:


