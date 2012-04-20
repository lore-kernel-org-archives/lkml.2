Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932243Ab2DTP2Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 11:28:24 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:46717 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690Ab2DTP2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 11:28:23 -0400
From: Matt Porter <mporter@ti.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-parport@lists.infradead.org
Subject: [PATCH] parport: remove unused dead code from lowlevel drivers
Date: Fri, 20 Apr 2012 11:28:25 -0400
Message-Id: <1334935705-23888-1-git-send-email-mporter@ti.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This unused code has been untouched for over 7 years and must
go.

Signed-off-by: Matt Porter <mporter@ti.com>
---
 drivers/parport/parport_amiga.c  |   36 -----
 drivers/parport/parport_atari.c  |    9 --
 drivers/parport/parport_mfc3.c   |   35 -----
 drivers/parport/parport_pc.c     |  276 --------------------------------------
 drivers/parport/parport_sunbpp.c |   21 ---
 5 files changed, 0 insertions(+), 377 deletions(-)

diff --git a/drivers/parport/parport_amiga.c b/drivers/parport/parport_amiga.c
index 8bef6d6..ee78e0e 100644
--- a/drivers/parport/parport_amiga.c
+++ b/drivers/parport/parport_amiga.c
@@ -48,23 +48,6 @@ static unsigned char amiga_read_data(struct parport *p)
 	return ciaa.prb;
 }
 
