Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366Ab3ACOxb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 09:53:31 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:60981 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035Ab3ACOxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 09:53:17 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, jirislaby@gmail.com, linux-kernel@vger.kernel.org
Subject: [PATCH 04/10] TTY: switch tty_insert_flip_string
Date: Thu,  3 Jan 2013 15:53:04 +0100
Message-Id: <1357224789-2853-5-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1357224789-2853-1-git-send-email-jslaby@suse.cz>
References: <1357224789-2853-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, we start converting tty buffer functions to actually use
tty_port. This will allow us to get rid of the need of tty in many
call sites. Only tty_port will needed and hence no more
tty_port_tty_get in those paths.

tty_insert_flip_string this time.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/isdn/gigaset/interface.c      |  2 +-
 drivers/isdn/i4l/isdn_common.c        |  5 ++---
 drivers/isdn/i4l/isdn_common.h        |  2 +-
 drivers/isdn/i4l/isdn_tty.c           |  6 +++---
 drivers/net/usb/hso.c                 |  7 +++----
 drivers/s390/char/con3215.c           |  3 ++-
 drivers/s390/char/sclp_tty.c          |  4 ++--
 drivers/s390/char/sclp_vt220.c        |  2 +-
 drivers/staging/ccg/u_serial.c        |  2 +-
 drivers/tty/bfin_jtag_comm.c          |  2 +-
 drivers/tty/ehv_bytechan.c            |  2 +-
 drivers/tty/hvc/hvcs.c                |  2 +-
 drivers/tty/ipwireless/tty.c          |  2 +-
 drivers/tty/n_gsm.c                   |  2 +-
 drivers/tty/nozomi.c                  | 14 +++++---------
 drivers/tty/pty.c                     |  2 +-
 drivers/tty/serial/amba-pl011.c       |  6 +++---
 drivers/tty/serial/atmel_serial.c     |  6 ++++--
 drivers/tty/serial/crisv10.c          |  2 +-
 drivers/tty/serial/icom.c             |  2 +-
 drivers/tty/serial/ifx6x60.c          |  2 +-
 drivers/tty/serial/ioc3_serial.c      |  3 ++-
 drivers/tty/serial/ioc4_serial.c      |  2 +-
 drivers/tty/serial/jsm/jsm_tty.c      |  2 +-
 drivers/tty/serial/mfd.c              |  5 +++--
 drivers/tty/serial/mrst_max3110.c     |  2 +-
 drivers/tty/serial/msm_serial.c       |  2 +-
 drivers/tty/serial/msm_serial_hs.c    |  2 +-
 drivers/tty/serial/mxs-auart.c        |  5 +++--
 drivers/tty/serial/pch_uart.c         | 10 +++++-----
 drivers/tty/serial/sunhv.c            | 13 +++++++------
 drivers/usb/class/cdc-acm.c           |  3 ++-
 drivers/usb/gadget/u_serial.c         | 11 ++++-------
 drivers/usb/serial/aircable.c         |  9 ++++-----
 drivers/usb/serial/cyberjack.c        |  2 +-
 drivers/usb/serial/garmin_gps.c       |  2 +-
 drivers/usb/serial/generic.c          |  2 +-
 drivers/usb/serial/io_edgeport.c      | 12 ++++++------
 drivers/usb/serial/io_ti.c            | 13 +++++++------
 drivers/usb/serial/ir-usb.c           |  2 +-
 drivers/usb/serial/iuu_phoenix.c      |  2 +-
 drivers/usb/serial/keyspan.c          |  8 +++++---
 drivers/usb/serial/keyspan_pda.c      |  2 +-
 drivers/usb/serial/kl5kusb105.c       |  2 +-
 drivers/usb/serial/kobil_sct.c        |  2 +-
 drivers/usb/serial/mct_u232.c         |  2 +-
 drivers/usb/serial/metro-usb.c        |  2 +-
 drivers/usb/serial/mos7720.c          |  2 +-
 drivers/usb/serial/mos7840.c          |  5 +++--
 drivers/usb/serial/navman.c           |  2 +-
 drivers/usb/serial/omninet.c          |  5 +++--
 drivers/usb/serial/opticon.c          |  2 +-
 drivers/usb/serial/oti6858.c          |  2 +-
 drivers/usb/serial/quatech2.c         |  8 +++-----
 drivers/usb/serial/safe_serial.c      |  2 +-
 drivers/usb/serial/sierra.c           |  2 +-
 drivers/usb/serial/symbolserial.c     |  3 ++-
 drivers/usb/serial/ti_usb_3410_5052.c | 11 +++++------
 drivers/usb/serial/usb_wwan.c         |  2 +-
 include/linux/tty_flip.h              |  5 +++--
 net/bluetooth/rfcomm/tty.c            |  5 +++--
 net/irda/ircomm/ircomm_tty.c          |  2 +-
 62 files changed, 130 insertions(+), 127 deletions(-)

diff --git a/drivers/isdn/gigaset/interface.c b/drivers/isdn/gigaset/interface.c
index 67abf3f..dd2a57e 100644
--- a/drivers/isdn/gigaset/interface.c
+++ b/drivers/isdn/gigaset/interface.c
@@ -569,7 +569,7 @@ void gigaset_if_receive(struct cardstate *cs,
 		return;
 	}
 
-	tty_insert_flip_string(tty, buffer, len);
+	tty_insert_flip_string(&cs->port, buffer, len);
 	tty_flip_buffer_push(tty);
 	tty_kref_put(tty);
 }
diff --git a/drivers/isdn/i4l/isdn_common.c b/drivers/isdn/i4l/isdn_common.c
index 4a387ec..b87d9e5 100644
--- a/drivers/isdn/i4l/isdn_common.c
+++ b/drivers/isdn/i4l/isdn_common.c
@@ -876,9 +876,8 @@ isdn_readbchan(int di, int channel, u_char *buf, u_char *fp, int len, wait_queue
  * of the mapping (di,ch)<->minor, happen during the sleep? --he
  */
 int
-isdn_readbchan_tty(int di, int channel, struct tty_struct *tty, int cisco_hack)
+isdn_readbchan_tty(int di, int channel, struct tty_port *port, int cisco_hack)
 {
-	struct tty_port *port = tty->port;
 	int count;
 	int count_pull;
 	int count_put;
@@ -941,7 +940,7 @@ isdn_readbchan_tty(int di, int channel, struct tty_struct *tty, int cisco_hack)
 			}
 			count_put = count_pull;
 			if (count_put > 1)
-				tty_insert_flip_string(tty, skb->data, count_put - 1);
+				tty_insert_flip_string(port, skb->data, count_put - 1);
 			last = skb->data[count_put - 1];
 			len -= count_put;
 #ifdef CONFIG_ISDN_AUDIO
diff --git a/drivers/isdn/i4l/isdn_common.h b/drivers/isdn/i4l/isdn_common.h
index 9a471f6..2260ef0 100644
--- a/drivers/isdn/i4l/isdn_common.h
+++ b/drivers/isdn/i4l/isdn_common.h
@@ -37,7 +37,7 @@ extern void isdn_timer_ctrl(int tf, int onoff);
 extern void isdn_unexclusive_channel(int di, int ch);
 extern int isdn_getnum(char **);
 extern int isdn_readbchan(int, int, u_char *, u_char *, int, wait_queue_head_t *);
-extern int isdn_readbchan_tty(int, int, struct tty_struct *, int);
+extern int isdn_readbchan_tty(int, int, struct tty_port *, int);
 extern int isdn_get_free_channel(int, int, int, int, int, char *);
 extern int isdn_writebuf_skb_stub(int, int, int, struct sk_buff *);
 extern int register_isdn(isdn_if *i);
diff --git a/drivers/isdn/i4l/isdn_tty.c b/drivers/isdn/i4l/isdn_tty.c
index 32d65d4..9bb9986 100644
--- a/drivers/isdn/i4l/isdn_tty.c
+++ b/drivers/isdn/i4l/isdn_tty.c
@@ -101,7 +101,7 @@ isdn_tty_try_read(modem_info *info, struct sk_buff *skb)
 	} else {
 #endif
 		if (len > 1)
-			tty_insert_flip_string(tty, skb->data, len - 1);
+			tty_insert_flip_string(port, skb->data, len - 1);
 		last = skb->data[len - 1];
 #ifdef CONFIG_ISDN_AUDIO
 	}
