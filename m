Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139Ab1BNQzl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 11:55:41 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:59833 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756108Ab1BNQzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 11:55:36 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 1/6] tiocmget: kill off the passing of the struct file
To: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 14 Feb 2011 16:26:14 +0000
Message-ID: <20110214162602.10571.3615.stgit@bob.linux.org.uk>
In-Reply-To: <20110214162438.10571.8203.stgit@bob.linux.org.uk>
References: <20110214162438.10571.8203.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

We don't actually need this and it causes problems for internal use of
this functionality. Currently there is a single use of the FILE * pointer.
That is the serial core which uses it to check tty_hung_up_p. However if
that is true then IO_ERROR is also already set so the check may be removed.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/char/amiserial.c                    |    2 +-
 drivers/char/cyclades.c                     |    2 +-
 drivers/char/epca.c                         |    4 ++--
 drivers/char/ip2/ip2main.c                  |    4 ++--
 drivers/char/isicom.c                       |    2 +-
 drivers/char/istallion.c                    |    2 +-
 drivers/char/moxa.c                         |    4 ++--
 drivers/char/mxser.c                        |    2 +-
 drivers/char/nozomi.c                       |    2 +-
 drivers/char/pcmcia/ipwireless/tty.c        |    2 +-
 drivers/char/pcmcia/synclink_cs.c           |    4 ++--
 drivers/char/riscom8.c                      |    2 +-
 drivers/char/rocket.c                       |    2 +-
 drivers/char/serial167.c                    |    2 +-
 drivers/char/specialix.c                    |    2 +-
 drivers/char/stallion.c                     |    2 +-
 drivers/char/sx.c                           |    2 +-
 drivers/char/synclink.c                     |    4 ++--
 drivers/char/synclink_gt.c                  |    4 ++--
 drivers/char/synclinkmp.c                   |    4 ++--
 drivers/isdn/gigaset/interface.c            |    4 ++--
 drivers/isdn/i4l/isdn_tty.c                 |    2 +-
 drivers/mmc/card/sdio_uart.c                |    2 +-
 drivers/net/usb/hso.c                       |    2 +-
 drivers/net/wan/pc300_tty.c                 |    4 ++--
 drivers/staging/quatech_usb2/quatech_usb2.c |    2 +-
 drivers/staging/serqt_usb2/serqt_usb2.c     |    6 +++---
 drivers/tty/hvc/hvsi.c                      |    2 +-
 drivers/tty/n_gsm.c                         |    2 +-
 drivers/tty/serial/68360serial.c            |    2 +-
 drivers/tty/serial/crisv10.c                |    2 +-
 drivers/tty/serial/ifx6x60.c                |    2 +-
 drivers/tty/serial/serial_core.c            |    6 ++----
 drivers/tty/tty_io.c                        |    6 +++---
 drivers/usb/class/cdc-acm.c                 |    2 +-
 drivers/usb/serial/ark3116.c                |    2 +-
 drivers/usb/serial/belkin_sa.c              |    4 ++--
 drivers/usb/serial/ch341.c                  |    2 +-
 drivers/usb/serial/cp210x.c                 |    4 ++--
 drivers/usb/serial/cypress_m8.c             |    4 ++--
 drivers/usb/serial/digi_acceleport.c        |    4 ++--
 drivers/usb/serial/ftdi_sio.c               |    4 ++--
 drivers/usb/serial/io_edgeport.c            |    4 ++--
 drivers/usb/serial/io_ti.c                  |    2 +-
 drivers/usb/serial/iuu_phoenix.c            |    2 +-
 drivers/usb/serial/keyspan.c                |    2 +-
 drivers/usb/serial/keyspan.h                |    3 +--
 drivers/usb/serial/keyspan_pda.c            |    2 +-
 drivers/usb/serial/kl5kusb105.c             |    4 ++--
 drivers/usb/serial/kobil_sct.c              |    4 ++--
 drivers/usb/serial/mct_u232.c               |    4 ++--
 drivers/usb/serial/mos7720.c                |    4 ++--
 drivers/usb/serial/mos7840.c                |    2 +-
 drivers/usb/serial/opticon.c                |    2 +-
 drivers/usb/serial/oti6858.c                |    4 ++--
 drivers/usb/serial/pl2303.c                 |    2 +-
 drivers/usb/serial/sierra.c                 |    2 +-
 drivers/usb/serial/spcp8x5.c                |    2 +-
 drivers/usb/serial/ssu100.c                 |    2 +-
 drivers/usb/serial/ti_usb_3410_5052.c       |    4 ++--
 drivers/usb/serial/usb-serial.c             |    4 ++--
 drivers/usb/serial/usb-wwan.h               |    2 +-
 drivers/usb/serial/usb_wwan.c               |    2 +-
 drivers/usb/serial/whiteheat.c              |    4 ++--
 include/linux/tty_driver.h                  |    2 +-
 include/linux/usb/serial.h                  |    2 +-
 include/net/irda/ircomm_tty.h               |    2 +-
 net/bluetooth/rfcomm/tty.c                  |    2 +-
 net/irda/ircomm/ircomm_tty_ioctl.c          |    4 ++--
 69 files changed, 98 insertions(+), 101 deletions(-)


diff --git a/drivers/char/amiserial.c b/drivers/char/amiserial.c
index 6ee3348..bc67e68 100644
--- a/drivers/char/amiserial.c
+++ b/drivers/char/amiserial.c
@@ -1194,7 +1194,7 @@ static int get_lsr_info(struct async_struct * info, unsigned int __user *value)
 }
 
 
-static int rs_tiocmget(struct tty_struct *tty, struct file *file)
+static int rs_tiocmget(struct tty_struct *tty)
 {
 	struct async_struct * info = tty->driver_data;
 	unsigned char control, status;
diff --git a/drivers/char/cyclades.c b/drivers/char/cyclades.c
index 4f152c2..e7945dd 100644
--- a/drivers/char/cyclades.c
+++ b/drivers/char/cyclades.c
@@ -2429,7 +2429,7 @@ static int get_lsr_info(struct cyclades_port *info, unsigned int __user *value)
 	return put_user(result, (unsigned long __user *)value);
 }
 