-#if 0
-static unsigned char control_pc_to_amiga(unsigned char control)
-{
-	unsigned char ret = 0;
-
-	if (control & PARPORT_CONTROL_SELECT) /* XXX: What is SELECP? */
-		;
-	if (control & PARPORT_CONTROL_INIT) /* INITP */
-		/* reset connected to cpu reset pin */;
-	if (control & PARPORT_CONTROL_AUTOFD) /* AUTOLF */
-		/* Not connected */;
-	if (control & PARPORT_CONTROL_STROBE) /* Strobe */
-		/* Handled only directly by hardware */;
-	return ret;
-}
-#endif
-
 static unsigned char control_amiga_to_pc(unsigned char control)
 {
 	return PARPORT_CONTROL_SELECT |
@@ -95,25 +78,6 @@ static unsigned char amiga_frob_control( struct parport *p, unsigned char mask,
 	return old;
 }
 
-#if 0 /* currently unused */
-static unsigned char status_pc_to_amiga(unsigned char status)
-{
-	unsigned char ret = 1;
-
-	if (status & PARPORT_STATUS_BUSY) /* Busy */
-		ret &= ~1;
-	if (status & PARPORT_STATUS_ACK) /* Ack */
-		/* handled in hardware */;
-	if (status & PARPORT_STATUS_PAPEROUT) /* PaperOut */
-		ret |= 2;
-	if (status & PARPORT_STATUS_SELECT) /* select */
-		ret |= 4;
-	if (status & PARPORT_STATUS_ERROR) /* error */
-		/* not connected */;
-	return ret;
-}
-#endif
-
 static unsigned char status_amiga_to_pc(unsigned char status)
 {
 	unsigned char ret = PARPORT_STATUS_BUSY | PARPORT_STATUS_ACK | PARPORT_STATUS_ERROR;
diff --git a/drivers/parport/parport_atari.c b/drivers/parport/parport_atari.c
index 0b28fcc..7ad59ac 100644
--- a/drivers/parport/parport_atari.c
+++ b/drivers/parport/parport_atari.c
@@ -130,15 +130,6 @@ parport_atari_data_forward(struct parport *p)
 static void
 parport_atari_data_reverse(struct parport *p)
 {
-#if 0 /* too dangerous, can kill sound chip */
-	unsigned long flags;
-
-	local_irq_save(flags);
-	/* Soundchip port B as input. */
-	sound_ym.rd_data_reg_sel = 7;
-	sound_ym.wd_data = sound_ym.rd_data_reg_sel & ~0x40;
-	local_irq_restore(flags);
-#endif
 }
 
 static struct parport_operations parport_atari_ops = {
diff --git a/drivers/parport/parport_mfc3.c b/drivers/parport/parport_mfc3.c
index 1c0c642..7578d79 100644
--- a/drivers/parport/parport_mfc3.c
+++ b/drivers/parport/parport_mfc3.c
@@ -147,25 +147,6 @@ DPRINTK(KERN_DEBUG "frob_control mask %02x, value %02x\n",mask,val);
 	return old;
 }
 
-#if 0 /* currently unused */
-static unsigned char status_pc_to_mfc3(unsigned char status)
-{
-	unsigned char ret = 1;
-
-	if (status & PARPORT_STATUS_BUSY) /* Busy */
-		ret &= ~1;
-	if (status & PARPORT_STATUS_ACK) /* Ack */
-		ret |= 8;
-	if (status & PARPORT_STATUS_PAPEROUT) /* PaperOut */
-		ret |= 2;
-	if (status & PARPORT_STATUS_SELECT) /* select */
-		ret |= 4;
-	if (status & PARPORT_STATUS_ERROR) /* error */
-		ret |= 16;
-	return ret;
-}
-#endif
-
 static unsigned char status_mfc3_to_pc(unsigned char status)
 {
 	unsigned char ret = PARPORT_STATUS_BUSY;
@@ -184,14 +165,6 @@ static unsigned char status_mfc3_to_pc(unsigned char status)
 	return ret;
 }
 
-#if 0 /* currently unused */
-static void mfc3_write_status( struct parport *p, unsigned char status)
-{
-DPRINTK(KERN_DEBUG "write_status %02x\n",status);
-	pia(p)->ppra = (pia(p)->ppra & 0xe0) | status_pc_to_mfc3(status);
-}
-#endif
-
 static unsigned char mfc3_read_status(struct parport *p)
 {
 	unsigned char status;
@@ -201,14 +174,6 @@ DPRINTK(KERN_DEBUG "read_status %02x\n", status);
 	return status;
 }
 
-#if 0 /* currently unused */
-static void mfc3_change_mode( struct parport *p, int m)
-{
-	/* XXX: This port only has one mode, and I am
-	not sure about the corresponding PC-style mode*/
-}
-#endif
-
 static int use_cnt = 0;
 
 static irqreturn_t mfc3_interrupt(int irq, void *dev_id)
diff --git a/drivers/parport/parport_pc.c b/drivers/parport/parport_pc.c
index 0cb64f5..4029563 100644
--- a/drivers/parport/parport_pc.c
+++ b/drivers/parport/parport_pc.c
@@ -197,54 +197,6 @@ static int change_mode(struct parport *p, int m)
 	ECR_WRITE(p, oecr);
 	return 0;
 }
-
-#ifdef CONFIG_PARPORT_1284
-/* Find FIFO lossage; FIFO is reset */
-#if 0
-static int get_fifo_residue(struct parport *p)
-{
-	int residue;
-	int cnfga;
-	const struct parport_pc_private *priv = p->physport->private_data;
-
-	/* Adjust for the contents of the FIFO. */
-	for (residue = priv->fifo_depth; ; residue--) {
-		if (inb(ECONTROL(p)) & 0x2)
-				/* Full up. */
-			break;
-
-		outb(0, FIFO(p));
-	}
-
-	printk(KERN_DEBUG "%s: %d PWords were left in FIFO\n", p->name,
-		residue);
-
-	/* Reset the FIFO. */
-	frob_set_mode(p, ECR_PS2);
-
-	/* Now change to config mode and clean up. FIXME */
-	frob_set_mode(p, ECR_CNF);
-	cnfga = inb(CONFIGA(p));
-	printk(KERN_DEBUG "%s: cnfgA contains 0x%02x\n", p->name, cnfga);
-
-	if (!(cnfga & (1<<2))) {
-		printk(KERN_DEBUG "%s: Accounting for extra byte\n", p->name);
-		residue++;
-	}
-
-	/* Don't care about partial PWords until support is added for
-	 * PWord != 1 byte. */
-
-	/* Back to PS2 mode. */
-	frob_set_mode(p, ECR_PS2);
-
-	DPRINTK(KERN_DEBUG
-	     "*** get_fifo_residue: done residue collecting (ecr = 0x%2.2x)\n",
-							inb(ECONTROL(p)));
-	return residue;
-}
-#endif  /*  0 */
-#endif /* IEEE 1284 support */
 #endif /* FIFO support */
 
 /*
@@ -940,234 +892,6 @@ static size_t parport_pc_ecp_write_block_pio(struct parport *port,
 
 	return written;
 }
-
-#if 0
-static size_t parport_pc_ecp_read_block_pio(struct parport *port,
-					     void *buf, size_t length,
-					     int flags)
-{
-	size_t left = length;
-	size_t fifofull;
-	int r;
-	const int fifo = FIFO(port);
-	const struct parport_pc_private *priv = port->physport->private_data;
-	const int fifo_depth = priv->fifo_depth;
-	char *bufp = buf;
-
-	port = port->physport;
-	DPRINTK(KERN_DEBUG "parport_pc: parport_pc_ecp_read_block_pio\n");
-	dump_parport_state("enter fcn", port);
-
-	/* Special case: a timeout of zero means we cannot call schedule().
-	 * Also if O_NONBLOCK is set then use the default implementation. */
-	if (port->cad->timeout <= PARPORT_INACTIVITY_O_NONBLOCK)
-		return parport_ieee1284_ecp_read_data(port, buf,
-						       length, flags);
-
-	if (port->ieee1284.mode == IEEE1284_MODE_ECPRLE) {
-		/* If the peripheral is allowed to send RLE compressed
-		 * data, it is possible for a byte to expand to 128
-		 * bytes in the FIFO. */
-		fifofull = 128;
-	} else {
-		fifofull = fifo_depth;
-	}
-
-	/* If the caller wants less than a full FIFO's worth of data,
-	 * go through software emulation.  Otherwise we may have to throw
-	 * away data. */
-	if (length < fifofull)
-		return parport_ieee1284_ecp_read_data(port, buf,
-						       length, flags);
-
-	if (port->ieee1284.phase != IEEE1284_PH_REV_IDLE) {
-		/* change to reverse-idle phase (must be in forward-idle) */
-
-		/* Event 38: Set nAutoFd low (also make sure nStrobe is high) */
-		parport_frob_control(port,
-				      PARPORT_CONTROL_AUTOFD
-				      | PARPORT_CONTROL_STROBE,
-				      PARPORT_CONTROL_AUTOFD);
-		parport_pc_data_reverse(port); /* Must be in PS2 mode */
-		udelay(5);
-		/* Event 39: Set nInit low to initiate bus reversal */
-		parport_frob_control(port,
-				      PARPORT_CONTROL_INIT,
-				      0);
-		/* Event 40: Wait for  nAckReverse (PError) to go low */
-		r = parport_wait_peripheral(port, PARPORT_STATUS_PAPEROUT, 0);
-		if (r) {
-			printk(KERN_DEBUG "%s: PE timeout Event 40 (%d) "
-				"in ecp_read_block_pio\n", port->name, r);
-			return 0;
-		}
-	}
-
-	/* Set up ECP FIFO mode.*/
-/*	parport_pc_frob_control(port,
-				 PARPORT_CONTROL_STROBE |
-				 PARPORT_CONTROL_AUTOFD,
-				 PARPORT_CONTROL_AUTOFD); */
-	r = change_mode(port, ECR_ECP); /* ECP FIFO */
-	if (r)
-		printk(KERN_DEBUG "%s: Warning change_mode ECR_ECP failed\n",
-								port->name);
-
-	port->ieee1284.phase = IEEE1284_PH_REV_DATA;
-
-	/* the first byte must be collected manually */
-	dump_parport_state("pre 43", port);
-	/* Event 43: Wait for nAck to go low */
-	r = parport_wait_peripheral(port, PARPORT_STATUS_ACK, 0);
-	if (r) {
-		/* timed out while reading -- no data */
-		printk(KERN_DEBUG "PIO read timed out (initial byte)\n");
-		goto out_no_data;
-	}
-	/* read byte */
-	*bufp++ = inb(DATA(port));
-	left--;
-	dump_parport_state("43-44", port);
-	/* Event 44: nAutoFd (HostAck) goes high to acknowledge */
-	parport_pc_frob_control(port,
-				 PARPORT_CONTROL_AUTOFD,
-				 0);
-	dump_parport_state("pre 45", port);
-	/* Event 45: Wait for nAck to go high */
-	/* r = parport_wait_peripheral(port, PARPORT_STATUS_ACK,
-						PARPORT_STATUS_ACK); */
-	dump_parport_state("post 45", port);
-	r = 0;
-	if (r) {
-		/* timed out while waiting for peripheral to respond to ack */
-		printk(KERN_DEBUG "ECP PIO read timed out (waiting for nAck)\n");
-
-		/* keep hold of the byte we've got already */
-		goto out_no_data;
-	}
-	/* Event 46: nAutoFd (HostAck) goes low to accept more data */
-	parport_pc_frob_control(port,
-				 PARPORT_CONTROL_AUTOFD,
-				 PARPORT_CONTROL_AUTOFD);
-
-
-	dump_parport_state("rev idle", port);
-	/* Do the transfer. */
-	while (left > fifofull) {
-		int ret;
-		unsigned long expire = jiffies + port->cad->timeout;
-		unsigned char ecrval = inb(ECONTROL(port));
-
-		if (need_resched() && time_before(jiffies, expire))
-			/* Can't yield the port. */
-			schedule();
-
-		/* At this point, the FIFO may already be full. In
-		 * that case ECP is already holding back the
-		 * peripheral (assuming proper design) with a delayed
-		 * handshake.  Work fast to avoid a peripheral
-		 * timeout.  */
-
-		if (ecrval & 0x01) {
-			/* FIFO is empty. Wait for interrupt. */
-			dump_parport_state("FIFO empty", port);
-
-			/* Anyone else waiting for the port? */
-			if (port->waithead) {
-				printk(KERN_DEBUG "Somebody wants the port\n");
-				break;
-			}
-
-			/* Clear serviceIntr */
-			ECR_WRITE(port, ecrval & ~(1<<2));
-false_alarm:
-			dump_parport_state("waiting", port);
-			ret = parport_wait_event(port, HZ);
-			DPRINTK(KERN_DEBUG "parport_wait_event returned %d\n",
-									ret);
-			if (ret < 0)
-				break;
-			ret = 0;
-			if (!time_before(jiffies, expire)) {
-				/* Timed out. */
-				dump_parport_state("timeout", port);
-				printk(KERN_DEBUG "PIO read timed out\n");
-				break;
-			}
-			ecrval = inb(ECONTROL(port));
-			if (!(ecrval & (1<<2))) {
-				if (need_resched() &&
-				    time_before(jiffies, expire)) {
-					schedule();
-				}
-				goto false_alarm;
-			}
-
-			/* Depending on how the FIFO threshold was
-			 * set, how long interrupt service took, and
-			 * how fast the peripheral is, we might be
-			 * lucky and have a just filled FIFO. */
-			continue;
-		}
-
-		if (ecrval & 0x02) {
-			/* FIFO is full. */
-			dump_parport_state("FIFO full", port);
-			insb(fifo, bufp, fifo_depth);
-			bufp += fifo_depth;
-			left -= fifo_depth;
-			continue;
-		}
-
-		DPRINTK(KERN_DEBUG
-		  "*** ecp_read_block_pio: reading one byte from the FIFO\n");
-
-		/* FIFO not filled.  We will cycle this loop for a while
-		 * and either the peripheral will fill it faster,
-		 * tripping a fast empty with insb, or we empty it. */
-		*bufp++ = inb(fifo);
-		left--;
-	}
-
-	/* scoop up anything left in the FIFO */
-	while (left && !(inb(ECONTROL(port) & 0x01))) {
-		*bufp++ = inb(fifo);
-		left--;
-	}
-
-	port->ieee1284.phase = IEEE1284_PH_REV_IDLE;
-	dump_parport_state("rev idle2", port);
-
-out_no_data:
-
-	/* Go to forward idle mode to shut the peripheral up (event 47). */
-	parport_frob_control(port, PARPORT_CONTROL_INIT, PARPORT_CONTROL_INIT);
-
-	/* event 49: PError goes high */
-	r = parport_wait_peripheral(port,
-				     PARPORT_STATUS_PAPEROUT,
-				     PARPORT_STATUS_PAPEROUT);
-	if (r) {
-		printk(KERN_DEBUG
-			"%s: PE timeout FWDIDLE (%d) in ecp_read_block_pio\n",
-			port->name, r);
-	}
-
-	port->ieee1284.phase = IEEE1284_PH_FWD_IDLE;
-
-	/* Finish up. */
-	{
-		int lost = get_fifo_residue(port);
-		if (lost)
-			/* Shouldn't happen with compliant peripherals. */
-			printk(KERN_DEBUG "%s: DATA LOSS (%d bytes)!\n",
-				port->name, lost);
-	}
-
-	dump_parport_state("fwd idle", port);
-	return length - left;
-}
-#endif  /*  0  */
 #endif /* IEEE 1284 support */
 #endif /* Allowed to use FIFO/DMA */
 