@@ -150,9 +150,9 @@ isdn_tty_readmodem(void)
 			if (info->mcr & UART_MCR_RTS) {
 				/* CISCO AsyncPPP Hack */
 				if (!(info->emu.mdmreg[REG_CPPP] & BIT_CPPP))
-					r = isdn_readbchan_tty(info->isdn_driver, info->isdn_channel, tty, 0);
+					r = isdn_readbchan_tty(info->isdn_driver, info->isdn_channel, &info->port, 0);
 				else
-					r = isdn_readbchan_tty(info->isdn_driver, info->isdn_channel, tty, 1);
+					r = isdn_readbchan_tty(info->isdn_driver, info->isdn_channel, &info->port, 1);
 				if (r)
 					tty_flip_buffer_push(tty);
 			} else
diff --git a/drivers/net/usb/hso.c b/drivers/net/usb/hso.c
index cd8ccb2..d235ca0 100644
--- a/drivers/net/usb/hso.c
+++ b/drivers/net/usb/hso.c
@@ -2044,10 +2044,9 @@ static int put_rxbuf_data(struct urb *urb, struct hso_serial *serial)
 				tty_kref_put(tty);
 				return -1;
 			}
-			curr_write_len =  tty_insert_flip_string
-				(tty, urb->transfer_buffer +
-				 serial->curr_rx_urb_offset,
-				 write_length_remaining);
+			curr_write_len = tty_insert_flip_string(&serial->port,
+				urb->transfer_buffer + serial->curr_rx_urb_offset,
+				write_length_remaining);
 			serial->curr_rx_urb_offset += curr_write_len;
 			write_length_remaining -= curr_write_len;
 			tty_flip_buffer_push(tty);
diff --git a/drivers/s390/char/con3215.c b/drivers/s390/char/con3215.c
index 7c72945..4c6743d 100644
--- a/drivers/s390/char/con3215.c
+++ b/drivers/s390/char/con3215.c
@@ -425,7 +425,8 @@ static void raw3215_irq(struct ccw_device *cdev, unsigned long intparm,
 					count++;
 				} else
 					count -= 2;
-				tty_insert_flip_string(tty, raw->inbuf, count);
+				tty_insert_flip_string(&raw->port, raw->inbuf,
+						count);
 				tty_flip_buffer_push(tty);
 				break;
 			}
diff --git a/drivers/s390/char/sclp_tty.c b/drivers/s390/char/sclp_tty.c
index c03863a..3ffddbb 100644
--- a/drivers/s390/char/sclp_tty.c
+++ b/drivers/s390/char/sclp_tty.c
@@ -351,10 +351,10 @@ sclp_tty_input(unsigned char* buf, unsigned int count)
 		    (strncmp((const char *) buf + count - 2, "^n", 2) &&
 		     strncmp((const char *) buf + count - 2, "\252n", 2))) {
 			/* add the auto \n */
-			tty_insert_flip_string(tty, buf, count);
+			tty_insert_flip_string(&sclp_port, buf, count);
 			tty_insert_flip_char(&sclp_port, '\n', TTY_NORMAL);
 		} else
-			tty_insert_flip_string(tty, buf, count - 2);
+			tty_insert_flip_string(&sclp_port, buf, count - 2);
 		tty_flip_buffer_push(tty);
 		break;
 	}
diff --git a/drivers/s390/char/sclp_vt220.c b/drivers/s390/char/sclp_vt220.c
index effcc87..b5507f1 100644
--- a/drivers/s390/char/sclp_vt220.c
+++ b/drivers/s390/char/sclp_vt220.c
@@ -480,7 +480,7 @@ sclp_vt220_receiver_fn(struct evbuf_header *evbuf)
 		/* Send input to line discipline */
 		buffer++;
 		count--;
-		tty_insert_flip_string(tty, buffer, count);
+		tty_insert_flip_string(&sclp_vt220_port, buffer, count);
 		tty_flip_buffer_push(tty);
 		break;
 	}
diff --git a/drivers/staging/ccg/u_serial.c b/drivers/staging/ccg/u_serial.c
index 373c406..7df2c02 100644
--- a/drivers/staging/ccg/u_serial.c
+++ b/drivers/staging/ccg/u_serial.c
@@ -529,7 +529,7 @@ static void gs_rx_push(unsigned long _port)
 				size -= n;
 			}
 
-			count = tty_insert_flip_string(tty, packet, size);
+			count = tty_insert_flip_string(&port->port, packet, size);
 			if (count)
 				do_push = true;
 			if (count != size) {
diff --git a/drivers/tty/bfin_jtag_comm.c b/drivers/tty/bfin_jtag_comm.c
index 1cfcdbf..143c385 100644
--- a/drivers/tty/bfin_jtag_comm.c
+++ b/drivers/tty/bfin_jtag_comm.c
@@ -104,7 +104,7 @@ bfin_jc_emudat_manager(void *arg)
 					size_t num_chars = (4 <= inbound_len ? 4 : inbound_len);
 					pr_debug("  incoming data: 0x%08x (pushing %zu)\n", emudat, num_chars);
 					inbound_len -= num_chars;
-					tty_insert_flip_string(tty, (unsigned char *)&emudat, num_chars);
+					tty_insert_flip_string(&port, (unsigned char *)&emudat, num_chars);
 					tty_flip_buffer_push(tty);
 				}
 			}
diff --git a/drivers/tty/ehv_bytechan.c b/drivers/tty/ehv_bytechan.c
index af97e39..5164f9a 100644
--- a/drivers/tty/ehv_bytechan.c
+++ b/drivers/tty/ehv_bytechan.c
@@ -407,7 +407,7 @@ static irqreturn_t ehv_bc_tty_rx_isr(int irq, void *data)
 		 */
 
 		/* Pass the received data to the tty layer. */
-		ret = tty_insert_flip_string(ttys, buffer, len);
+		ret = tty_insert_flip_string(&bc->port, buffer, len);
 
 		/* 'ret' is the number of bytes that the TTY layer accepted.
 		 * If it's not equal to 'len', then it means the buffer is
diff --git a/drivers/tty/hvc/hvcs.c b/drivers/tty/hvc/hvcs.c
index 4a0ab98..7bfc0a9 100644
--- a/drivers/tty/hvc/hvcs.c
+++ b/drivers/tty/hvc/hvcs.c
@@ -613,7 +613,7 @@ static int hvcs_io(struct hvcs_struct *hvcsd)
 		got = hvc_get_chars(unit_address,
 				&buf[0],
 				HVCS_BUFF_LEN);
-		tty_insert_flip_string(tty, buf, got);
+		tty_insert_flip_string(&hvcsd->port, buf, got);
 	}
 
 	/* Give the TTY time to process the data we just sent. */
diff --git a/drivers/tty/ipwireless/tty.c b/drivers/tty/ipwireless/tty.c
index 2cde13d..a3ad5e1 100644
--- a/drivers/tty/ipwireless/tty.c
+++ b/drivers/tty/ipwireless/tty.c
@@ -176,7 +176,7 @@ void ipwireless_tty_received(struct ipw_tty *tty, unsigned char *data,
 	}
 	mutex_unlock(&tty->ipw_tty_mutex);
 