-static int cy_tiocmget(struct tty_struct *tty, struct file *file)
+static int cy_tiocmget(struct tty_struct *tty)
 {
 	struct cyclades_port *info = tty->driver_data;
 	struct cyclades_card *card;
diff --git a/drivers/char/epca.c b/drivers/char/epca.c
index d9df46a..ecf6f0a 100644
--- a/drivers/char/epca.c
+++ b/drivers/char/epca.c
@@ -1982,7 +1982,7 @@ static int info_ioctl(struct tty_struct *tty, struct file *file,
 	return 0;
 }
 
-static int pc_tiocmget(struct tty_struct *tty, struct file *file)
+static int pc_tiocmget(struct tty_struct *tty)
 {
 	struct channel *ch = tty->driver_data;
 	struct board_chan __iomem *bc;
@@ -2074,7 +2074,7 @@ static int pc_ioctl(struct tty_struct *tty, struct file *file,
 		return -EINVAL;
 	switch (cmd) {
 	case TIOCMODG:
-		mflag = pc_tiocmget(tty, file);
+		mflag = pc_tiocmget(tty);
 		if (put_user(mflag, (unsigned long __user *)argp))
 			return -EFAULT;
 		break;
diff --git a/drivers/char/ip2/ip2main.c b/drivers/char/ip2/ip2main.c
index c3a0253..476cd08 100644
--- a/drivers/char/ip2/ip2main.c
+++ b/drivers/char/ip2/ip2main.c
@@ -181,7 +181,7 @@ static void ip2_unthrottle(PTTY);
 static void ip2_stop(PTTY);
 static void ip2_start(PTTY);
 static void ip2_hangup(PTTY);
-static int  ip2_tiocmget(struct tty_struct *tty, struct file *file);
+static int  ip2_tiocmget(struct tty_struct *tty);
 static int  ip2_tiocmset(struct tty_struct *tty, struct file *file,
 			 unsigned int set, unsigned int clear);
 static int ip2_get_icount(struct tty_struct *tty,
@@ -2038,7 +2038,7 @@ ip2_stop ( PTTY tty )
 /* Device Ioctl Section                                                       */
 /******************************************************************************/
 
-static int ip2_tiocmget(struct tty_struct *tty, struct file *file)
+static int ip2_tiocmget(struct tty_struct *tty)
 {
 	i2ChanStrPtr pCh = DevTable[tty->index];
 #ifdef	ENABLE_DSSNOW
diff --git a/drivers/char/isicom.c b/drivers/char/isicom.c
index c27e9d2..836370b 100644
--- a/drivers/char/isicom.c
+++ b/drivers/char/isicom.c
@@ -1065,7 +1065,7 @@ static int isicom_send_break(struct tty_struct *tty, int length)
 	return 0;
 }
 
-static int isicom_tiocmget(struct tty_struct *tty, struct file *file)
+static int isicom_tiocmget(struct tty_struct *tty)
 {
 	struct isi_port *port = tty->driver_data;
 	/* just send the port status */
diff --git a/drivers/char/istallion.c b/drivers/char/istallion.c
index 7c6de4c..7843a84 100644
--- a/drivers/char/istallion.c
+++ b/drivers/char/istallion.c
@@ -1501,7 +1501,7 @@ static int stli_setserial(struct tty_struct *tty, struct serial_struct __user *s
 
 /*****************************************************************************/
 
-static int stli_tiocmget(struct tty_struct *tty, struct file *file)
+static int stli_tiocmget(struct tty_struct *tty)
 {
 	struct stliport *portp = tty->driver_data;
 	struct stlibrd *brdp;
diff --git a/drivers/char/moxa.c b/drivers/char/moxa.c
index 107b0bd..fdf069b 100644
--- a/drivers/char/moxa.c
+++ b/drivers/char/moxa.c
@@ -199,7 +199,7 @@ static void moxa_set_termios(struct tty_struct *, struct ktermios *);
 static void moxa_stop(struct tty_struct *);
 static void moxa_start(struct tty_struct *);
 static void moxa_hangup(struct tty_struct *);
-static int moxa_tiocmget(struct tty_struct *tty, struct file *file);
+static int moxa_tiocmget(struct tty_struct *tty);
 static int moxa_tiocmset(struct tty_struct *tty, struct file *file,
 			 unsigned int set, unsigned int clear);
 static void moxa_poll(unsigned long);
@@ -1257,7 +1257,7 @@ static int moxa_chars_in_buffer(struct tty_struct *tty)
 	return chars;
 }
 
-static int moxa_tiocmget(struct tty_struct *tty, struct file *file)
+static int moxa_tiocmget(struct tty_struct *tty)
 {
 	struct moxa_port *ch = tty->driver_data;
 	int flag = 0, dtr, rts;
diff --git a/drivers/char/mxser.c b/drivers/char/mxser.c
index dd9d753..4d2f03e 100644
--- a/drivers/char/mxser.c
+++ b/drivers/char/mxser.c
@@ -1320,7 +1320,7 @@ static int mxser_get_lsr_info(struct mxser_port *info,
 	return put_user(result, value);
 }
 
-static int mxser_tiocmget(struct tty_struct *tty, struct file *file)
+static int mxser_tiocmget(struct tty_struct *tty)
 {
 	struct mxser_port *info = tty->driver_data;
 	unsigned char control, status;
diff --git a/drivers/char/nozomi.c b/drivers/char/nozomi.c
index 294d03e..0e1dff2 100644
--- a/drivers/char/nozomi.c
+++ b/drivers/char/nozomi.c
@@ -1750,7 +1750,7 @@ static int ntty_write_room(struct tty_struct *tty)
 }
 
 /* Gets io control parameters */
-static int ntty_tiocmget(struct tty_struct *tty, struct file *file)
+static int ntty_tiocmget(struct tty_struct *tty)
 {
 	const struct port *port = tty->driver_data;
 	const struct ctrl_dl *ctrl_dl = &port->ctrl_dl;
diff --git a/drivers/char/pcmcia/ipwireless/tty.c b/drivers/char/pcmcia/ipwireless/tty.c
index f5eb28b..7d2ef49 100644
--- a/drivers/char/pcmcia/ipwireless/tty.c
+++ b/drivers/char/pcmcia/ipwireless/tty.c
@@ -395,7 +395,7 @@ static int set_control_lines(struct ipw_tty *tty, unsigned int set,
 	return 0;
 }
 
-static int ipw_tiocmget(struct tty_struct *linux_tty, struct file *file)
+static int ipw_tiocmget(struct tty_struct *linux_tty)
 {
 	struct ipw_tty *tty = linux_tty->driver_data;
 	/* FIXME: Exactly how is the tty object locked here .. */
diff --git a/drivers/char/pcmcia/synclink_cs.c b/drivers/char/pcmcia/synclink_cs.c
index eaa4199..7b68ba6 100644
--- a/drivers/char/pcmcia/synclink_cs.c
+++ b/drivers/char/pcmcia/synclink_cs.c
@@ -418,7 +418,7 @@ static void bh_status(MGSLPC_INFO *info);
 /*
  * ioctl handlers
  */
-static int tiocmget(struct tty_struct *tty, struct file *file);
+static int tiocmget(struct tty_struct *tty);
 static int tiocmset(struct tty_struct *tty, struct file *file,
 		    unsigned int set, unsigned int clear);
 static int get_stats(MGSLPC_INFO *info, struct mgsl_icount __user *user_icount);
@@ -2114,7 +2114,7 @@ static int modem_input_wait(MGSLPC_INFO *info,int arg)
 
 /* return the state of the serial control and status signals
  */
-static int tiocmget(struct tty_struct *tty, struct file *file)
+static int tiocmget(struct tty_struct *tty)
 {
 	MGSLPC_INFO *info = (MGSLPC_INFO *)tty->driver_data;
 	unsigned int result;
diff --git a/drivers/char/riscom8.c b/drivers/char/riscom8.c
index af4de1f..5d0c984 100644
--- a/drivers/char/riscom8.c
+++ b/drivers/char/riscom8.c
@@ -1086,7 +1086,7 @@ static int rc_chars_in_buffer(struct tty_struct *tty)
 	return port->xmit_cnt;
 }
 
-static int rc_tiocmget(struct tty_struct *tty, struct file *file)
+static int rc_tiocmget(struct tty_struct *tty)
 {
 	struct riscom_port *port = tty->driver_data;
 	struct riscom_board *bp;
diff --git a/drivers/char/rocket.c b/drivers/char/rocket.c
index 3e4e73a..75e98ef 100644
--- a/drivers/char/rocket.c
+++ b/drivers/char/rocket.c
@@ -1169,7 +1169,7 @@ static int sGetChanRI(CHANNEL_T * ChP)
  *  Returns the state of the serial modem control lines.  These next 2 functions 
  *  are the way kernel versions > 2.5 handle modem control lines rather than IOCTLs.
  */
-static int rp_tiocmget(struct tty_struct *tty, struct file *file)
+static int rp_tiocmget(struct tty_struct *tty)
 {
 	struct r_port *info = tty->driver_data;
 	unsigned int control, result, ChanStatus;
diff --git a/drivers/char/serial167.c b/drivers/char/serial167.c
index 748c3b0..fda9064 100644
--- a/drivers/char/serial167.c
+++ b/drivers/char/serial167.c
@@ -1308,7 +1308,7 @@ check_and_exit:
 	return startup(info);
 }				/* set_serial_info */
 
-static int cy_tiocmget(struct tty_struct *tty, struct file *file)
+static int cy_tiocmget(struct tty_struct *tty)
 {
 	struct cyclades_port *info = tty->driver_data;
 	int channel;
diff --git a/drivers/char/specialix.c b/drivers/char/specialix.c
index c2bca3f..bfecfbe 100644
--- a/drivers/char/specialix.c
+++ b/drivers/char/specialix.c
@@ -1737,7 +1737,7 @@ static int sx_chars_in_buffer(struct tty_struct *tty)
 	return port->xmit_cnt;
 }
 
-static int sx_tiocmget(struct tty_struct *tty, struct file *file)
+static int sx_tiocmget(struct tty_struct *tty)
 {
 	struct specialix_port *port = tty->driver_data;
 	struct specialix_board *bp;
diff --git a/drivers/char/stallion.c b/drivers/char/stallion.c
index 461a5a0..8c2bf3f 100644
--- a/drivers/char/stallion.c
+++ b/drivers/char/stallion.c
@@ -1094,7 +1094,7 @@ static int stl_setserial(struct tty_struct *tty, struct serial_struct __user *sp
 
 /*****************************************************************************/
 
-static int stl_tiocmget(struct tty_struct *tty, struct file *file)
+static int stl_tiocmget(struct tty_struct *tty)
 {
 	struct stlport	*portp;
 
diff --git a/drivers/char/sx.c b/drivers/char/sx.c
index a786326..f46214e6 100644
--- a/drivers/char/sx.c
+++ b/drivers/char/sx.c
@@ -1873,7 +1873,7 @@ static int sx_break(struct tty_struct *tty, int flag)
 	return 0;
 }
 
-static int sx_tiocmget(struct tty_struct *tty, struct file *file)
+static int sx_tiocmget(struct tty_struct *tty)
 {
 	struct sx_port *port = tty->driver_data;
 	return sx_getsignals(port);
diff --git a/drivers/char/synclink.c b/drivers/char/synclink.c
index 3a6824f..d359e09 100644
--- a/drivers/char/synclink.c
+++ b/drivers/char/synclink.c
@@ -823,7 +823,7 @@ static isr_dispatch_func UscIsrTable[7] =
 /*
  * ioctl call handlers
  */
-static int tiocmget(struct tty_struct *tty, struct file *file);
+static int tiocmget(struct tty_struct *tty);
 static int tiocmset(struct tty_struct *tty, struct file *file,
 		    unsigned int set, unsigned int clear);
 static int mgsl_get_stats(struct mgsl_struct * info, struct mgsl_icount
@@ -2846,7 +2846,7 @@ static int modem_input_wait(struct mgsl_struct *info,int arg)
 
 /* return the state of the serial control and status signals
  */
-static int tiocmget(struct tty_struct *tty, struct file *file)
+static int tiocmget(struct tty_struct *tty)
 {
 	struct mgsl_struct *info = tty->driver_data;
 	unsigned int result;
diff --git a/drivers/char/synclink_gt.c b/drivers/char/synclink_gt.c
index d01fffe..f18ab8a 100644
--- a/drivers/char/synclink_gt.c
+++ b/drivers/char/synclink_gt.c
@@ -512,7 +512,7 @@ static int  tx_abort(struct slgt_info *info);
 static int  rx_enable(struct slgt_info *info, int enable);
 static int  modem_input_wait(struct slgt_info *info,int arg);
 static int  wait_mgsl_event(struct slgt_info *info, int __user *mask_ptr);
-static int  tiocmget(struct tty_struct *tty, struct file *file);
+static int  tiocmget(struct tty_struct *tty);
 static int  tiocmset(struct tty_struct *tty, struct file *file,
 		     unsigned int set, unsigned int clear);
 static int set_break(struct tty_struct *tty, int break_state);
@@ -3195,7 +3195,7 @@ static int modem_input_wait(struct slgt_info *info,int arg)
 /*
  *  return state of serial control and status signals
  */
-static int tiocmget(struct tty_struct *tty, struct file *file)
+static int tiocmget(struct tty_struct *tty)
 {
 	struct slgt_info *info = tty->driver_data;
 	unsigned int result;
diff --git a/drivers/char/synclinkmp.c b/drivers/char/synclinkmp.c
index 2f9eb4b..5900213 100644
--- a/drivers/char/synclinkmp.c
+++ b/drivers/char/synclinkmp.c
@@ -546,7 +546,7 @@ static int  tx_abort(SLMP_INFO *info);
 static int  rx_enable(SLMP_INFO *info, int enable);
 static int  modem_input_wait(SLMP_INFO *info,int arg);
 static int  wait_mgsl_event(SLMP_INFO *info, int __user *mask_ptr);
-static int  tiocmget(struct tty_struct *tty, struct file *file);
+static int  tiocmget(struct tty_struct *tty);
 static int  tiocmset(struct tty_struct *tty, struct file *file,
 		     unsigned int set, unsigned int clear);
 static int  set_break(struct tty_struct *tty, int break_state);
@@ -3207,7 +3207,7 @@ static int modem_input_wait(SLMP_INFO *info,int arg)
 
 /* return the state of the serial control and status signals
  */
-static int tiocmget(struct tty_struct *tty, struct file *file)
+static int tiocmget(struct tty_struct *tty)
 {
 	SLMP_INFO *info = tty->driver_data;
 	unsigned int result;
diff --git a/drivers/isdn/gigaset/interface.c b/drivers/isdn/gigaset/interface.c
index bb710d16..e1a7c14 100644
--- a/drivers/isdn/gigaset/interface.c
+++ b/drivers/isdn/gigaset/interface.c
@@ -122,7 +122,7 @@ static int  if_chars_in_buffer(struct tty_struct *tty);
 static void if_throttle(struct tty_struct *tty);
 static void if_unthrottle(struct tty_struct *tty);
 static void if_set_termios(struct tty_struct *tty, struct ktermios *old);
-static int  if_tiocmget(struct tty_struct *tty, struct file *file);
+static int  if_tiocmget(struct tty_struct *tty);
 static int  if_tiocmset(struct tty_struct *tty, struct file *file,
 			unsigned int set, unsigned int clear);
 static int  if_write(struct tty_struct *tty,
@@ -280,7 +280,7 @@ static int if_ioctl(struct tty_struct *tty, struct file *file,
 	return retval;
 }
 
-static int if_tiocmget(struct tty_struct *tty, struct file *file)
+static int if_tiocmget(struct tty_struct *tty)
 {
 	struct cardstate *cs;
 	int retval;
diff --git a/drivers/isdn/i4l/isdn_tty.c b/drivers/isdn/i4l/isdn_tty.c
index c463162..ba6c2f1 100644
--- a/drivers/isdn/i4l/isdn_tty.c
+++ b/drivers/isdn/i4l/isdn_tty.c
@@ -1345,7 +1345,7 @@ isdn_tty_get_lsr_info(modem_info * info, uint __user * value)
 
 
 static int
-isdn_tty_tiocmget(struct tty_struct *tty, struct file *file)
+isdn_tty_tiocmget(struct tty_struct *tty)
 {
 	modem_info *info = (modem_info *) tty->driver_data;
 	u_char control, status;
diff --git a/drivers/mmc/card/sdio_uart.c b/drivers/mmc/card/sdio_uart.c
index a071696..86bb04d 100644
--- a/drivers/mmc/card/sdio_uart.c
+++ b/drivers/mmc/card/sdio_uart.c
@@ -956,7 +956,7 @@ static int sdio_uart_break_ctl(struct tty_struct *tty, int break_state)
 	return 0;
 }
 
-static int sdio_uart_tiocmget(struct tty_struct *tty, struct file *file)
+static int sdio_uart_tiocmget(struct tty_struct *tty)
 {
 	struct sdio_uart_port *port = tty->driver_data;
 	int result;
diff --git a/drivers/net/usb/hso.c b/drivers/net/usb/hso.c
index bed8fce..7c68c45 100644
--- a/drivers/net/usb/hso.c
+++ b/drivers/net/usb/hso.c
@@ -1656,7 +1656,7 @@ static int hso_get_count(struct tty_struct *tty,
 }
 
 
-static int hso_serial_tiocmget(struct tty_struct *tty, struct file *file)
+static int hso_serial_tiocmget(struct tty_struct *tty)
 {
 	int retval;
 	struct hso_serial *serial = get_serial_by_tty(tty);
diff --git a/drivers/net/wan/pc300_tty.c b/drivers/net/wan/pc300_tty.c
index 515d9b8..d999e54 100644
--- a/drivers/net/wan/pc300_tty.c
+++ b/drivers/net/wan/pc300_tty.c
@@ -133,7 +133,7 @@ static void cpc_tty_signal_on(pc300dev_t *pc300dev, unsigned char);
 
 static int pc300_tiocmset(struct tty_struct *, struct file *,
 			  unsigned int, unsigned int);
-static int pc300_tiocmget(struct tty_struct *, struct file *);
+static int pc300_tiocmget(struct tty_struct *);
 
 /* functions called by PC300 driver */
 void cpc_tty_init(pc300dev_t *dev);
@@ -570,7 +570,7 @@ static int pc300_tiocmset(struct tty_struct *tty, struct file *file,
 	return 0;
 }
 
-static int pc300_tiocmget(struct tty_struct *tty, struct file *file)
+static int pc300_tiocmget(struct tty_struct *tty)
 {
 	unsigned int result;
 	unsigned char status;
diff --git a/drivers/staging/quatech_usb2/quatech_usb2.c b/drivers/staging/quatech_usb2/quatech_usb2.c
index ed58f48..1e50292 100644
--- a/drivers/staging/quatech_usb2/quatech_usb2.c
+++ b/drivers/staging/quatech_usb2/quatech_usb2.c
@@ -1078,7 +1078,7 @@ static void qt2_set_termios(struct tty_struct *tty,
 	}
 }
 
-static int qt2_tiocmget(struct tty_struct *tty, struct file *file)
+static int qt2_tiocmget(struct tty_struct *tty)
 {
 	struct usb_serial_port *port = tty->driver_data;
 	struct usb_serial *serial = port->serial;
diff --git a/drivers/staging/serqt_usb2/serqt_usb2.c b/drivers/staging/serqt_usb2/serqt_usb2.c
index 27841ef..56ded56 100644
--- a/drivers/staging/serqt_usb2/serqt_usb2.c
+++ b/drivers/staging/serqt_usb2/serqt_usb2.c
@@ -1383,7 +1383,7 @@ static void qt_break(struct tty_struct *tty, int break_state)
 
 static inline int qt_real_tiocmget(struct tty_struct *tty,
 				   struct usb_serial_port *port,
-				   struct file *file, struct usb_serial *serial)
+				   struct usb_serial *serial)
 {
 
 	u8 mcr;
@@ -1462,7 +1462,7 @@ static inline int qt_real_tiocmset(struct tty_struct *tty,
 		return 0;
 }
 
-static int qt_tiocmget(struct tty_struct *tty, struct file *file)
+static int qt_tiocmget(struct tty_struct *tty)
 {
 	struct usb_serial_port *port = tty->driver_data;
 	struct usb_serial *serial = get_usb_serial(port, __func__);
@@ -1480,7 +1480,7 @@ static int qt_tiocmget(struct tty_struct *tty, struct file *file)
 	dbg("%s - port %d\n", __func__, port->number);
 	dbg("%s - port->RxHolding = %d\n", __func__, qt_port->RxHolding);
 
-	retval = qt_real_tiocmget(tty, port, file, serial);
+	retval = qt_real_tiocmget(tty, port, serial);
 
 	spin_unlock_irqrestore(&qt_port->lock, flags);
 	return retval;
diff --git a/drivers/tty/hvc/hvsi.c b/drivers/tty/hvc/hvsi.c
index 67a75a5..5529310 100644
--- a/drivers/tty/hvc/hvsi.c
+++ b/drivers/tty/hvc/hvsi.c
@@ -1095,7 +1095,7 @@ static void hvsi_unthrottle(struct tty_struct *tty)
 	h_vio_signal(hp->vtermno, VIO_IRQ_ENABLE);
 }
 
-static int hvsi_tiocmget(struct tty_struct *tty, struct file *file)
+static int hvsi_tiocmget(struct tty_struct *tty)
 {
 	struct hvsi_struct *hp = tty->driver_data;
 
diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index aa2e5d3..b73aba1 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -2649,7 +2649,7 @@ static void gsmtty_wait_until_sent(struct tty_struct *tty, int timeout)
 	   to do here */
 }
 
-static int gsmtty_tiocmget(struct tty_struct *tty, struct file *filp)
+static int gsmtty_tiocmget(struct tty_struct *tty)
 {
 	struct gsm_dlci *dlci = tty->driver_data;
 	return dlci->modem_rx;
diff --git a/drivers/tty/serial/68360serial.c b/drivers/tty/serial/68360serial.c
index bc21eea..24a7f12 100644
--- a/drivers/tty/serial/68360serial.c
+++ b/drivers/tty/serial/68360serial.c
@@ -1240,7 +1240,7 @@ static int get_lsr_info(struct async_struct * info, unsigned int *value)
 }
 #endif
 
-static int rs_360_tiocmget(struct tty_struct *tty, struct file *file)
+static int rs_360_tiocmget(struct tty_struct *tty)
 {
 	ser_info_t *info = (ser_info_t *)tty->driver_data;
 	unsigned int result = 0;
diff --git a/drivers/tty/serial/crisv10.c b/drivers/tty/serial/crisv10.c
index bcc31f2..8cc5c02 100644
--- a/drivers/tty/serial/crisv10.c
+++ b/drivers/tty/serial/crisv10.c
@@ -3614,7 +3614,7 @@ rs_tiocmset(struct tty_struct *tty, struct file *file,
 }
 
 static int
-rs_tiocmget(struct tty_struct *tty, struct file *file)
+rs_tiocmget(struct tty_struct *tty)
 {
 	struct e100_serial *info = (struct e100_serial *)tty->driver_data;
 	unsigned int result;
diff --git a/drivers/tty/serial/ifx6x60.c b/drivers/tty/serial/ifx6x60.c
index c42de71..99a546e 100644
--- a/drivers/tty/serial/ifx6x60.c
+++ b/drivers/tty/serial/ifx6x60.c
@@ -244,7 +244,7 @@ static void ifx_spi_timeout(unsigned long arg)
  *	Map the signal state into Linux modem flags and report the value
  *	in Linux terms
  */
-static int ifx_spi_tiocmget(struct tty_struct *tty, struct file *filp)
+static int ifx_spi_tiocmget(struct tty_struct *tty)
 {
 	unsigned int value;
 	struct ifx_spi_device *ifx_dev = tty->driver_data;
diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 20563c5..53e490e 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -905,7 +905,7 @@ static int uart_get_lsr_info(struct tty_struct *tty,
 	return put_user(result, value);
 }
 
-static int uart_tiocmget(struct tty_struct *tty, struct file *file)
+static int uart_tiocmget(struct tty_struct *tty)
 {
 	struct uart_state *state = tty->driver_data;
 	struct tty_port *port = &state->port;
@@ -913,10 +913,8 @@ static int uart_tiocmget(struct tty_struct *tty, struct file *file)
 	int result = -EIO;
 
 	mutex_lock(&port->mutex);
-	if ((!file || !tty_hung_up_p(file)) &&
-	    !(tty->flags & (1 << TTY_IO_ERROR))) {
+	if (!(tty->flags & (1 << TTY_IO_ERROR))) {
 		result = uport->mctrl;
-
 		spin_lock_irq(&uport->lock);
 		result |= uport->ops->get_mctrl(uport);
 		spin_unlock_irq(&uport->lock);
diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 0065da4..fde5a4d 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -2465,12 +2465,12 @@ out:
  *	Locking: none (up to the driver)
  */
 
-static int tty_tiocmget(struct tty_struct *tty, struct file *file, int __user *p)
+static int tty_tiocmget(struct tty_struct *tty, int __user *p)
 {
 	int retval = -EINVAL;
 
 	if (tty->ops->tiocmget) {
-		retval = tty->ops->tiocmget(tty, file);
+		retval = tty->ops->tiocmget(tty);
 
 		if (retval >= 0)
 			retval = put_user(retval, p);
@@ -2655,7 +2655,7 @@ long tty_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		return send_break(tty, arg ? arg*100 : 250);
 
 	case TIOCMGET:
-		return tty_tiocmget(tty, file, p);
+		return tty_tiocmget(tty, p);
 	case TIOCMSET:
 	case TIOCMBIC:
 	case TIOCMBIS:
diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index 4ab49d4..844bb9d 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -776,7 +776,7 @@ static int acm_tty_break_ctl(struct tty_struct *tty, int state)
 	return retval;
 }
 
-static int acm_tty_tiocmget(struct tty_struct *tty, struct file *file)
+static int acm_tty_tiocmget(struct tty_struct *tty)
 {
 	struct acm *acm = tty->driver_data;
 
diff --git a/drivers/usb/serial/ark3116.c b/drivers/usb/serial/ark3116.c
index 8f1d4fb..35b610a 100644
--- a/drivers/usb/serial/ark3116.c
+++ b/drivers/usb/serial/ark3116.c
@@ -485,7 +485,7 @@ static int ark3116_ioctl(struct tty_struct *tty, struct file *file,
 	return -ENOIOCTLCMD;
 }
 
-static int ark3116_tiocmget(struct tty_struct *tty, struct file *file)
+static int ark3116_tiocmget(struct tty_struct *tty)
 {
 	struct usb_serial_port *port = tty->driver_data;
 	struct ark3116_private *priv = usb_get_serial_port_data(port);
diff --git a/drivers/usb/serial/belkin_sa.c b/drivers/usb/serial/belkin_sa.c
index 36df352..48fb3ba 100644
--- a/drivers/usb/serial/belkin_sa.c
+++ b/drivers/usb/serial/belkin_sa.c
@@ -100,7 +100,7 @@ static void belkin_sa_process_read_urb(struct urb *urb);
 static void belkin_sa_set_termios(struct tty_struct *tty,
 			struct usb_serial_port *port, struct ktermios * old);
 static void belkin_sa_break_ctl(struct tty_struct *tty, int break_state);
-static int  belkin_sa_tiocmget(struct tty_struct *tty, struct file *file);
+static int  belkin_sa_tiocmget(struct tty_struct *tty);
 static int  belkin_sa_tiocmset(struct tty_struct *tty, struct file *file,
 					unsigned int set, unsigned int clear);
 
@@ -497,7 +497,7 @@ static void belkin_sa_break_ctl(struct tty_struct *tty, int break_state)
 		dev_err(&port->dev, "Set break_ctl %d\n", break_state);
 }
 
-static int belkin_sa_tiocmget(struct tty_struct *tty, struct file *file)
+static int belkin_sa_tiocmget(struct tty_struct *tty)
 {
 	struct usb_serial_port *port = tty->driver_data;
 	struct belkin_sa_private *priv = usb_get_serial_port_data(port);
diff --git a/drivers/usb/serial/ch341.c b/drivers/usb/serial/ch341.c
index 7b8815d..aa0962b 100644
--- a/drivers/usb/serial/ch341.c
+++ b/drivers/usb/serial/ch341.c
@@ -572,7 +572,7 @@ static int ch341_ioctl(struct tty_struct *tty, struct file *file,
 	return -ENOIOCTLCMD;
 }
 
-static int ch341_tiocmget(struct tty_struct *tty, struct file *file)
+static int ch341_tiocmget(struct tty_struct *tty)
 {
 	struct usb_serial_port *port = tty->driver_data;
 	struct ch341_private *priv = usb_get_serial_port_data(port);
diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c
index 735ea03..b387381 100644
--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -41,7 +41,7 @@ static void cp210x_get_termios_port(struct usb_serial_port *port,
 	unsigned int *cflagp, unsigned int *baudp);
 static void cp210x_set_termios(struct tty_struct *, struct usb_serial_port *,
 							struct ktermios*);
-static int cp210x_tiocmget(struct tty_struct *, struct file *);
+static int cp210x_tiocmget(struct tty_struct *);
 static int cp210x_tiocmset(struct tty_struct *, struct file *,
 		unsigned int, unsigned int);
 static int cp210x_tiocmset_port(struct usb_serial_port *port, struct file *,
@@ -742,7 +742,7 @@ static void cp210x_dtr_rts(struct usb_serial_port *p, int on)
 		cp210x_tiocmset_port(p, NULL,  0, TIOCM_DTR|TIOCM_RTS);
 }
 
-static int cp210x_tiocmget (struct tty_struct *tty, struct file *file)
+static int cp210x_tiocmget (struct tty_struct *tty)
 {
 	struct usb_serial_port *port = tty->driver_data;
 	unsigned int control;
diff --git a/drivers/usb/serial/cypress_m8.c b/drivers/usb/serial/cypress_m8.c
index 2edf238..9c96cff 100644
--- a/drivers/usb/serial/cypress_m8.c
+++ b/drivers/usb/serial/cypress_m8.c
@@ -173,7 +173,7 @@ static int  cypress_ioctl(struct tty_struct *tty, struct file *file,
 			unsigned int cmd, unsigned long arg);
 static void cypress_set_termios(struct tty_struct *tty,
 			struct usb_serial_port *port, struct ktermios *old);
-static int  cypress_tiocmget(struct tty_struct *tty, struct file *file);
+static int  cypress_tiocmget(struct tty_struct *tty);
 static int  cypress_tiocmset(struct tty_struct *tty, struct file *file,
 			unsigned int set, unsigned int clear);
 static int  cypress_chars_in_buffer(struct tty_struct *tty);
@@ -864,7 +864,7 @@ static int cypress_write_room(struct tty_struct *tty)
 }
 
 
-static int cypress_tiocmget(struct tty_struct *tty, struct file *file)
+static int cypress_tiocmget(struct tty_struct *tty)
 {
 	struct usb_serial_port *port = tty->driver_data;
 	struct cypress_private *priv = usb_get_serial_port_data(port);
diff --git a/drivers/usb/serial/digi_acceleport.c b/drivers/usb/serial/digi_acceleport.c
index 666e5a6..08da46c 100644
--- a/drivers/usb/serial/digi_acceleport.c
+++ b/drivers/usb/serial/digi_acceleport.c
@@ -445,7 +445,7 @@ static void digi_rx_unthrottle(struct tty_struct *tty);
 static void digi_set_termios(struct tty_struct *tty,
 		struct usb_serial_port *port, struct ktermios *old_termios);
 static void digi_break_ctl(struct tty_struct *tty, int break_state);
-static int digi_tiocmget(struct tty_struct *tty, struct file *file);
+static int digi_tiocmget(struct tty_struct *tty);
 static int digi_tiocmset(struct tty_struct *tty, struct file *file,
 	unsigned int set, unsigned int clear);
 static int digi_write(struct tty_struct *tty, struct usb_serial_port *port,
@@ -1118,7 +1118,7 @@ static void digi_break_ctl(struct tty_struct *tty, int break_state)
 }
 
 
-static int digi_tiocmget(struct tty_struct *tty, struct file *file)
+static int digi_tiocmget(struct tty_struct *tty)
 {
 	struct usb_serial_port *port = tty->driver_data;
 	struct digi_port *priv = usb_get_serial_port_data(port);
diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 5a44671..f05bc53 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -864,7 +864,7 @@ static int ftdi_prepare_write_buffer(struct usb_serial_port *port,
 						void *dest, size_t size);
 static void ftdi_set_termios(struct tty_struct *tty,
 			struct usb_serial_port *port, struct ktermios *old);
-static int  ftdi_tiocmget(struct tty_struct *tty, struct file *file);
+static int  ftdi_tiocmget(struct tty_struct *tty);
 static int  ftdi_tiocmset(struct tty_struct *tty, struct file *file,
 			unsigned int set, unsigned int clear);
 static int  ftdi_ioctl(struct tty_struct *tty, struct file *file,
@@ -2176,7 +2176,7 @@ static void ftdi_set_termios(struct tty_struct *tty,
 	}
 }
 
-static int ftdi_tiocmget(struct tty_struct *tty, struct file *file)
+static int ftdi_tiocmget(struct tty_struct *tty)
 {
 	struct usb_serial_port *port = tty->driver_data;
 	struct ftdi_private *priv = usb_get_serial_port_data(port);
diff --git a/drivers/usb/serial/io_edgeport.c b/drivers/usb/serial/io_edgeport.c
index 3b246d9..c285e9b 100644
--- a/drivers/usb/serial/io_edgeport.c
+++ b/drivers/usb/serial/io_edgeport.c
@@ -219,7 +219,7 @@ static void edge_set_termios(struct tty_struct *tty,
 static int  edge_ioctl(struct tty_struct *tty, struct file *file,
 					unsigned int cmd, unsigned long arg);
 static void edge_break(struct tty_struct *tty, int break_state);
-static int  edge_tiocmget(struct tty_struct *tty, struct file *file);
+static int  edge_tiocmget(struct tty_struct *tty);
 static int  edge_tiocmset(struct tty_struct *tty, struct file *file,
 					unsigned int set, unsigned int clear);
 static int  edge_get_icount(struct tty_struct *tty,
@@ -1599,7 +1599,7 @@ static int edge_tiocmset(struct tty_struct *tty, struct file *file,
 	return 0;
 }
 
-static int edge_tiocmget(struct tty_struct *tty, struct file *file)
+static int edge_tiocmget(struct tty_struct *tty)
 {
 	struct usb_serial_port *port = tty->driver_data;
 	struct edgeport_port *edge_port = usb_get_serial_port_data(port);
diff --git a/drivers/usb/serial/io_ti.c b/drivers/usb/serial/io_ti.c
index 22506b0..7cb9f5c 100644
--- a/drivers/usb/serial/io_ti.c
+++ b/drivers/usb/serial/io_ti.c
@@ -2477,7 +2477,7 @@ static int edge_tiocmset(struct tty_struct *tty, struct file *file,
 	return 0;
 }
 
-static int edge_tiocmget(struct tty_struct *tty, struct file *file)
+static int edge_tiocmget(struct tty_struct *tty)
 {
 	struct usb_serial_port *port = tty->driver_data;
 	struct edgeport_port *edge_port = usb_get_serial_port_data(port);
diff --git a/drivers/usb/serial/iuu_phoenix.c b/drivers/usb/serial/iuu_phoenix.c
index 99b97c0..1d96142 100644
--- a/drivers/usb/serial/iuu_phoenix.c
+++ b/drivers/usb/serial/iuu_phoenix.c
@@ -179,7 +179,7 @@ static int iuu_tiocmset(struct tty_struct *tty, struct file *file,
  * When no card , the reader respond with TIOCM_CD
  * This is known as CD autodetect mechanism
  */
-static int iuu_tiocmget(struct tty_struct *tty, struct file *file)
+static int iuu_tiocmget(struct tty_struct *tty)
 {
 	struct usb_serial_port *port = tty->driver_data;
 	struct iuu_private *priv = usb_get_serial_port_data(port);
diff --git a/drivers/usb/serial/keyspan.c b/drivers/usb/serial/keyspan.c
index 0791778..1beebbb 100644
--- a/drivers/usb/serial/keyspan.c
+++ b/drivers/usb/serial/keyspan.c
@@ -301,7 +301,7 @@ static void keyspan_set_termios(struct tty_struct *tty,
 	keyspan_send_setup(port, 0);
 }
 
-static int keyspan_tiocmget(struct tty_struct *tty, struct file *file)
+static int keyspan_tiocmget(struct tty_struct *tty)
 {
 	struct usb_serial_port *port = tty->driver_data;
 	struct keyspan_port_private *p_priv = usb_get_serial_port_data(port);
diff --git a/drivers/usb/serial/keyspan.h b/drivers/usb/serial/keyspan.h
index ce134dc..5e5fc71 100644
--- a/drivers/usb/serial/keyspan.h
+++ b/drivers/usb/serial/keyspan.h
@@ -58,8 +58,7 @@ static void keyspan_set_termios		(struct tty_struct *tty,
 					 struct ktermios *old);
 static void keyspan_break_ctl		(struct tty_struct *tty,
 					 int break_state);
-static int  keyspan_tiocmget		(struct tty_struct *tty,
-					 struct file *file);
+static int  keyspan_tiocmget		(struct tty_struct *tty);
 static int  keyspan_tiocmset		(struct tty_struct *tty,
 					 struct file *file, unsigned int set,
 					 unsigned int clear);
diff --git a/drivers/usb/serial/keyspan_pda.c b/drivers/usb/serial/keyspan_pda.c
index 554a869..49ad2ba 100644
--- a/drivers/usb/serial/keyspan_pda.c
+++ b/drivers/usb/serial/keyspan_pda.c
@@ -457,7 +457,7 @@ static int keyspan_pda_set_modem_info(struct usb_serial *serial,
 	return rc;
 }
 
-static int keyspan_pda_tiocmget(struct tty_struct *tty, struct file *file)
+static int keyspan_pda_tiocmget(struct tty_struct *tty)
 {
 	struct usb_serial_port *port = tty->driver_data;
 	struct usb_serial *serial = port->serial;
diff --git a/drivers/usb/serial/kl5kusb105.c b/drivers/usb/serial/kl5kusb105.c
index e8a65ce..a570f52 100644
--- a/drivers/usb/serial/kl5kusb105.c
+++ b/drivers/usb/serial/kl5kusb105.c
@@ -68,7 +68,7 @@ static int  klsi_105_open(struct tty_struct *tty, struct usb_serial_port *port);
 static void klsi_105_close(struct usb_serial_port *port);
 static void klsi_105_set_termios(struct tty_struct *tty,
 			struct usb_serial_port *port, struct ktermios *old);
-static int  klsi_105_tiocmget(struct tty_struct *tty, struct file *file);
+static int  klsi_105_tiocmget(struct tty_struct *tty);
 static int  klsi_105_tiocmset(struct tty_struct *tty, struct file *file,
 			unsigned int set, unsigned int clear);
 static void klsi_105_process_read_urb(struct urb *urb);
@@ -637,7 +637,7 @@ static void mct_u232_break_ctl(struct tty_struct *tty, int break_state)
 }
 #endif
 
-static int klsi_105_tiocmget(struct tty_struct *tty, struct file *file)
+static int klsi_105_tiocmget(struct tty_struct *tty)
 {
 	struct usb_serial_port *port = tty->driver_data;
 	struct klsi_105_private *priv = usb_get_serial_port_data(port);
diff --git a/drivers/usb/serial/kobil_sct.c b/drivers/usb/serial/kobil_sct.c
index bd5bd85..81d07fb 100644
--- a/drivers/usb/serial/kobil_sct.c
+++ b/drivers/usb/serial/kobil_sct.c
@@ -77,7 +77,7 @@ static int  kobil_write(struct tty_struct *tty, struct usb_serial_port *port,
 static int  kobil_write_room(struct tty_struct *tty);
 static int  kobil_ioctl(struct tty_struct *tty, struct file *file,
 			unsigned int cmd, unsigned long arg);
-static int  kobil_tiocmget(struct tty_struct *tty, struct file *file);
+static int  kobil_tiocmget(struct tty_struct *tty);
 static int  kobil_tiocmset(struct tty_struct *tty, struct file *file,
 			   unsigned int set, unsigned int clear);
 static void kobil_read_int_callback(struct urb *urb);
@@ -504,7 +504,7 @@ static int kobil_write_room(struct tty_struct *tty)
 }
 
 
-static int kobil_tiocmget(struct tty_struct *tty, struct file *file)
+static int kobil_tiocmget(struct tty_struct *tty)
 {
 	struct usb_serial_port *port = tty->driver_data;
 	struct kobil_private *priv;
diff --git a/drivers/usb/serial/mct_u232.c b/drivers/usb/serial/mct_u232.c
index 1e225aa..0cae206 100644
--- a/drivers/usb/serial/mct_u232.c
+++ b/drivers/usb/serial/mct_u232.c
@@ -103,7 +103,7 @@ static void mct_u232_read_int_callback(struct urb *urb);
 static void mct_u232_set_termios(struct tty_struct *tty,
 			struct usb_serial_port *port, struct ktermios *old);
 static void mct_u232_break_ctl(struct tty_struct *tty, int break_state);
-static int  mct_u232_tiocmget(struct tty_struct *tty, struct file *file);
+static int  mct_u232_tiocmget(struct tty_struct *tty);
 static int  mct_u232_tiocmset(struct tty_struct *tty, struct file *file,
 			unsigned int set, unsigned int clear);
 static int  mct_u232_ioctl(struct tty_struct *tty, struct file *file,
@@ -790,7 +790,7 @@ static void mct_u232_break_ctl(struct tty_struct *tty, int break_state)
 } /* mct_u232_break_ctl */
 
 
-static int mct_u232_tiocmget(struct tty_struct *tty, struct file *file)
+static int mct_u232_tiocmget(struct tty_struct *tty)
 {
 	struct usb_serial_port *port = tty->driver_data;
 	struct mct_u232_private *priv = usb_get_serial_port_data(port);
diff --git a/drivers/usb/serial/mos7720.c b/drivers/usb/serial/mos7720.c
index 7d3bc9a..5d40d41 100644
--- a/drivers/usb/serial/mos7720.c
+++ b/drivers/usb/serial/mos7720.c
@@ -1833,7 +1833,7 @@ static int get_lsr_info(struct tty_struct *tty,
 	return 0;
 }
 
-static int mos7720_tiocmget(struct tty_struct *tty, struct file *file)
+static int mos7720_tiocmget(struct tty_struct *tty)
 {
 	struct usb_serial_port *port = tty->driver_data;
 	struct moschip_port *mos7720_port = usb_get_serial_port_data(port);
@@ -1865,7 +1865,7 @@ static int mos7720_tiocmset(struct tty_struct *tty, struct file *file,
 	struct moschip_port *mos7720_port = usb_get_serial_port_data(port);
 	unsigned int mcr ;
 	dbg("%s - port %d", __func__, port->number);
-	dbg("he was at tiocmget");
+	dbg("he was at tiocmset");
 
 	mcr = mos7720_port->shadowMCR;
 
diff --git a/drivers/usb/serial/mos7840.c b/drivers/usb/serial/mos7840.c
index 5627993..ee0dc9a 100644
--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -1644,7 +1644,7 @@ static void mos7840_unthrottle(struct tty_struct *tty)
 	}
 }
 
-static int mos7840_tiocmget(struct tty_struct *tty, struct file *file)
+static int mos7840_tiocmget(struct tty_struct *tty)
 {
 	struct usb_serial_port *port = tty->driver_data;
 	struct moschip_port *mos7840_port;
diff --git a/drivers/usb/serial/opticon.c b/drivers/usb/serial/opticon.c
index eda1f92..e305df8 100644
--- a/drivers/usb/serial/opticon.c
+++ b/drivers/usb/serial/opticon.c
@@ -352,7 +352,7 @@ static void opticon_unthrottle(struct tty_struct *tty)
 	}
 }
 
-static int opticon_tiocmget(struct tty_struct *tty, struct file *file)
+static int opticon_tiocmget(struct tty_struct *tty)
 {
 	struct usb_serial_port *port = tty->driver_data;
 	struct opticon_private *priv = usb_get_serial_data(port->serial);
diff --git a/drivers/usb/serial/oti6858.c b/drivers/usb/serial/oti6858.c
index 7361320..4cd3b0e 100644
--- a/drivers/usb/serial/oti6858.c
+++ b/drivers/usb/serial/oti6858.c
@@ -144,7 +144,7 @@ static int oti6858_write(struct tty_struct *tty, struct usb_serial_port *port,
 			const unsigned char *buf, int count);
 static int oti6858_write_room(struct tty_struct *tty);
 static int oti6858_chars_in_buffer(struct tty_struct *tty);
-static int oti6858_tiocmget(struct tty_struct *tty, struct file *file);
+static int oti6858_tiocmget(struct tty_struct *tty);
 static int oti6858_tiocmset(struct tty_struct *tty, struct file *file,
 				unsigned int set, unsigned int clear);
 static int oti6858_startup(struct usb_serial *serial);
@@ -657,7 +657,7 @@ static int oti6858_tiocmset(struct tty_struct *tty, struct file *file,
 	return 0;
 }
 
-static int oti6858_tiocmget(struct tty_struct *tty, struct file *file)
+static int oti6858_tiocmget(struct tty_struct *tty)
 {
 	struct usb_serial_port *port = tty->driver_data;
 	struct oti6858_private *priv = usb_get_serial_port_data(port);
diff --git a/drivers/usb/serial/pl2303.c b/drivers/usb/serial/pl2303.c
index 08c9181..6cb4f50 100644
--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -531,7 +531,7 @@ static int pl2303_tiocmset(struct tty_struct *tty, struct file *file,
 	return set_control_lines(port->serial->dev, control);
 }
 
-static int pl2303_tiocmget(struct tty_struct *tty, struct file *file)
+static int pl2303_tiocmget(struct tty_struct *tty)
 {
 	struct usb_serial_port *port = tty->driver_data;
 	struct pl2303_private *priv = usb_get_serial_port_data(port);
diff --git a/drivers/usb/serial/sierra.c b/drivers/usb/serial/sierra.c
index 7481ff8..66437f1 100644
--- a/drivers/usb/serial/sierra.c
+++ b/drivers/usb/serial/sierra.c
@@ -389,7 +389,7 @@ static void sierra_set_termios(struct tty_struct *tty,
 	sierra_send_setup(port);
 }
 
-static int sierra_tiocmget(struct tty_struct *tty, struct file *file)
+static int sierra_tiocmget(struct tty_struct *tty)
 {
 	struct usb_serial_port *port = tty->driver_data;
 	unsigned int value;
diff --git a/drivers/usb/serial/spcp8x5.c b/drivers/usb/serial/spcp8x5.c
index cbfb70b..cac1300 100644
--- a/drivers/usb/serial/spcp8x5.c
+++ b/drivers/usb/serial/spcp8x5.c
@@ -618,7 +618,7 @@ static int spcp8x5_tiocmset(struct tty_struct *tty, struct file *file,
 	return spcp8x5_set_ctrlLine(port->serial->dev, control , priv->type);
 }
 
-static int spcp8x5_tiocmget(struct tty_struct *tty, struct file *file)
+static int spcp8x5_tiocmget(struct tty_struct *tty)
 {
 	struct usb_serial_port *port = tty->driver_data;
 	struct spcp8x5_private *priv = usb_get_serial_port_data(port);
diff --git a/drivers/usb/serial/ssu100.c b/drivers/usb/serial/ssu100.c
index 8359ec7..b21583f 100644
--- a/drivers/usb/serial/ssu100.c
+++ b/drivers/usb/serial/ssu100.c
@@ -484,7 +484,7 @@ static int ssu100_attach(struct usb_serial *serial)
 	return ssu100_initdevice(serial->dev);
 }
 
-static int ssu100_tiocmget(struct tty_struct *tty, struct file *file)
+static int ssu100_tiocmget(struct tty_struct *tty)
 {
 	struct usb_serial_port *port = tty->driver_data;
 	struct usb_device *dev = port->serial->dev;
diff --git a/drivers/usb/serial/ti_usb_3410_5052.c b/drivers/usb/serial/ti_usb_3410_5052.c
index a910004..7fa96dc 100644
--- a/drivers/usb/serial/ti_usb_3410_5052.c
+++ b/drivers/usb/serial/ti_usb_3410_5052.c
@@ -112,7 +112,7 @@ static int ti_get_icount(struct tty_struct *tty,
 		struct serial_icounter_struct *icount);
 static void ti_set_termios(struct tty_struct *tty,
 		struct usb_serial_port *port, struct ktermios *old_termios);
-static int ti_tiocmget(struct tty_struct *tty, struct file *file);
+static int ti_tiocmget(struct tty_struct *tty);
 static int ti_tiocmset(struct tty_struct *tty, struct file *file,
 		unsigned int set, unsigned int clear);
 static void ti_break(struct tty_struct *tty, int break_state);
@@ -1000,7 +1000,7 @@ static void ti_set_termios(struct tty_struct *tty,
 }
 
 
-static int ti_tiocmget(struct tty_struct *tty, struct file *file)
+static int ti_tiocmget(struct tty_struct *tty)
 {
 	struct usb_serial_port *port = tty->driver_data;
 	struct ti_port *tport = usb_get_serial_port_data(port);
diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-serial.c
index 546a521..df105c6 100644
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -496,14 +496,14 @@ static const struct file_operations serial_proc_fops = {
 	.release	= single_release,
 };
 
-static int serial_tiocmget(struct tty_struct *tty, struct file *file)
+static int serial_tiocmget(struct tty_struct *tty)
 {
 	struct usb_serial_port *port = tty->driver_data;
 
 	dbg("%s - port %d", __func__, port->number);
 
 	if (port->serial->type->tiocmget)
-		return port->serial->type->tiocmget(tty, file);
+		return port->serial->type->tiocmget(tty);
 	return -EINVAL;
 }
 
diff --git a/drivers/usb/serial/usb-wwan.h b/drivers/usb/serial/usb-wwan.h
index 3ab77c5..8b68fc7 100644
--- a/drivers/usb/serial/usb-wwan.h
+++ b/drivers/usb/serial/usb-wwan.h
@@ -15,7 +15,7 @@ extern int usb_wwan_write_room(struct tty_struct *tty);
 extern void usb_wwan_set_termios(struct tty_struct *tty,
 				 struct usb_serial_port *port,
 				 struct ktermios *old);
-extern int usb_wwan_tiocmget(struct tty_struct *tty, struct file *file);
+extern int usb_wwan_tiocmget(struct tty_struct *tty);
 extern int usb_wwan_tiocmset(struct tty_struct *tty, struct file *file,
 			     unsigned int set, unsigned int clear);
 extern int usb_wwan_ioctl(struct tty_struct *tty, struct file *file,
diff --git a/drivers/usb/serial/usb_wwan.c b/drivers/usb/serial/usb_wwan.c
index b004b2a..60f9426 100644
--- a/drivers/usb/serial/usb_wwan.c
+++ b/drivers/usb/serial/usb_wwan.c
@@ -79,7 +79,7 @@ void usb_wwan_set_termios(struct tty_struct *tty,
 }
 EXPORT_SYMBOL(usb_wwan_set_termios);
 
-int usb_wwan_tiocmget(struct tty_struct *tty, struct file *file)
+int usb_wwan_tiocmget(struct tty_struct *tty)
 {
 	struct usb_serial_port *port = tty->driver_data;
 	unsigned int value;
diff --git a/drivers/usb/serial/whiteheat.c b/drivers/usb/serial/whiteheat.c
index 3f9ac88..bf85013 100644
--- a/drivers/usb/serial/whiteheat.c
+++ b/drivers/usb/serial/whiteheat.c
@@ -156,7 +156,7 @@ static int  whiteheat_ioctl(struct tty_struct *tty, struct file *file,
 			unsigned int cmd, unsigned long arg);
 static void whiteheat_set_termios(struct tty_struct *tty,
 			struct usb_serial_port *port, struct ktermios *old);
-static int  whiteheat_tiocmget(struct tty_struct *tty, struct file *file);
+static int  whiteheat_tiocmget(struct tty_struct *tty);
 static int  whiteheat_tiocmset(struct tty_struct *tty, struct file *file,
 			unsigned int set, unsigned int clear);
 static void whiteheat_break_ctl(struct tty_struct *tty, int break_state);
@@ -833,7 +833,7 @@ static int whiteheat_write_room(struct tty_struct *tty)
 	return (room);
 }
 
-static int whiteheat_tiocmget(struct tty_struct *tty, struct file *file)
+static int whiteheat_tiocmget(struct tty_struct *tty)
 {
 	struct usb_serial_port *port = tty->driver_data;
 	struct whiteheat_private *info = usb_get_serial_port_data(port);
diff --git a/include/linux/tty_driver.h b/include/linux/tty_driver.h
index c3d43eb..9539d74 100644
--- a/include/linux/tty_driver.h
+++ b/include/linux/tty_driver.h
@@ -271,7 +271,7 @@ struct tty_operations {
 	void (*set_ldisc)(struct tty_struct *tty);
 	void (*wait_until_sent)(struct tty_struct *tty, int timeout);
 	void (*send_xchar)(struct tty_struct *tty, char ch);
-	int (*tiocmget)(struct tty_struct *tty, struct file *file);
+	int (*tiocmget)(struct tty_struct *tty);
 	int (*tiocmset)(struct tty_struct *tty, struct file *file,
 			unsigned int set, unsigned int clear);
 	int (*resize)(struct tty_struct *tty, struct winsize *ws);
diff --git a/include/linux/usb/serial.h b/include/linux/usb/serial.h
index c904913..30b9453 100644
--- a/include/linux/usb/serial.h
+++ b/include/linux/usb/serial.h
@@ -268,7 +268,7 @@ struct usb_serial_driver {
 	int  (*chars_in_buffer)(struct tty_struct *tty);
 	void (*throttle)(struct tty_struct *tty);
 	void (*unthrottle)(struct tty_struct *tty);
-	int  (*tiocmget)(struct tty_struct *tty, struct file *file);
+	int  (*tiocmget)(struct tty_struct *tty);
 	int  (*tiocmset)(struct tty_struct *tty, struct file *file,
 			 unsigned int set, unsigned int clear);
 	int  (*get_icount)(struct tty_struct *tty,
diff --git a/include/net/irda/ircomm_tty.h b/include/net/irda/ircomm_tty.h
index eea2e61..fa3793b 100644
--- a/include/net/irda/ircomm_tty.h
+++ b/include/net/irda/ircomm_tty.h
@@ -120,7 +120,7 @@ struct ircomm_tty_cb {
 void ircomm_tty_start(struct tty_struct *tty);
 void ircomm_tty_check_modem_status(struct ircomm_tty_cb *self);
 
-extern int ircomm_tty_tiocmget(struct tty_struct *tty, struct file *file);
+extern int ircomm_tty_tiocmget(struct tty_struct *tty);
 extern int ircomm_tty_tiocmset(struct tty_struct *tty, struct file *file,
 			       unsigned int set, unsigned int clear);
 extern int ircomm_tty_ioctl(struct tty_struct *tty, struct file *file, 
diff --git a/net/bluetooth/rfcomm/tty.c b/net/bluetooth/rfcomm/tty.c
index 2575c2d..7f67fa4 100644
--- a/net/bluetooth/rfcomm/tty.c
+++ b/net/bluetooth/rfcomm/tty.c
@@ -1089,7 +1089,7 @@ static void rfcomm_tty_hangup(struct tty_struct *tty)
 	}
 }
 
-static int rfcomm_tty_tiocmget(struct tty_struct *tty, struct file *filp)
+static int rfcomm_tty_tiocmget(struct tty_struct *tty)
 {
 	struct rfcomm_dev *dev = (struct rfcomm_dev *) tty->driver_data;
 
diff --git a/net/irda/ircomm/ircomm_tty_ioctl.c b/net/irda/ircomm/ircomm_tty_ioctl.c
index 24cb3aa..bb47cae 100644
--- a/net/irda/ircomm/ircomm_tty_ioctl.c
+++ b/net/irda/ircomm/ircomm_tty_ioctl.c
@@ -189,12 +189,12 @@ void ircomm_tty_set_termios(struct tty_struct *tty,
 }
 
 /*
- * Function ircomm_tty_tiocmget (tty, file)
+ * Function ircomm_tty_tiocmget (tty)
  *
  *
  *
  */
-int ircomm_tty_tiocmget(struct tty_struct *tty, struct file *file)
+int ircomm_tty_tiocmget(struct tty_struct *tty)
 {
 	struct ircomm_tty_cb *self = (struct ircomm_tty_cb *) tty->driver_data;
 	unsigned int result;