diff --git a/drivers/parport/parport_sunbpp.c b/drivers/parport/parport_sunbpp.c
index 9390a53..983a2d2 100644
--- a/drivers/parport/parport_sunbpp.c
+++ b/drivers/parport/parport_sunbpp.c
@@ -82,27 +82,6 @@ static unsigned char parport_sunbpp_read_data(struct parport *p)
 	return sbus_readb(&regs->p_dr);
 }
 
-#if 0
-static void control_pc_to_sunbpp(struct parport *p, unsigned char status)
-{
-	struct bpp_regs __iomem *regs = (struct bpp_regs __iomem *)p->base;
-	unsigned char value_tcr = sbus_readb(&regs->p_tcr);
-	unsigned char value_or = sbus_readb(&regs->p_or);
-
-	if (status & PARPORT_CONTROL_STROBE) 
-		value_tcr |= P_TCR_DS;
-	if (status & PARPORT_CONTROL_AUTOFD) 
-		value_or |= P_OR_AFXN;
-	if (status & PARPORT_CONTROL_INIT) 
-		value_or |= P_OR_INIT;
-	if (status & PARPORT_CONTROL_SELECT) 
-		value_or |= P_OR_SLCT_IN;
-
-	sbus_writeb(value_or, &regs->p_or);
-	sbus_writeb(value_tcr, &regs->p_tcr);
-}
-#endif
-
 static unsigned char status_sunbpp_to_pc(struct parport *p)
 {
 	struct bpp_regs __iomem *regs = (struct bpp_regs __iomem *)p->base;
-- 
1.7.5.4