-	work = tty_insert_flip_string(linux_tty, data, length);
+	work = tty_insert_flip_string(&tty->port, data, length);
 
 	if (work != length)
 		printk(KERN_DEBUG IPWIRELESS_PCCARD_NAME
diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index e1e7459..67f8472 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -1575,7 +1575,7 @@ static void gsm_dlci_data(struct gsm_dlci *dlci, u8 *data, int clen)
 		/* Line state will go via DLCI 0 controls only */
 		case 1:
 		default:
-			tty_insert_flip_string(tty, data, len);
+			tty_insert_flip_string(port, data, len);
 			tty_flip_buffer_push(tty);
 		}
 		tty_kref_put(tty);
diff --git a/drivers/tty/nozomi.c b/drivers/tty/nozomi.c
index 437a6366..941fe80 100644
--- a/drivers/tty/nozomi.c
+++ b/drivers/tty/nozomi.c
@@ -827,15 +827,10 @@ static int receive_data(enum port_type index, struct nozomi *dc)
 	struct tty_struct *tty = tty_port_tty_get(&port->port);
 	int i, ret;
 
-	if (unlikely(!tty)) {
-		DBG1("tty not open for port: %d?", index);
-		return 1;
-	}
-
 	read_mem32((u32 *) &size, addr, 4);
 	/*  DBG1( "%d bytes port: %d", size, index); */
 
-	if (test_bit(TTY_THROTTLED, &tty->flags)) {
+	if (tty && test_bit(TTY_THROTTLED, &tty->flags)) {
 		DBG1("No room in tty, don't read data, don't ack interrupt, "
 			"disable interrupt");
 
@@ -858,10 +853,11 @@ static int receive_data(enum port_type index, struct nozomi *dc)
 			tty_insert_flip_char(&port->port, buf[0], TTY_NORMAL);
 			size = 0;
 		} else if (size < RECEIVE_BUF_MAX) {
-			size -= tty_insert_flip_string(tty, (char *) buf, size);
+			size -= tty_insert_flip_string(&port->port,
+					(char *)buf, size);
 		} else {
-			i = tty_insert_flip_string(tty, \
-						(char *) buf, RECEIVE_BUF_MAX);
+			i = tty_insert_flip_string(&port->port,
+					(char *)buf, RECEIVE_BUF_MAX);
 			size -= i;
 			offset += i;
 		}
diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
index be6a373..3c285d3 100644
--- a/drivers/tty/pty.c
+++ b/drivers/tty/pty.c
@@ -120,7 +120,7 @@ static int pty_write(struct tty_struct *tty, const unsigned char *buf, int c)
 
 	if (c > 0) {
 		/* Stuff the data into the input queue of the other end */
-		c = tty_insert_flip_string(to, buf, c);
+		c = tty_insert_flip_string(to->port, buf, c);
 		/* And shovel */
 		if (c) {
 			tty_flip_buffer_push(to);
diff --git a/drivers/tty/serial/amba-pl011.c b/drivers/tty/serial/amba-pl011.c
index 7fca402..e1257d1 100644
--- a/drivers/tty/serial/amba-pl011.c
+++ b/drivers/tty/serial/amba-pl011.c
@@ -698,7 +698,8 @@ static void pl011_dma_rx_chars(struct uart_amba_port *uap,
 			       u32 pending, bool use_buf_b,
 			       bool readfifo)
 {
-	struct tty_struct *tty = uap->port.state->port.tty;
+	struct tty_port *port = &uap->port.state->port;
+	struct tty_struct *tty = port->tty;
 	struct pl011_sgbuf *sgbuf = use_buf_b ?
 		&uap->dmarx.sgbuf_b : &uap->dmarx.sgbuf_a;
 	struct device *dev = uap->dmarx.chan->device->dev;
@@ -715,8 +716,7 @@ static void pl011_dma_rx_chars(struct uart_amba_port *uap,
 		 * Note that tty_insert_flip_buf() tries to take as many chars
 		 * as it can.
 		 */
-		dma_count = tty_insert_flip_string(uap->port.state->port.tty,
-						   sgbuf->buf, pending);
+		dma_count = tty_insert_flip_string(port, sgbuf->buf, pending);
 
 		/* Return buffer to device */
 		dma_sync_sg_for_device(dev, &sgbuf->sg, 1, DMA_FROM_DEVICE);
diff --git a/drivers/tty/serial/atmel_serial.c b/drivers/tty/serial/atmel_serial.c
index 922e85a..9295670 100644
--- a/drivers/tty/serial/atmel_serial.c
+++ b/drivers/tty/serial/atmel_serial.c
@@ -781,7 +781,8 @@ static void atmel_rx_from_ring(struct uart_port *port)
 static void atmel_rx_from_dma(struct uart_port *port)
 {
 	struct atmel_uart_port *atmel_port = to_atmel_uart_port(port);
-	struct tty_struct *tty = port->state->port.tty;
+	struct tty_port *tport = &port->state->port;
+	struct tty_struct *tty = tport->tty;
 	struct atmel_dma_buffer *pdc;
 	int rx_idx = atmel_port->pdc_rx_idx;
 	unsigned int head;
@@ -820,7 +821,8 @@ static void atmel_rx_from_dma(struct uart_port *port)
 			 */
 			count = head - tail;
 
-			tty_insert_flip_string(tty, pdc->buf + pdc->ofs, count);
+			tty_insert_flip_string(tport, pdc->buf + pdc->ofs,
+						count);
 
 			dma_sync_single_for_device(port->dev, pdc->dma_addr,
 					pdc->dma_size, DMA_FROM_DEVICE);
diff --git a/drivers/tty/serial/crisv10.c b/drivers/tty/serial/crisv10.c
index d123066..c82601d 100644
--- a/drivers/tty/serial/crisv10.c
+++ b/drivers/tty/serial/crisv10.c
@@ -2119,7 +2119,7 @@ static void flush_to_flip_buffer(struct e100_serial *info)
 	while ((buffer = info->first_recv_buffer) != NULL) {
 		unsigned int count = buffer->length;
 
-		tty_insert_flip_string(tty, buffer->buffer, count);
+		tty_insert_flip_string(&info->port, buffer->buffer, count);
 		info->recv_cnt -= count;
 
 		if (count == buffer->length) {
diff --git a/drivers/tty/serial/icom.c b/drivers/tty/serial/icom.c
index 2b0b60f..54903ee 100644
--- a/drivers/tty/serial/icom.c
+++ b/drivers/tty/serial/icom.c
@@ -762,7 +762,7 @@ static void recv_interrupt(u16 port_int_reg, struct icom_port *icom_port)
 		/* Block copy all but the last byte as this may have status */
 		if (count > 0) {
 			first = icom_port->recv_buf[offset];
-			tty_insert_flip_string(tty, icom_port->recv_buf + offset, count - 1);
+			tty_insert_flip_string(port, icom_port->recv_buf + offset, count - 1);
 		}
 
 		icount = &icom_port->uart_port.icount;
diff --git a/drivers/tty/serial/ifx6x60.c b/drivers/tty/serial/ifx6x60.c
index 675d94a..bfb634e 100644
--- a/drivers/tty/serial/ifx6x60.c
+++ b/drivers/tty/serial/ifx6x60.c
@@ -672,7 +672,7 @@ static void ifx_spi_insert_flip_string(struct ifx_spi_device *ifx_dev,
 	struct tty_struct *tty = tty_port_tty_get(&ifx_dev->tty_port);
 	if (!tty)
 		return;
-	tty_insert_flip_string(tty, chars, size);
+	tty_insert_flip_string(&ifx_dev->tty_port, chars, size);
 	tty_flip_buffer_push(tty);
 	tty_kref_put(tty);
 }
diff --git a/drivers/tty/serial/ioc3_serial.c b/drivers/tty/serial/ioc3_serial.c
index d8f1d1d..0f25ce4 100644
--- a/drivers/tty/serial/ioc3_serial.c
+++ b/drivers/tty/serial/ioc3_serial.c
@@ -1415,7 +1415,8 @@ static int receive_chars(struct uart_port *the_port)
 	read_count = do_read(the_port, ch, MAX_CHARS);
 	if (read_count > 0) {
 		flip = 1;
-		read_room = tty_insert_flip_string(tty, ch, read_count);
+		read_room = tty_insert_flip_string(&state->port, ch,
+				read_count);
 		the_port->icount.rx += read_count;
 	}
 	spin_unlock_irqrestore(&the_port->lock, pflags);
diff --git a/drivers/tty/serial/ioc4_serial.c b/drivers/tty/serial/ioc4_serial.c
index 555aeb2..22343da 100644
--- a/drivers/tty/serial/ioc4_serial.c
+++ b/drivers/tty/serial/ioc4_serial.c
@@ -2362,7 +2362,7 @@ static void receive_chars(struct uart_port *the_port)
 		icount = &the_port->icount;
 		read_count = do_read(the_port, ch, request_count);
 		if (read_count > 0) {
-			tty_insert_flip_string(tty, ch, read_count);
+			tty_insert_flip_string(&state->port, ch, read_count);
 			icount->rx += read_count;
 		}
 	}
diff --git a/drivers/tty/serial/jsm/jsm_tty.c b/drivers/tty/serial/jsm/jsm_tty.c
index ac1d36c..c9ce00d 100644
--- a/drivers/tty/serial/jsm/jsm_tty.c
+++ b/drivers/tty/serial/jsm/jsm_tty.c
@@ -640,7 +640,7 @@ void jsm_input(struct jsm_channel *ch)
 					tty_insert_flip_char(port, *(ch->ch_rqueue +tail +i), TTY_NORMAL);
 			}
 		} else {
-			tty_insert_flip_string(tp, ch->ch_rqueue + tail, s) ;
+			tty_insert_flip_string(port, ch->ch_rqueue + tail, s);
 		}
 		tail += s;
 		n -= s;
diff --git a/drivers/tty/serial/mfd.c b/drivers/tty/serial/mfd.c
index 2c01344..60d585a 100644
--- a/drivers/tty/serial/mfd.c
+++ b/drivers/tty/serial/mfd.c
@@ -387,7 +387,8 @@ void hsu_dma_rx(struct uart_hsu_port *up, u32 int_sts)
 	struct hsu_dma_buffer *dbuf = &up->rxbuf;
 	struct hsu_dma_chan *chan = up->rxc;
 	struct uart_port *port = &up->port;
-	struct tty_struct *tty = port->state->port.tty;
+	struct tty_port *tport = &port->state->port;
+	struct tty_struct *tty = tport->tty;
 	int count;
 
 	if (!tty)
@@ -423,7 +424,7 @@ void hsu_dma_rx(struct uart_hsu_port *up, u32 int_sts)
 	 * explicitly set tail to 0. So head will
 	 * always be greater than tail.
 	 */
-	tty_insert_flip_string(tty, dbuf->buf, count);
+	tty_insert_flip_string(tport, dbuf->buf, count);
 	port->icount.rx += count;
 
 	dma_sync_single_for_device(up->port.dev, dbuf->dma_addr,
diff --git a/drivers/tty/serial/mrst_max3110.c b/drivers/tty/serial/mrst_max3110.c
index 776431f..3b8df7b 100644
--- a/drivers/tty/serial/mrst_max3110.c
+++ b/drivers/tty/serial/mrst_max3110.c
@@ -374,7 +374,7 @@ receive_chars(struct uart_max3110 *max, unsigned short *str, int len)
 	for (r = 0; w; r += usable, w -= usable) {
 		usable = tty_buffer_request_room(tport, w);
 		if (usable) {
-			tty_insert_flip_string(tty, buf + r, usable);
+			tty_insert_flip_string(tport, buf + r, usable);
 			port->icount.rx += usable;
 		}
 	}
diff --git a/drivers/tty/serial/msm_serial.c b/drivers/tty/serial/msm_serial.c
index e4eb81a..cb787c0 100644
--- a/drivers/tty/serial/msm_serial.c
+++ b/drivers/tty/serial/msm_serial.c
@@ -133,7 +133,7 @@ static void handle_rx_dm(struct uart_port *port, unsigned int misr)
 			port->icount.frame++;
 
 		/* TODO: handle sysrq */
-		tty_insert_flip_string(tty, (char *) &c,
+		tty_insert_flip_string(tport, (char *)&c,
 				       (count > 4) ? 4 : count);
 		count -= 4;
 	}
diff --git a/drivers/tty/serial/msm_serial_hs.c b/drivers/tty/serial/msm_serial_hs.c
index 6aa9d47..11b7f5b 100644
--- a/drivers/tty/serial/msm_serial_hs.c
+++ b/drivers/tty/serial/msm_serial_hs.c
@@ -961,7 +961,7 @@ static void msm_hs_dmov_rx_callback(struct msm_dmov_cmd *cmd_ptr,
 	rx_count = msm_hs_read(uport, UARTDM_RX_TOTAL_SNAP_ADDR);
 
 	if (0 != (uport->read_status_mask & CREAD)) {
-		retval = tty_insert_flip_string(tty, msm_uport->rx.buffer,
+		retval = tty_insert_flip_string(port, msm_uport->rx.buffer,
 						rx_count);
 		BUG_ON(retval != rx_count);
 	}
diff --git a/drivers/tty/serial/mxs-auart.c b/drivers/tty/serial/mxs-auart.c
index 6db23b0..f8426bf 100644
--- a/drivers/tty/serial/mxs-auart.c
+++ b/drivers/tty/serial/mxs-auart.c
@@ -457,7 +457,8 @@ static int mxs_auart_dma_prep_rx(struct mxs_auart_port *s);
 static void dma_rx_callback(void *arg)
 {
 	struct mxs_auart_port *s = (struct mxs_auart_port *) arg;
-	struct tty_struct *tty = s->port.state->port.tty;
+	struct tty_port *port = &s->port.state->port;
+	struct tty_struct *tty = port->tty;
 	int count;
 	u32 stat;
 
@@ -468,7 +469,7 @@ static void dma_rx_callback(void *arg)
 			AUART_STAT_PERR | AUART_STAT_FERR);
 
 	count = stat & AUART_STAT_RXCOUNT_MASK;
-	tty_insert_flip_string(tty, s->rx_dma_buf, count);
+	tty_insert_flip_string(port, s->rx_dma_buf, count);
 
 	writel(stat, s->port.membase + AUART_STAT);
 	tty_flip_buffer_push(tty);
diff --git a/drivers/tty/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
index 4f1774b..967f1cb 100644
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -591,17 +591,17 @@ static void pch_uart_hal_set_break(struct eg20t_port *priv, int on)
 static int push_rx(struct eg20t_port *priv, const unsigned char *buf,
 		   int size)
 {
-	struct uart_port *port;
+	struct uart_port *port = &priv->port;
+	struct tty_port *tport = &port->state->port;
 	struct tty_struct *tty;
 
-	port = &priv->port;
-	tty = tty_port_tty_get(&port->state->port);
+	tty = tty_port_tty_get(tport);
 	if (!tty) {
 		dev_dbg(priv->port.dev, "%s:tty is busy now", __func__);
 		return -EBUSY;
 	}
 
-	tty_insert_flip_string(tty, buf, size);
+	tty_insert_flip_string(tport, buf, size);
 	tty_flip_buffer_push(tty);
 	tty_kref_put(tty);
 
@@ -646,7 +646,7 @@ static int dma_push_rx(struct eg20t_port *priv, int size)
 	if (!room)
 		return room;
 
-	tty_insert_flip_string(tty, sg_virt(&priv->sg_rx), size);
+	tty_insert_flip_string(tport, sg_virt(&priv->sg_rx), size);
 
 	port->icount.rx += room;
 	tty_kref_put(tty);
diff --git a/drivers/tty/serial/sunhv.c b/drivers/tty/serial/sunhv.c
index bbb102e..defe92b 100644
--- a/drivers/tty/serial/sunhv.c
+++ b/drivers/tty/serial/sunhv.c
@@ -72,7 +72,7 @@ static void transmit_chars_write(struct uart_port *port, struct circ_buf *xmit)
 	}
 }
 
-static int receive_chars_getchar(struct uart_port *port, struct tty_struct *tty)
+static int receive_chars_getchar(struct uart_port *port)
 {
 	int saw_console_brk = 0;
 	int limit = 10000;
@@ -115,7 +115,7 @@ static int receive_chars_getchar(struct uart_port *port, struct tty_struct *tty)
 	return saw_console_brk;
 }
 
-static int receive_chars_read(struct uart_port *port, struct tty_struct *tty)
+static int receive_chars_read(struct uart_port *port)
 {
 	int saw_console_brk = 0;
 	int limit = 10000;
@@ -152,12 +152,13 @@ static int receive_chars_read(struct uart_port *port, struct tty_struct *tty)
 		for (i = 0; i < bytes_read; i++)
 			uart_handle_sysrq_char(port, con_read_page[i]);
 
-		if (tty == NULL)
+		if (port->state == NULL)
 			continue;
 
 		port->icount.rx += bytes_read;
 
-		tty_insert_flip_string(tty, con_read_page, bytes_read);
+		tty_insert_flip_string(&port->state->port, con_read_page,
+				bytes_read);
 	}
 
 	return saw_console_brk;
@@ -165,7 +166,7 @@ static int receive_chars_read(struct uart_port *port, struct tty_struct *tty)
 
 struct sunhv_ops {
 	void (*transmit_chars)(struct uart_port *port, struct circ_buf *xmit);
-	int (*receive_chars)(struct uart_port *port, struct tty_struct *tty);
+	int (*receive_chars)(struct uart_port *port);
 };
 
 static struct sunhv_ops bychar_ops = {
@@ -187,7 +188,7 @@ static struct tty_struct *receive_chars(struct uart_port *port)
 	if (port->state != NULL)		/* Unopened serial console */
 		tty = port->state->port.tty;
 
-	if (sunhv_ops->receive_chars(port, tty))
+	if (sunhv_ops->receive_chars(port))
 		sun_do_break();
 
 	return tty;
diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index 8d809a8..20dc2ad 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -419,7 +419,8 @@ static void acm_process_read_urb(struct acm *acm, struct urb *urb)
 	if (!tty)
 		return;
 
-	tty_insert_flip_string(tty, urb->transfer_buffer, urb->actual_length);
+	tty_insert_flip_string(&acm->port, urb->transfer_buffer,
+			urb->actual_length);
 	tty_flip_buffer_push(tty);
 
 	tty_kref_put(tty);
diff --git a/drivers/usb/gadget/u_serial.c b/drivers/usb/gadget/u_serial.c
index d0f9548..3560799 100644
--- a/drivers/usb/gadget/u_serial.c
+++ b/drivers/usb/gadget/u_serial.c
@@ -495,12 +495,8 @@ static void gs_rx_push(unsigned long _port)
 
 		req = list_first_entry(queue, struct usb_request, list);
 
-		/* discard data if tty was closed */
-		if (!tty)
-			goto recycle;
-
 		/* leave data queued if tty was rx throttled */
-		if (test_bit(TTY_THROTTLED, &tty->flags))
+		if (tty && test_bit(TTY_THROTTLED, &tty->flags))
 			break;
 
 		switch (req->status) {
@@ -533,7 +529,8 @@ static void gs_rx_push(unsigned long _port)
 				size -= n;
 			}
 
-			count = tty_insert_flip_string(tty, packet, size);
+			count = tty_insert_flip_string(&port->port, packet,
+					size);
 			if (count)
 				do_push = true;
 			if (count != size) {
@@ -546,7 +543,7 @@ static void gs_rx_push(unsigned long _port)
 			}
 			port->n_read = 0;
 		}
-recycle:
+
 		list_move(&req->list, &port->read_pool);
 		port->read_started--;
 	}
diff --git a/drivers/usb/serial/aircable.c b/drivers/usb/serial/aircable.c
index 6d110a3..3bb1f8f 100644
--- a/drivers/usb/serial/aircable.c
+++ b/drivers/usb/serial/aircable.c
@@ -119,9 +119,8 @@ static int aircable_probe(struct usb_serial *serial,
 	return 0;
 }
 
-static int aircable_process_packet(struct tty_struct *tty,
-			struct usb_serial_port *port, int has_headers,
-			char *packet, int len)
+static int aircable_process_packet(struct usb_serial_port *port,
+		int has_headers, char *packet, int len)
 {
 	if (has_headers) {
 		len -= HCI_HEADER_LENGTH;
@@ -132,7 +131,7 @@ static int aircable_process_packet(struct tty_struct *tty,
 		return 0;
 	}
 
-	tty_insert_flip_string(tty, packet, len);
+	tty_insert_flip_string(&port->port, packet, len);
 
 	return len;
 }
@@ -156,7 +155,7 @@ static void aircable_process_read_urb(struct urb *urb)
 	count = 0;
 	for (i = 0; i < urb->actual_length; i += HCI_COMPLETE_FRAME) {
 		len = min_t(int, urb->actual_length - i, HCI_COMPLETE_FRAME);
-		count += aircable_process_packet(tty, port, has_headers,
+		count += aircable_process_packet(port, has_headers,
 								&data[i], len);
 	}
 
diff --git a/drivers/usb/serial/cyberjack.c b/drivers/usb/serial/cyberjack.c
index 69a4fa1..e6976a9 100644
--- a/drivers/usb/serial/cyberjack.c
+++ b/drivers/usb/serial/cyberjack.c
@@ -343,7 +343,7 @@ static void cyberjack_read_bulk_callback(struct urb *urb)
 		return;
 	}
 	if (urb->actual_length) {
-		tty_insert_flip_string(tty, data, urb->actual_length);
+		tty_insert_flip_string(&port->port, data, urb->actual_length);
 		tty_flip_buffer_push(tty);
 	}
 	tty_kref_put(tty);
diff --git a/drivers/usb/serial/garmin_gps.c b/drivers/usb/serial/garmin_gps.c
index 203358d..498b5f0 100644
--- a/drivers/usb/serial/garmin_gps.c
+++ b/drivers/usb/serial/garmin_gps.c
@@ -256,7 +256,7 @@ static void send_to_tty(struct usb_serial_port *port,
 
 	if (tty && actual_length) {
 		usb_serial_debug_data(&port->dev, __func__, actual_length, data);
-		tty_insert_flip_string(tty, data, actual_length);
+		tty_insert_flip_string(&port->port, data, actual_length);
 		tty_flip_buffer_push(tty);
 	}
 	tty_kref_put(tty);
diff --git a/drivers/usb/serial/generic.c b/drivers/usb/serial/generic.c
index b00110c..3780f6a 100644
--- a/drivers/usb/serial/generic.c
+++ b/drivers/usb/serial/generic.c
@@ -328,7 +328,7 @@ void usb_serial_generic_process_read_urb(struct urb *urb)
 	   stuff like 3G modems, so shortcircuit it in the 99.9999999% of cases
 	   where the USB serial is not a console anyway */
 	if (!port->port.console || !port->sysrq)
-		tty_insert_flip_string(tty, ch, urb->actual_length);
+		tty_insert_flip_string(&port->port, ch, urb->actual_length);
 	else {
 		for (i = 0; i < urb->actual_length; i++, ch++) {
 			if (!usb_serial_handle_sysrq_char(port, *ch))
diff --git a/drivers/usb/serial/io_edgeport.c b/drivers/usb/serial/io_edgeport.c
index 7b770c7..f96b91d 100644
--- a/drivers/usb/serial/io_edgeport.c
+++ b/drivers/usb/serial/io_edgeport.c
@@ -232,7 +232,7 @@ static void  process_rcvd_data(struct edgeport_serial *edge_serial,
 				unsigned char *buffer, __u16 bufferLength);
 static void process_rcvd_status(struct edgeport_serial *edge_serial,
 				__u8 byte2, __u8 byte3);
-static void edge_tty_recv(struct device *dev, struct tty_struct *tty,
+static void edge_tty_recv(struct usb_serial_port *port, struct tty_struct *tty,
 				unsigned char *data, int length);
 static void handle_new_msr(struct edgeport_port *edge_port, __u8 newMsr);
 static void handle_new_lsr(struct edgeport_port *edge_port, __u8 lsrData,
@@ -1865,7 +1865,7 @@ static void process_rcvd_data(struct edgeport_serial *edge_serial,
 					if (tty) {
 						dev_dbg(dev, "%s - Sending %d bytes to TTY for port %d\n",
 							__func__, rxLen, edge_serial->rxPort);
-						edge_tty_recv(&edge_serial->serial->dev->dev, tty, buffer, rxLen);
+						edge_tty_recv(edge_port->port, tty, buffer, rxLen);
 						tty_kref_put(tty);
 					}
 					edge_port->icount.rx += rxLen;
@@ -2017,14 +2017,14 @@ static void process_rcvd_status(struct edgeport_serial *edge_serial,
  * edge_tty_recv
  *	this function passes data on to the tty flip buffer
  *****************************************************************************/
-static void edge_tty_recv(struct device *dev, struct tty_struct *tty,
+static void edge_tty_recv(struct usb_serial_port *port, struct tty_struct *tty,
 					unsigned char *data, int length)
 {
 	int cnt;
 
-	cnt = tty_insert_flip_string(tty, data, length);
+	cnt = tty_insert_flip_string(&port->port, data, length);
 	if (cnt < length) {
-		dev_err(dev, "%s - dropping data, %d bytes lost\n",
+		dev_err(&port->dev, "%s - dropping data, %d bytes lost\n",
 				__func__, length - cnt);
 	}
 	data += cnt;
@@ -2090,7 +2090,7 @@ static void handle_new_lsr(struct edgeport_port *edge_port, __u8 lsrData,
 		struct tty_struct *tty =
 				tty_port_tty_get(&edge_port->port->port);
 		if (tty) {
-			edge_tty_recv(&edge_port->port->dev, tty, &data, 1);
+			edge_tty_recv(edge_port->port, tty, &data, 1);
 			tty_kref_put(tty);
 		}
 	}
diff --git a/drivers/usb/serial/io_ti.c b/drivers/usb/serial/io_ti.c
index 58184f3..1286a0b 100644
--- a/drivers/usb/serial/io_ti.c
+++ b/drivers/usb/serial/io_ti.c
@@ -201,7 +201,7 @@ static int closing_wait = EDGE_CLOSING_WAIT;
 static bool ignore_cpu_rev;
 static int default_uart_mode;		/* RS232 */
 
-static void edge_tty_recv(struct device *dev, struct tty_struct *tty,
+static void edge_tty_recv(struct usb_serial_port *port, struct tty_struct *tty,
 			  unsigned char *data, int length);
 
 static void stop_read(struct edgeport_port *edge_port);
@@ -1557,7 +1557,7 @@ static void handle_new_lsr(struct edgeport_port *edge_port, int lsr_data,
 	if (lsr_data) {
 		tty = tty_port_tty_get(&edge_port->port->port);
 		if (tty) {
-			edge_tty_recv(&edge_port->port->dev, tty, &data, 1);
+			edge_tty_recv(edge_port->port, tty, &data, 1);
 			tty_kref_put(tty);
 		}
 	}
@@ -1722,7 +1722,8 @@ static void edge_bulk_in_callback(struct urb *urb)
 			dev_dbg(dev, "%s - close pending, dropping data on the floor\n",
 								__func__);
 		else
-			edge_tty_recv(dev, tty, data, urb->actual_length);
+			edge_tty_recv(edge_port->port, tty, data,
+					urb->actual_length);
 		edge_port->icount.rx += urb->actual_length;
 	}
 	tty_kref_put(tty);
@@ -1740,14 +1741,14 @@ exit:
 		dev_err(dev, "%s - usb_submit_urb failed with result %d\n", __func__, retval);
 }
 
-static void edge_tty_recv(struct device *dev, struct tty_struct *tty,
+static void edge_tty_recv(struct usb_serial_port *port, struct tty_struct *tty,
 					unsigned char *data, int length)
 {
 	int queued;
 
-	queued = tty_insert_flip_string(tty, data, length);
+	queued = tty_insert_flip_string(&port->port, data, length);
 	if (queued < length)
-		dev_err(dev, "%s - dropping data, %d bytes lost\n",
+		dev_err(&port->dev, "%s - dropping data, %d bytes lost\n",
 			__func__, length - queued);
 	tty_flip_buffer_push(tty);
 }
diff --git a/drivers/usb/serial/ir-usb.c b/drivers/usb/serial/ir-usb.c
index e24e2d4..171dae1 100644
--- a/drivers/usb/serial/ir-usb.c
+++ b/drivers/usb/serial/ir-usb.c
@@ -305,7 +305,7 @@ static void ir_process_read_urb(struct urb *urb)
 	tty = tty_port_tty_get(&port->port);
 	if (!tty)
 		return;
-	tty_insert_flip_string(tty, data + 1, urb->actual_length - 1);
+	tty_insert_flip_string(&port->port, data + 1, urb->actual_length - 1);
 	tty_flip_buffer_push(tty);
 	tty_kref_put(tty);
 }
diff --git a/drivers/usb/serial/iuu_phoenix.c b/drivers/usb/serial/iuu_phoenix.c
index 1e1fbed..dd0d910 100644
--- a/drivers/usb/serial/iuu_phoenix.c
+++ b/drivers/usb/serial/iuu_phoenix.c
@@ -596,7 +596,7 @@ static void read_buf_callback(struct urb *urb)
 	if (data == NULL)
 		dev_dbg(&port->dev, "%s - data is NULL !!!\n", __func__);
 	if (tty && urb->actual_length && data) {
-		tty_insert_flip_string(tty, data, urb->actual_length);
+		tty_insert_flip_string(&port->port, data, urb->actual_length);
 		tty_flip_buffer_push(tty);
 	}
 	tty_kref_put(tty);
diff --git a/drivers/usb/serial/keyspan.c b/drivers/usb/serial/keyspan.c
index a4f5cae..14a219b 100644
--- a/drivers/usb/serial/keyspan.c
+++ b/drivers/usb/serial/keyspan.c
@@ -472,7 +472,8 @@ static void usa28_indat_callback(struct urb *urb)
 
 		tty = tty_port_tty_get(&port->port);
 		if (tty && urb->actual_length) {
-			tty_insert_flip_string(tty, data, urb->actual_length);
+			tty_insert_flip_string(&port->port, data,
+					urb->actual_length);
 			tty_flip_buffer_push(tty);
 		}
 		tty_kref_put(tty);
@@ -688,7 +689,7 @@ static void	usa49_indat_callback(struct urb *urb)
 		/* 0x80 bit is error flag */
 		if ((data[0] & 0x80) == 0) {
 			/* no error on any byte */
-			tty_insert_flip_string(tty, data + 1,
+			tty_insert_flip_string(&port->port, data + 1,
 						urb->actual_length - 1);
 		} else {
 			/* some bytes had errors, every byte has status */
@@ -816,7 +817,8 @@ static void usa90_indat_callback(struct urb *urb)
 		   otherwise looks like usa26 data format */
 
 		if (p_priv->baud > 57600)
-			tty_insert_flip_string(tty, data, urb->actual_length);
+			tty_insert_flip_string(&port->port, data,
+					urb->actual_length);
 		else {
 			/* 0x80 bit is error flag */
 			if ((data[0] & 0x80) == 0) {
diff --git a/drivers/usb/serial/keyspan_pda.c b/drivers/usb/serial/keyspan_pda.c
index 41b0109..334b1a2 100644
--- a/drivers/usb/serial/keyspan_pda.c
+++ b/drivers/usb/serial/keyspan_pda.c
@@ -166,7 +166,7 @@ static void keyspan_pda_rx_interrupt(struct urb *urb)
 		tty = tty_port_tty_get(&port->port);
 		 /* rest of message is rx data */
 		if (tty && urb->actual_length) {
-			tty_insert_flip_string(tty, data + 1,
+			tty_insert_flip_string(&port->port, data + 1,
 						urb->actual_length - 1);
 			tty_flip_buffer_push(tty);
 		}
diff --git a/drivers/usb/serial/kl5kusb105.c b/drivers/usb/serial/kl5kusb105.c
index fc9e14a..8ee0825 100644
--- a/drivers/usb/serial/kl5kusb105.c
+++ b/drivers/usb/serial/kl5kusb105.c
@@ -411,7 +411,7 @@ static void klsi_105_process_read_urb(struct urb *urb)
 		len = urb->actual_length - KLSI_HDR_LEN;
 	}
 
-	tty_insert_flip_string(tty, data + KLSI_HDR_LEN, len);
+	tty_insert_flip_string(&port->port, data + KLSI_HDR_LEN, len);
 	tty_flip_buffer_push(tty);
 	tty_kref_put(tty);
 }
diff --git a/drivers/usb/serial/kobil_sct.c b/drivers/usb/serial/kobil_sct.c
index b747ba6..135c8b4 100644
--- a/drivers/usb/serial/kobil_sct.c
+++ b/drivers/usb/serial/kobil_sct.c
@@ -353,7 +353,7 @@ static void kobil_read_int_callback(struct urb *urb)
 		*/
 		/* END DEBUG */
 
-		tty_insert_flip_string(tty, data, urb->actual_length);
+		tty_insert_flip_string(&port->port, data, urb->actual_length);
 		tty_flip_buffer_push(tty);
 	}
 	tty_kref_put(tty);
diff --git a/drivers/usb/serial/mct_u232.c b/drivers/usb/serial/mct_u232.c
index b691175..ba20bb0 100644
--- a/drivers/usb/serial/mct_u232.c
+++ b/drivers/usb/serial/mct_u232.c
@@ -563,7 +563,7 @@ static void mct_u232_read_int_callback(struct urb *urb)
 		if (urb->actual_length) {
 			tty = tty_port_tty_get(&port->port);
 			if (tty) {
-				tty_insert_flip_string(tty, data,
+				tty_insert_flip_string(&port->port, data,
 						urb->actual_length);
 				tty_flip_buffer_push(tty);
 			}
diff --git a/drivers/usb/serial/metro-usb.c b/drivers/usb/serial/metro-usb.c
index 3d25844..6264f39 100644
--- a/drivers/usb/serial/metro-usb.c
+++ b/drivers/usb/serial/metro-usb.c
@@ -127,7 +127,7 @@ static void metrousb_read_int_callback(struct urb *urb)
 	tty = tty_port_tty_get(&port->port);
 	if (tty && urb->actual_length) {
 		/* Loop through the data copying each byte to the tty layer. */
-		tty_insert_flip_string(tty, data, urb->actual_length);
+		tty_insert_flip_string(&port->port, data, urb->actual_length);
 
 		/* Force the data to the tty layer. */
 		tty_flip_buffer_push(tty);
diff --git a/drivers/usb/serial/mos7720.c b/drivers/usb/serial/mos7720.c
index f57a6b1..22818fb 100644
--- a/drivers/usb/serial/mos7720.c
+++ b/drivers/usb/serial/mos7720.c
@@ -915,7 +915,7 @@ static void mos7720_bulk_in_callback(struct urb *urb)
 
 	tty = tty_port_tty_get(&port->port);
 	if (tty && urb->actual_length) {
-		tty_insert_flip_string(tty, data, urb->actual_length);
+		tty_insert_flip_string(&port->port, data, urb->actual_length);
 		tty_flip_buffer_push(tty);
 	}
 	tty_kref_put(tty);
diff --git a/drivers/usb/serial/mos7840.c b/drivers/usb/serial/mos7840.c
index 66d9e08..3ddd7a1 100644
--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -773,9 +773,10 @@ static void mos7840_bulk_in_callback(struct urb *urb)
 	usb_serial_debug_data(&port->dev, __func__, urb->actual_length, data);
 
 	if (urb->actual_length) {
-		tty = tty_port_tty_get(&mos7840_port->port->port);
+		struct tty_port *tport = &mos7840_port->port->port;
+		tty = tty_port_tty_get(tport);
 		if (tty) {
-			tty_insert_flip_string(tty, data, urb->actual_length);
+			tty_insert_flip_string(tport, data, urb->actual_length);
 			tty_flip_buffer_push(tty);
 			tty_kref_put(tty);
 		}
diff --git a/drivers/usb/serial/navman.c b/drivers/usb/serial/navman.c
index 1566f8f..0d96a1a 100644
--- a/drivers/usb/serial/navman.c
+++ b/drivers/usb/serial/navman.c
@@ -57,7 +57,7 @@ static void navman_read_int_callback(struct urb *urb)
 
 	tty = tty_port_tty_get(&port->port);
 	if (tty && urb->actual_length) {
-		tty_insert_flip_string(tty, data, urb->actual_length);
+		tty_insert_flip_string(&port->port, data, urb->actual_length);
 		tty_flip_buffer_push(tty);
 	}
 	tty_kref_put(tty);
diff --git a/drivers/usb/serial/omninet.c b/drivers/usb/serial/omninet.c
index 7818af9..338191b 100644
--- a/drivers/usb/serial/omninet.c
+++ b/drivers/usb/serial/omninet.c
@@ -176,8 +176,9 @@ static void omninet_read_bulk_callback(struct urb *urb)
 	if (urb->actual_length && header->oh_len) {
 		struct tty_struct *tty = tty_port_tty_get(&port->port);
 		if (tty) {
-			tty_insert_flip_string(tty, data + OMNINET_DATAOFFSET,
-							header->oh_len);
+			tty_insert_flip_string(&port->port,
+					data + OMNINET_DATAOFFSET,
+					header->oh_len);
 			tty_flip_buffer_push(tty);
 			tty_kref_put(tty);
 		}
diff --git a/drivers/usb/serial/opticon.c b/drivers/usb/serial/opticon.c
index c6bfb83..d3b74e5 100644
--- a/drivers/usb/serial/opticon.c
+++ b/drivers/usb/serial/opticon.c
@@ -57,7 +57,7 @@ static void opticon_process_data_packet(struct usb_serial_port *port,
 	if (!tty)
 		return;
 
-	tty_insert_flip_string(tty, buf, len);
+	tty_insert_flip_string(&port->port, buf, len);
 	tty_flip_buffer_push(tty);
 	tty_kref_put(tty);
 }
diff --git a/drivers/usb/serial/oti6858.c b/drivers/usb/serial/oti6858.c
index d217fd6..7a53fe9 100644
--- a/drivers/usb/serial/oti6858.c
+++ b/drivers/usb/serial/oti6858.c
@@ -837,7 +837,7 @@ static void oti6858_read_bulk_callback(struct urb *urb)
 
 	tty = tty_port_tty_get(&port->port);
 	if (tty != NULL && urb->actual_length > 0) {
-		tty_insert_flip_string(tty, data, urb->actual_length);
+		tty_insert_flip_string(&port->port, data, urb->actual_length);
 		tty_flip_buffer_push(tty);
 	}
 	tty_kref_put(tty);
diff --git a/drivers/usb/serial/quatech2.c b/drivers/usb/serial/quatech2.c
index 1e67fd8..5dccc4f 100644
--- a/drivers/usb/serial/quatech2.c
+++ b/drivers/usb/serial/quatech2.c
@@ -698,7 +698,7 @@ void qt2_process_read_urb(struct urb *urb)
 				break;
 			case QT2_CONTROL_ESCAPE:
 				tty_buffer_request_room(&port->port, 2);
-				tty_insert_flip_string(tty, ch, 2);
+				tty_insert_flip_string(&port->port, ch, 2);
 				i += 2;
 				escapeflag = true;
 				break;
@@ -712,10 +712,8 @@ void qt2_process_read_urb(struct urb *urb)
 				continue;
 		}
 
-		if (tty) {
-			tty_buffer_request_room(&port->port, 1);
-			tty_insert_flip_string(tty, ch, 1);
-		}
+		tty_buffer_request_room(&port->port, 1);
+		tty_insert_flip_string(&port->port, ch, 1);
 	}
 
 	if (tty) {
diff --git a/drivers/usb/serial/safe_serial.c b/drivers/usb/serial/safe_serial.c
index c949ce6..ad12e9e 100644
--- a/drivers/usb/serial/safe_serial.c
+++ b/drivers/usb/serial/safe_serial.c
@@ -235,7 +235,7 @@ static void safe_process_read_urb(struct urb *urb)
 	dev_info(&urb->dev->dev, "%s - actual: %d\n", __func__, actual_length);
 	length = actual_length;
 out:
-	tty_insert_flip_string(tty, data, length);
+	tty_insert_flip_string(&port->port, data, length);
 	tty_flip_buffer_push(tty);
 err:
 	tty_kref_put(tty);
diff --git a/drivers/usb/serial/sierra.c b/drivers/usb/serial/sierra.c
index af06f2f..64e53fd 100644
--- a/drivers/usb/serial/sierra.c
+++ b/drivers/usb/serial/sierra.c
@@ -583,7 +583,7 @@ static void sierra_indat_callback(struct urb *urb)
 		if (urb->actual_length) {
 			tty = tty_port_tty_get(&port->port);
 			if (tty) {
-				tty_insert_flip_string(tty, data,
+				tty_insert_flip_string(&port->port, data,
 					urb->actual_length);
 				tty_flip_buffer_push(tty);
 
diff --git a/drivers/usb/serial/symbolserial.c b/drivers/usb/serial/symbolserial.c
index 701fffa..2ffa6ae 100644
--- a/drivers/usb/serial/symbolserial.c
+++ b/drivers/usb/serial/symbolserial.c
@@ -84,7 +84,8 @@ static void symbol_int_callback(struct urb *urb)
 		 */
 		tty = tty_port_tty_get(&port->port);
 		if (tty) {
-			tty_insert_flip_string(tty, &data[1], data_length);
+			tty_insert_flip_string(&port->port, &data[1],
+					data_length);
 			tty_flip_buffer_push(tty);
 			tty_kref_put(tty);
 		}
diff --git a/drivers/usb/serial/ti_usb_3410_5052.c b/drivers/usb/serial/ti_usb_3410_5052.c
index f2530d2..05077e3 100644
--- a/drivers/usb/serial/ti_usb_3410_5052.c
+++ b/drivers/usb/serial/ti_usb_3410_5052.c
@@ -121,7 +121,7 @@ static void ti_interrupt_callback(struct urb *urb);
 static void ti_bulk_in_callback(struct urb *urb);
 static void ti_bulk_out_callback(struct urb *urb);
 
-static void ti_recv(struct device *dev, struct tty_struct *tty,
+static void ti_recv(struct usb_serial_port *port, struct tty_struct *tty,
 	unsigned char *data, int length);
 static void ti_send(struct ti_port *tport);
 static int ti_set_mcr(struct ti_port *tport, unsigned int mcr);
@@ -1155,8 +1155,7 @@ static void ti_bulk_in_callback(struct urb *urb)
 				dev_dbg(dev, "%s - port closed, dropping data\n",
 					__func__);
 			else
-				ti_recv(&urb->dev->dev, tty,
-						urb->transfer_buffer,
+				ti_recv(port, tty, urb->transfer_buffer,
 						urb->actual_length);
 			spin_lock(&tport->tp_lock);
 			tport->tp_icount.rx += urb->actual_length;
@@ -1210,15 +1209,15 @@ static void ti_bulk_out_callback(struct urb *urb)
 }
 
 
-static void ti_recv(struct device *dev, struct tty_struct *tty,
+static void ti_recv(struct usb_serial_port *port, struct tty_struct *tty,
 	unsigned char *data, int length)
 {
 	int cnt;
 
 	do {
-		cnt = tty_insert_flip_string(tty, data, length);
+		cnt = tty_insert_flip_string(&port->port, data, length);
 		if (cnt < length) {
-			dev_err(dev, "%s - dropping data, %d bytes lost\n",
+			dev_err(&port->dev, "%s - dropping data, %d bytes lost\n",
 						__func__, length - cnt);
 			if (cnt == 0)
 				break;
diff --git a/drivers/usb/serial/usb_wwan.c b/drivers/usb/serial/usb_wwan.c
index 01c94aa..293b460 100644
--- a/drivers/usb/serial/usb_wwan.c
+++ b/drivers/usb/serial/usb_wwan.c
@@ -291,7 +291,7 @@ static void usb_wwan_indat_callback(struct urb *urb)
 		tty = tty_port_tty_get(&port->port);
 		if (tty) {
 			if (urb->actual_length) {
-				tty_insert_flip_string(tty, data,
+				tty_insert_flip_string(&port->port, data,
 						urb->actual_length);
 				tty_flip_buffer_push(tty);
 			} else
diff --git a/include/linux/tty_flip.h b/include/linux/tty_flip.h
index f9acb578..5cb694a 100644
--- a/include/linux/tty_flip.h
+++ b/include/linux/tty_flip.h
@@ -24,9 +24,10 @@ static inline int tty_insert_flip_char(struct tty_port *port,
 	return tty_insert_flip_string_flags(port, &ch, &flag, 1);
 }
 
-static inline int tty_insert_flip_string(struct tty_struct *tty, const unsigned char *chars, size_t size)
+static inline int tty_insert_flip_string(struct tty_port *port,
+		const unsigned char *chars, size_t size)
 {
-	return tty_insert_flip_string_fixed_flag(tty->port, chars, TTY_NORMAL, size);
+	return tty_insert_flip_string_fixed_flag(port, chars, TTY_NORMAL, size);
 }
 
 #endif /* _LINUX_TTY_FLIP_H */
diff --git a/net/bluetooth/rfcomm/tty.c b/net/bluetooth/rfcomm/tty.c
index bd6fd0f..cbec3b6 100644
--- a/net/bluetooth/rfcomm/tty.c
+++ b/net/bluetooth/rfcomm/tty.c
@@ -556,7 +556,7 @@ static void rfcomm_dev_data_ready(struct rfcomm_dlc *dlc, struct sk_buff *skb)
 
 	BT_DBG("dlc %p tty %p len %d", dlc, tty, skb->len);
 
-	tty_insert_flip_string(tty, skb->data, skb->len);
+	tty_insert_flip_string(&dev->port, skb->data, skb->len);
 	tty_flip_buffer_push(tty);
 
 	kfree_skb(skb);
@@ -633,7 +633,8 @@ static void rfcomm_tty_copy_pending(struct rfcomm_dev *dev)
 	rfcomm_dlc_lock(dev->dlc);
 
 	while ((skb = skb_dequeue(&dev->pending))) {
-		inserted += tty_insert_flip_string(tty, skb->data, skb->len);
+		inserted += tty_insert_flip_string(&dev->port, skb->data,
+				skb->len);
 		kfree_skb(skb);
 	}
 
diff --git a/net/irda/ircomm/ircomm_tty.c b/net/irda/ircomm/ircomm_tty.c
index a68c88c..14b08e3 100644
--- a/net/irda/ircomm/ircomm_tty.c
+++ b/net/irda/ircomm/ircomm_tty.c
@@ -1141,7 +1141,7 @@ static int ircomm_tty_data_indication(void *instance, void *sap,
 	 * Use flip buffer functions since the code may be called from interrupt
 	 * context
 	 */
-	tty_insert_flip_string(tty, skb->data, skb->len);
+	tty_insert_flip_string(&self->port, skb->data, skb->len);
 	tty_flip_buffer_push(tty);
 	tty_kref_put(tty);
 
-- 
1.8.1


