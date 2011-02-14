Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756182Ab1BNQ4S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 11:56:18 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:59835 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756108Ab1BNQ4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 11:56:12 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 2/6] tiocmset: kill the file pointer argument
To: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 14 Feb 2011 16:26:50 +0000
Message-ID: <20110214162624.10571.54639.stgit@bob.linux.org.uk>
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

Doing tiocmget was such fun we should do tiocmset as well for the same
reasons

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/char/amiserial.c                    |    4 ++--
 drivers/char/cyclades.c                     |    2 +-
 drivers/char/epca.c                         |    4 ++--
 drivers/char/ip2/ip2main.c                  |    4 ++--
 drivers/char/isicom.c                       |    4 ++--
 drivers/char/istallion.c                    |    2 +-
 drivers/char/moxa.c                         |    6 +++---
 drivers/char/mxser.c                        |    4 ++--
 drivers/char/nozomi.c                       |    4 ++--
 drivers/char/pcmcia/ipwireless/tty.c        |    2 +-
 drivers/char/pcmcia/synclink_cs.c           |    6 +++---
 drivers/char/riscom8.c                      |    4 ++--
 drivers/char/rocket.c                       |    4 ++--
 drivers/char/serial167.c                    |    3 +--
 drivers/char/specialix.c                    |    4 ++--
 drivers/char/stallion.c                     |    2 +-
 drivers/char/sx.c                           |    4 ++--
 drivers/char/synclink.c                     |    6 +++---
 drivers/char/synclink_gt.c                  |    6 +++---
 drivers/char/synclinkmp.c                   |    8 ++++----
 drivers/isdn/gigaset/interface.c            |    4 ++--
 drivers/isdn/gigaset/ser-gigaset.c          |    2 +-
 drivers/isdn/i4l/isdn_tty.c                 |    2 +-
 drivers/mmc/card/sdio_uart.c                |    2 +-
 drivers/net/irda/irtty-sir.c                |    2 +-
 drivers/net/usb/hso.c                       |    6 +++---
 drivers/net/wan/pc300_tty.c                 |    5 ++---
 drivers/staging/quatech_usb2/quatech_usb2.c |    2 +-
 drivers/staging/serqt_usb2/serqt_usb2.c     |    5 ++---
 drivers/tty/hvc/hvsi.c                      |    4 ++--
 drivers/tty/n_gsm.c                         |    2 +-
 drivers/tty/serial/68360serial.c            |    2 +-
 drivers/tty/serial/crisv10.c                |    3 +--
 drivers/tty/serial/ifx6x60.c                |    3 +--
 drivers/tty/serial/serial_core.c            |    6 ++----
 drivers/tty/tty_io.c                        |    7 +++----
 drivers/usb/class/cdc-acm.c                 |    2 +-
 drivers/usb/serial/ark3116.c                |    2 +-
 drivers/usb/serial/belkin_sa.c              |    4 ++--
 drivers/usb/serial/ch341.c                  |    2 +-
 drivers/usb/serial/cp210x.c                 |   15 +++++++--------
 drivers/usb/serial/cypress_m8.c             |    4 ++--
 drivers/usb/serial/digi_acceleport.c        |   10 +++++-----
 drivers/usb/serial/ftdi_sio.c               |    4 ++--
 drivers/usb/serial/io_edgeport.c            |    4 ++--
 drivers/usb/serial/io_ti.c                  |    2 +-
 drivers/usb/serial/iuu_phoenix.c            |    2 +-
 drivers/usb/serial/keyspan.c                |    2 +-
 drivers/usb/serial/keyspan.h                |    2 +-
 drivers/usb/serial/keyspan_pda.c            |    2 +-
 drivers/usb/serial/kl5kusb105.c             |    4 ++--
 drivers/usb/serial/kobil_sct.c              |    4 ++--
 drivers/usb/serial/mct_u232.c               |    4 ++--
 drivers/usb/serial/mos7720.c                |    2 +-
 drivers/usb/serial/mos7840.c                |    2 +-
 drivers/usb/serial/oti6858.c                |    4 ++--
 drivers/usb/serial/pl2303.c                 |    2 +-
 drivers/usb/serial/sierra.c                 |    2 +-
 drivers/usb/serial/spcp8x5.c                |    2 +-
 drivers/usb/serial/ssu100.c                 |    2 +-
 drivers/usb/serial/ti_usb_3410_5052.c       |    6 +++---
 drivers/usb/serial/usb-serial.c             |    4 ++--
 drivers/usb/serial/usb-wwan.h               |    2 +-
 drivers/usb/serial/usb_wwan.c               |    2 +-
 drivers/usb/serial/whiteheat.c              |    4 ++--
 include/linux/tty_driver.h                  |    2 +-
 include/linux/usb/serial.h                  |    2 +-
 include/net/irda/ircomm_tty.h               |    2 +-
 net/bluetooth/rfcomm/tty.c                  |    2 +-
 net/irda/ircomm/ircomm_tty_ioctl.c          |    4 ++--
 70 files changed, 123 insertions(+), 132 deletions(-)


diff --git a/drivers/char/amiserial.c b/drivers/char/amiserial.c
index bc67e68..5c15fad 100644
--- a/drivers/char/amiserial.c
+++ b/drivers/char/amiserial.c
@@ -1216,8 +1216,8 @@ static int rs_tiocmget(struct tty_struct *tty)
 		| (!(status  & SER_CTS) ? TIOCM_CTS : 0);
 }
 
-static int rs_tiocmset(struct tty_struct *tty, struct file *file,
-		       unsigned int set, unsigned int clear)
+static int rs_tiocmset(struct tty_struct *tty, unsigned int set,
+						unsigned int clear)
 {
 	struct async_struct * info = tty->driver_data;
 	unsigned long flags;
diff --git a/drivers/char/cyclades.c b/drivers/char/cyclades.c
index e7945dd..942b6f2 100644
--- a/drivers/char/cyclades.c
+++ b/drivers/char/cyclades.c
@@ -2483,7 +2483,7 @@ end:
 }				/* cy_tiomget */
 
 static int
-cy_tiocmset(struct tty_struct *tty, struct file *file,
+cy_tiocmset(struct tty_struct *tty,
 		unsigned int set, unsigned int clear)
 {
 	struct cyclades_port *info = tty->driver_data;
diff --git a/drivers/char/epca.c b/drivers/char/epca.c
index ecf6f0a..e5872b5 100644
--- a/drivers/char/epca.c
+++ b/drivers/char/epca.c
@@ -2015,7 +2015,7 @@ static int pc_tiocmget(struct tty_struct *tty)
 	return mflag;
 }
 
-static int pc_tiocmset(struct tty_struct *tty, struct file *file,
+static int pc_tiocmset(struct tty_struct *tty,
 		       unsigned int set, unsigned int clear)
 {
 	struct channel *ch = tty->driver_data;
@@ -2081,7 +2081,7 @@ static int pc_ioctl(struct tty_struct *tty, struct file *file,
 	case TIOCMODS:
 		if (get_user(mstat, (unsigned __user *)argp))
 			return -EFAULT;
-		return pc_tiocmset(tty, file, mstat, ~mstat);
+		return pc_tiocmset(tty, mstat, ~mstat);
 	case TIOCSDTR:
 		spin_lock_irqsave(&epca_lock, flags);
 		ch->omodem |= ch->m_dtr;
diff --git a/drivers/char/ip2/ip2main.c b/drivers/char/ip2/ip2main.c
index 476cd08..d5f866c 100644
--- a/drivers/char/ip2/ip2main.c
+++ b/drivers/char/ip2/ip2main.c
@@ -182,7 +182,7 @@ static void ip2_stop(PTTY);
 static void ip2_start(PTTY);
 static void ip2_hangup(PTTY);
 static int  ip2_tiocmget(struct tty_struct *tty);
-static int  ip2_tiocmset(struct tty_struct *tty, struct file *file,
+static int  ip2_tiocmset(struct tty_struct *tty,
 			 unsigned int set, unsigned int clear);
 static int ip2_get_icount(struct tty_struct *tty,
 		struct serial_icounter_struct *icount);
@@ -2085,7 +2085,7 @@ static int ip2_tiocmget(struct tty_struct *tty)
 	      | ((pCh->dataSetIn  & I2_CTS) ? TIOCM_CTS : 0);
 }
 
-static int ip2_tiocmset(struct tty_struct *tty, struct file *file,
+static int ip2_tiocmset(struct tty_struct *tty,
 			unsigned int set, unsigned int clear)
 {
 	i2ChanStrPtr pCh = DevTable[tty->index];
diff --git a/drivers/char/isicom.c b/drivers/char/isicom.c
index 836370b..60f4d8a 100644
--- a/drivers/char/isicom.c
+++ b/drivers/char/isicom.c
@@ -1082,8 +1082,8 @@ static int isicom_tiocmget(struct tty_struct *tty)
 		((status & ISI_RI ) ? TIOCM_RI  : 0);
 }
 
-static int isicom_tiocmset(struct tty_struct *tty, struct file *file,
-	unsigned int set, unsigned int clear)
+static int isicom_tiocmset(struct tty_struct *tty,
+					unsigned int set, unsigned int clear)
 {
 	struct isi_port *port = tty->driver_data;
 	unsigned long flags;
diff --git a/drivers/char/istallion.c b/drivers/char/istallion.c
index 7843a84..763b58d 100644
--- a/drivers/char/istallion.c
+++ b/drivers/char/istallion.c
@@ -1524,7 +1524,7 @@ static int stli_tiocmget(struct tty_struct *tty)
 	return stli_mktiocm(portp->asig.sigvalue);
 }
 
-static int stli_tiocmset(struct tty_struct *tty, struct file *file,
+static int stli_tiocmset(struct tty_struct *tty,
 			 unsigned int set, unsigned int clear)
 {
 	struct stliport *portp = tty->driver_data;
diff --git a/drivers/char/moxa.c b/drivers/char/moxa.c
index fdf069b..01e0138 100644
--- a/drivers/char/moxa.c
+++ b/drivers/char/moxa.c
@@ -200,7 +200,7 @@ static void moxa_stop(struct tty_struct *);
 static void moxa_start(struct tty_struct *);
 static void moxa_hangup(struct tty_struct *);
 static int moxa_tiocmget(struct tty_struct *tty);
-static int moxa_tiocmset(struct tty_struct *tty, struct file *file,
+static int moxa_tiocmset(struct tty_struct *tty,
 			 unsigned int set, unsigned int clear);
 static void moxa_poll(unsigned long);
 static void moxa_set_tty_param(struct tty_struct *, struct ktermios *);
@@ -1277,8 +1277,8 @@ static int moxa_tiocmget(struct tty_struct *tty)
 	return flag;
 }
 
-static int moxa_tiocmset(struct tty_struct *tty, struct file *file,
-			 unsigned int set, unsigned int clear)
+static int moxa_tiocmset(struct tty_struct *tty,
+                			 unsigned int set, unsigned int clear)
 {
 	struct moxa_port *ch;
 	int port;
diff --git a/drivers/char/mxser.c b/drivers/char/mxser.c
index 4d2f03e..effca17 100644
--- a/drivers/char/mxser.c
+++ b/drivers/char/mxser.c
@@ -1347,8 +1347,8 @@ static int mxser_tiocmget(struct tty_struct *tty)
 		    ((status & UART_MSR_CTS) ? TIOCM_CTS : 0);
 }
 
-static int mxser_tiocmset(struct tty_struct *tty, struct file *file,
-		unsigned int set, unsigned int clear)
+static int mxser_tiocmset(struct tty_struct *tty,
+					unsigned int set, unsigned int clear)
 {
 	struct mxser_port *info = tty->driver_data;
 	unsigned long flags;
diff --git a/drivers/char/nozomi.c b/drivers/char/nozomi.c
index 0e1dff2..1b74c48 100644
--- a/drivers/char/nozomi.c
+++ b/drivers/char/nozomi.c
@@ -1767,8 +1767,8 @@ static int ntty_tiocmget(struct tty_struct *tty)
 }
 
 /* Sets io controls parameters */
-static int ntty_tiocmset(struct tty_struct *tty, struct file *file,
-	unsigned int set, unsigned int clear)
+static int ntty_tiocmset(struct tty_struct *tty,
+					unsigned int set, unsigned int clear)
 {
 	struct nozomi *dc = get_dc_by_tty(tty);
 	unsigned long flags;
diff --git a/drivers/char/pcmcia/ipwireless/tty.c b/drivers/char/pcmcia/ipwireless/tty.c
index 7d2ef49..748190d 100644
--- a/drivers/char/pcmcia/ipwireless/tty.c
+++ b/drivers/char/pcmcia/ipwireless/tty.c
@@ -410,7 +410,7 @@ static int ipw_tiocmget(struct tty_struct *linux_tty)
 }
 
 static int
-ipw_tiocmset(struct tty_struct *linux_tty, struct file *file,
+ipw_tiocmset(struct tty_struct *linux_tty,
 	     unsigned int set, unsigned int clear)
 {
 	struct ipw_tty *tty = linux_tty->driver_data;
diff --git a/drivers/char/pcmcia/synclink_cs.c b/drivers/char/pcmcia/synclink_cs.c
index 7b68ba6..02127ca 100644
--- a/drivers/char/pcmcia/synclink_cs.c
+++ b/drivers/char/pcmcia/synclink_cs.c
@@ -419,8 +419,8 @@ static void bh_status(MGSLPC_INFO *info);
  * ioctl handlers
  */
 static int tiocmget(struct tty_struct *tty);
-static int tiocmset(struct tty_struct *tty, struct file *file,
-		    unsigned int set, unsigned int clear);
+static int tiocmset(struct tty_struct *tty,
+					unsigned int set, unsigned int clear);
 static int get_stats(MGSLPC_INFO *info, struct mgsl_icount __user *user_icount);
 static int get_params(MGSLPC_INFO *info, MGSL_PARAMS __user *user_params);
 static int set_params(MGSLPC_INFO *info, MGSL_PARAMS __user *new_params, struct tty_struct *tty);
@@ -2139,7 +2139,7 @@ static int tiocmget(struct tty_struct *tty)
 
 /* set modem control signals (DTR/RTS)
  */
-static int tiocmset(struct tty_struct *tty, struct file *file,
+static int tiocmset(struct tty_struct *tty,
 		    unsigned int set, unsigned int clear)
 {
 	MGSLPC_INFO *info = (MGSLPC_INFO *)tty->driver_data;
diff --git a/drivers/char/riscom8.c b/drivers/char/riscom8.c
index 5d0c984..3666dec 100644
--- a/drivers/char/riscom8.c
+++ b/drivers/char/riscom8.c
@@ -1115,8 +1115,8 @@ static int rc_tiocmget(struct tty_struct *tty)
 	return result;
 }
 
-static int rc_tiocmset(struct tty_struct *tty, struct file *file,
-		       unsigned int set, unsigned int clear)
+static int rc_tiocmset(struct tty_struct *tty,
+				       unsigned int set, unsigned int clear)
 {
 	struct riscom_port *port = tty->driver_data;
 	unsigned long flags;
diff --git a/drivers/char/rocket.c b/drivers/char/rocket.c
index 75e98ef..a34502c 100644
--- a/drivers/char/rocket.c
+++ b/drivers/char/rocket.c
@@ -1189,8 +1189,8 @@ static int rp_tiocmget(struct tty_struct *tty)
 /* 
  *  Sets the modem control lines
  */
-static int rp_tiocmset(struct tty_struct *tty, struct file *file,
-		    unsigned int set, unsigned int clear)
+static int rp_tiocmset(struct tty_struct *tty,
+					unsigned int set, unsigned int clear)
 {
 	struct r_port *info = tty->driver_data;
 
diff --git a/drivers/char/serial167.c b/drivers/char/serial167.c
index fda9064..89ac542 100644
--- a/drivers/char/serial167.c
+++ b/drivers/char/serial167.c
@@ -1331,8 +1331,7 @@ static int cy_tiocmget(struct tty_struct *tty)
 }				/* cy_tiocmget */
 
 static int
-cy_tiocmset(struct tty_struct *tty, struct file *file,
-	    unsigned int set, unsigned int clear)
+cy_tiocmset(struct tty_struct *tty, unsigned int set, unsigned int clear)
 {
 	struct cyclades_port *info = tty->driver_data;
 	int channel;
diff --git a/drivers/char/specialix.c b/drivers/char/specialix.c
index bfecfbe..d695274 100644
--- a/drivers/char/specialix.c
+++ b/drivers/char/specialix.c
@@ -1778,8 +1778,8 @@ static int sx_tiocmget(struct tty_struct *tty)
 }
 
 
-static int sx_tiocmset(struct tty_struct *tty, struct file *file,
-		       unsigned int set, unsigned int clear)
+static int sx_tiocmset(struct tty_struct *tty,
+				       unsigned int set, unsigned int clear)
 {
 	struct specialix_port *port = tty->driver_data;
 	unsigned long flags;
diff --git a/drivers/char/stallion.c b/drivers/char/stallion.c
index 8c2bf3f..c42dbff 100644
--- a/drivers/char/stallion.c
+++ b/drivers/char/stallion.c
@@ -1107,7 +1107,7 @@ static int stl_tiocmget(struct tty_struct *tty)
 	return stl_getsignals(portp);
 }
 
-static int stl_tiocmset(struct tty_struct *tty, struct file *file,
+static int stl_tiocmset(struct tty_struct *tty,
 			unsigned int set, unsigned int clear)
 {
 	struct stlport	*portp;
diff --git a/drivers/char/sx.c b/drivers/char/sx.c
index f46214e6..342c6ae 100644
--- a/drivers/char/sx.c
+++ b/drivers/char/sx.c
@@ -1879,8 +1879,8 @@ static int sx_tiocmget(struct tty_struct *tty)
 	return sx_getsignals(port);
 }
 
-static int sx_tiocmset(struct tty_struct *tty, struct file *file,
-		unsigned int set, unsigned int clear)
+static int sx_tiocmset(struct tty_struct *tty,
+					unsigned int set, unsigned int clear)
 {
 	struct sx_port *port = tty->driver_data;
 	int rts = -1, dtr = -1;
diff --git a/drivers/char/synclink.c b/drivers/char/synclink.c
index d359e09..691e109 100644
--- a/drivers/char/synclink.c
+++ b/drivers/char/synclink.c
@@ -824,7 +824,7 @@ static isr_dispatch_func UscIsrTable[7] =
  * ioctl call handlers
  */
 static int tiocmget(struct tty_struct *tty);
-static int tiocmset(struct tty_struct *tty, struct file *file,
+static int tiocmset(struct tty_struct *tty,
 		    unsigned int set, unsigned int clear);
 static int mgsl_get_stats(struct mgsl_struct * info, struct mgsl_icount
 	__user *user_icount);
@@ -2871,8 +2871,8 @@ static int tiocmget(struct tty_struct *tty)
 
 /* set modem control signals (DTR/RTS)
  */
-static int tiocmset(struct tty_struct *tty, struct file *file,
-		    unsigned int set, unsigned int clear)
+static int tiocmset(struct tty_struct *tty,
+				    unsigned int set, unsigned int clear)
 {
 	struct mgsl_struct *info = tty->driver_data;
  	unsigned long flags;
diff --git a/drivers/char/synclink_gt.c b/drivers/char/synclink_gt.c
index f18ab8a..04da6d6 100644
--- a/drivers/char/synclink_gt.c
+++ b/drivers/char/synclink_gt.c
@@ -513,8 +513,8 @@ static int  rx_enable(struct slgt_info *info, int enable);
 static int  modem_input_wait(struct slgt_info *info,int arg);
 static int  wait_mgsl_event(struct slgt_info *info, int __user *mask_ptr);
 static int  tiocmget(struct tty_struct *tty);
-static int  tiocmset(struct tty_struct *tty, struct file *file,
-		     unsigned int set, unsigned int clear);
+static int  tiocmset(struct tty_struct *tty,
+				unsigned int set, unsigned int clear);
 static int set_break(struct tty_struct *tty, int break_state);
 static int  get_interface(struct slgt_info *info, int __user *if_mode);
 static int  set_interface(struct slgt_info *info, int if_mode);
@@ -3223,7 +3223,7 @@ static int tiocmget(struct tty_struct *tty)
  *		TIOCMSET = set/clear signal values
  * 	value	bit mask for command
  */
-static int tiocmset(struct tty_struct *tty, struct file *file,
+static int tiocmset(struct tty_struct *tty,
 		    unsigned int set, unsigned int clear)
 {
 	struct slgt_info *info = tty->driver_data;
diff --git a/drivers/char/synclinkmp.c b/drivers/char/synclinkmp.c
index 5900213..1f9de97 100644
--- a/drivers/char/synclinkmp.c
+++ b/drivers/char/synclinkmp.c
@@ -547,8 +547,8 @@ static int  rx_enable(SLMP_INFO *info, int enable);
 static int  modem_input_wait(SLMP_INFO *info,int arg);
 static int  wait_mgsl_event(SLMP_INFO *info, int __user *mask_ptr);
 static int  tiocmget(struct tty_struct *tty);
-static int  tiocmset(struct tty_struct *tty, struct file *file,
-		     unsigned int set, unsigned int clear);
+static int  tiocmset(struct tty_struct *tty,
+			unsigned int set, unsigned int clear);
 static int  set_break(struct tty_struct *tty, int break_state);
 
 static void add_device(SLMP_INFO *info);
@@ -3232,8 +3232,8 @@ static int tiocmget(struct tty_struct *tty)
 
 /* set modem control signals (DTR/RTS)
  */
-static int tiocmset(struct tty_struct *tty, struct file *file,
-		    unsigned int set, unsigned int clear)
+static int tiocmset(struct tty_struct *tty,
+					unsigned int set, unsigned int clear)
 {
 	SLMP_INFO *info = tty->driver_data;
  	unsigned long flags;
diff --git a/drivers/isdn/gigaset/interface.c b/drivers/isdn/gigaset/interface.c
index e1a7c14..9b2bb49 100644
--- a/drivers/isdn/gigaset/interface.c
+++ b/drivers/isdn/gigaset/interface.c
@@ -123,7 +123,7 @@ static void if_throttle(struct tty_struct *tty);
 static void if_unthrottle(struct tty_struct *tty);
 static void if_set_termios(struct tty_struct *tty, struct ktermios *old);
 static int  if_tiocmget(struct tty_struct *tty);
-static int  if_tiocmset(struct tty_struct *tty, struct file *file,
+static int  if_tiocmset(struct tty_struct *tty,
 			unsigned int set, unsigned int clear);
 static int  if_write(struct tty_struct *tty,
 		     const unsigned char *buf, int count);
@@ -303,7 +303,7 @@ static int if_tiocmget(struct tty_struct *tty)
 	return retval;
 }
 
-static int if_tiocmset(struct tty_struct *tty, struct file *file,
+static int if_tiocmset(struct tty_struct *tty,
 		       unsigned int set, unsigned int clear)
 {
 	struct cardstate *cs;
diff --git a/drivers/isdn/gigaset/ser-gigaset.c b/drivers/isdn/gigaset/ser-gigaset.c
index 0ef09d0..86a5c4f 100644
--- a/drivers/isdn/gigaset/ser-gigaset.c
+++ b/drivers/isdn/gigaset/ser-gigaset.c
@@ -440,7 +440,7 @@ static int gigaset_set_modem_ctrl(struct cardstate *cs, unsigned old_state,
 	if (!set && !clear)
 		return 0;
 	gig_dbg(DEBUG_IF, "tiocmset set %x clear %x", set, clear);
-	return tty->ops->tiocmset(tty, NULL, set, clear);
+	return tty->ops->tiocmset(tty, set, clear);
 }
 
 static int gigaset_baud_rate(struct cardstate *cs, unsigned cflag)
diff --git a/drivers/isdn/i4l/isdn_tty.c b/drivers/isdn/i4l/isdn_tty.c
index ba6c2f1..0341c69 100644
--- a/drivers/isdn/i4l/isdn_tty.c
+++ b/drivers/isdn/i4l/isdn_tty.c
@@ -1372,7 +1372,7 @@ isdn_tty_tiocmget(struct tty_struct *tty)
 }
 
 static int
-isdn_tty_tiocmset(struct tty_struct *tty, struct file *file,
+isdn_tty_tiocmset(struct tty_struct *tty,
 		unsigned int set, unsigned int clear)
 {
 	modem_info *info = (modem_info *) tty->driver_data;
diff --git a/drivers/mmc/card/sdio_uart.c b/drivers/mmc/card/sdio_uart.c
index 86bb04d..c8c9edb 100644
--- a/drivers/mmc/card/sdio_uart.c
+++ b/drivers/mmc/card/sdio_uart.c
@@ -970,7 +970,7 @@ static int sdio_uart_tiocmget(struct tty_struct *tty)
 	return result;
 }
 
-static int sdio_uart_tiocmset(struct tty_struct *tty, struct file *file,
+static int sdio_uart_tiocmset(struct tty_struct *tty,
 			      unsigned int set, unsigned int clear)
 {
 	struct sdio_uart_port *port = tty->driver_data;
diff --git a/drivers/net/irda/irtty-sir.c b/drivers/net/irda/irtty-sir.c
index ee1dde5..3352b24 100644
--- a/drivers/net/irda/irtty-sir.c
+++ b/drivers/net/irda/irtty-sir.c
@@ -167,7 +167,7 @@ static int irtty_set_dtr_rts(struct sir_dev *dev, int dtr, int rts)
 	 * let's be careful... Jean II
 	 */
 	IRDA_ASSERT(priv->tty->ops->tiocmset != NULL, return -1;);
-	priv->tty->ops->tiocmset(priv->tty, NULL, set, clear);
+	priv->tty->ops->tiocmset(priv->tty, set, clear);
 
 	return 0;
 }
diff --git a/drivers/net/usb/hso.c b/drivers/net/usb/hso.c
index 7c68c45..956e1d6 100644
--- a/drivers/net/usb/hso.c
+++ b/drivers/net/usb/hso.c
@@ -324,7 +324,7 @@ struct hso_device {
 /* Prototypes                                                                */
 /*****************************************************************************/
 /* Serial driver functions */
-static int hso_serial_tiocmset(struct tty_struct *tty, struct file *file,
+static int hso_serial_tiocmset(struct tty_struct *tty,
 			       unsigned int set, unsigned int clear);
 static void ctrl_callback(struct urb *urb);
 static int put_rxbuf_data(struct urb *urb, struct hso_serial *serial);
@@ -1335,7 +1335,7 @@ static int hso_serial_open(struct tty_struct *tty, struct file *filp)
 
 	/* done */
 	if (result)
-		hso_serial_tiocmset(tty, NULL, TIOCM_RTS | TIOCM_DTR, 0);
+		hso_serial_tiocmset(tty, TIOCM_RTS | TIOCM_DTR, 0);
 err_out:
 	mutex_unlock(&serial->parent->mutex);
 	return result;
@@ -1687,7 +1687,7 @@ static int hso_serial_tiocmget(struct tty_struct *tty)
 	return retval;
 }
 
-static int hso_serial_tiocmset(struct tty_struct *tty, struct file *file,
+static int hso_serial_tiocmset(struct tty_struct *tty,
 			       unsigned int set, unsigned int clear)
 {
 	int val = 0;
diff --git a/drivers/net/wan/pc300_tty.c b/drivers/net/wan/pc300_tty.c
index d999e54..1c65d1c 100644
--- a/drivers/net/wan/pc300_tty.c
+++ b/drivers/net/wan/pc300_tty.c
@@ -131,8 +131,7 @@ static void cpc_tty_trace(pc300dev_t *dev, char* buf, int len, char rxtx);
 static void cpc_tty_signal_off(pc300dev_t *pc300dev, unsigned char);
 static void cpc_tty_signal_on(pc300dev_t *pc300dev, unsigned char);
 
-static int pc300_tiocmset(struct tty_struct *, struct file *,
-			  unsigned int, unsigned int);
+static int pc300_tiocmset(struct tty_struct *, unsigned int, unsigned int);
 static int pc300_tiocmget(struct tty_struct *);
 
 /* functions called by PC300 driver */
@@ -543,7 +542,7 @@ static int cpc_tty_chars_in_buffer(struct tty_struct *tty)
 	return 0;
 } 
 
-static int pc300_tiocmset(struct tty_struct *tty, struct file *file,
+static int pc300_tiocmset(struct tty_struct *tty,
 			  unsigned int set, unsigned int clear)
 {
 	st_cpc_tty_area    *cpc_tty; 
diff --git a/drivers/staging/quatech_usb2/quatech_usb2.c b/drivers/staging/quatech_usb2/quatech_usb2.c
index 1e50292..3734448 100644
--- a/drivers/staging/quatech_usb2/quatech_usb2.c
+++ b/drivers/staging/quatech_usb2/quatech_usb2.c
@@ -1121,7 +1121,7 @@ static int qt2_tiocmget(struct tty_struct *tty)
 	}
 }
 
-static int qt2_tiocmset(struct tty_struct *tty, struct file *file,
+static int qt2_tiocmset(struct tty_struct *tty,
 		       unsigned int set, unsigned int clear)
 {
 	struct usb_serial_port *port = tty->driver_data;
diff --git a/drivers/staging/serqt_usb2/serqt_usb2.c b/drivers/staging/serqt_usb2/serqt_usb2.c
index 56ded56..39776c1 100644
--- a/drivers/staging/serqt_usb2/serqt_usb2.c
+++ b/drivers/staging/serqt_usb2/serqt_usb2.c
@@ -1425,7 +1425,6 @@ static inline int qt_real_tiocmget(struct tty_struct *tty,
 
 static inline int qt_real_tiocmset(struct tty_struct *tty,
 				   struct usb_serial_port *port,
-				   struct file *file,
 				   struct usb_serial *serial,
 				   unsigned int value)
 {
@@ -1486,7 +1485,7 @@ static int qt_tiocmget(struct tty_struct *tty)
 	return retval;
 }
 
-static int qt_tiocmset(struct tty_struct *tty, struct file *file,
+static int qt_tiocmset(struct tty_struct *tty,
 		       unsigned int set, unsigned int clear)
 {
 
@@ -1506,7 +1505,7 @@ static int qt_tiocmset(struct tty_struct *tty, struct file *file,
 	dbg("%s - port %d\n", __func__, port->number);
 	dbg("%s - qt_port->RxHolding = %d\n", __func__, qt_port->RxHolding);
 
-	retval = qt_real_tiocmset(tty, port, file, serial, set);
+	retval = qt_real_tiocmset(tty, port, serial, set);
 
 	spin_unlock_irqrestore(&qt_port->lock, flags);
 	return retval;
diff --git a/drivers/tty/hvc/hvsi.c b/drivers/tty/hvc/hvsi.c
index 5529310..8a8d637 100644
--- a/drivers/tty/hvc/hvsi.c
+++ b/drivers/tty/hvc/hvsi.c
@@ -1103,8 +1103,8 @@ static int hvsi_tiocmget(struct tty_struct *tty)
 	return hp->mctrl;
 }
 
-static int hvsi_tiocmset(struct tty_struct *tty, struct file *file,
-		unsigned int set, unsigned int clear)
+static int hvsi_tiocmset(struct tty_struct *tty,
+				unsigned int set, unsigned int clear)
 {
 	struct hvsi_struct *hp = tty->driver_data;
 	unsigned long flags;
diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index b73aba1..856d10e 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -2655,7 +2655,7 @@ static int gsmtty_tiocmget(struct tty_struct *tty)
 	return dlci->modem_rx;
 }
 
-static int gsmtty_tiocmset(struct tty_struct *tty, struct file *filp,
+static int gsmtty_tiocmset(struct tty_struct *tty,
 	unsigned int set, unsigned int clear)
 {
 	struct gsm_dlci *dlci = tty->driver_data;
diff --git a/drivers/tty/serial/68360serial.c b/drivers/tty/serial/68360serial.c
index 24a7f12..259cd2d 100644
--- a/drivers/tty/serial/68360serial.c
+++ b/drivers/tty/serial/68360serial.c
@@ -1271,7 +1271,7 @@ static int rs_360_tiocmget(struct tty_struct *tty)
 	return result;
 }
 
-static int rs_360_tiocmset(struct tty_struct *tty, struct file *file,
+static int rs_360_tiocmset(struct tty_struct *tty,
 			   unsigned int set, unsigned int clear)
 {
 #ifdef modem_control
diff --git a/drivers/tty/serial/crisv10.c b/drivers/tty/serial/crisv10.c
index 8cc5c02..b9fcd0b 100644
--- a/drivers/tty/serial/crisv10.c
+++ b/drivers/tty/serial/crisv10.c
@@ -3581,8 +3581,7 @@ rs_break(struct tty_struct *tty, int break_state)
 }
 
 static int
-rs_tiocmset(struct tty_struct *tty, struct file *file,
-		unsigned int set, unsigned int clear)
+rs_tiocmset(struct tty_struct *tty, unsigned int set, unsigned int clear)
 {
 	struct e100_serial *info = (struct e100_serial *)tty->driver_data;
 	unsigned long flags;
diff --git a/drivers/tty/serial/ifx6x60.c b/drivers/tty/serial/ifx6x60.c
index 99a546e..d7a6d5f 100644
--- a/drivers/tty/serial/ifx6x60.c
+++ b/drivers/tty/serial/ifx6x60.c
@@ -262,7 +262,6 @@ static int ifx_spi_tiocmget(struct tty_struct *tty)
 /**
  *	ifx_spi_tiocmset	-	set modem bits
  *	@tty: the tty structure
- *	@filp: file handle issuing the request
  *	@set: bits to set
  *	@clear: bits to clear
  *
@@ -271,7 +270,7 @@ static int ifx_spi_tiocmget(struct tty_struct *tty)
  *
  *	FIXME: do we need to kick the tranfers when we do this ?
  */
-static int ifx_spi_tiocmset(struct tty_struct *tty, struct file *filp,
+static int ifx_spi_tiocmset(struct tty_struct *tty,
 			    unsigned int set, unsigned int clear)
 {
 	struct ifx_spi_device *ifx_dev = tty->driver_data;
diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 53e490e..623d6bd 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -925,8 +925,7 @@ static int uart_tiocmget(struct tty_struct *tty)
 }
 
 static int
-uart_tiocmset(struct tty_struct *tty, struct file *file,
-	      unsigned int set, unsigned int clear)
+uart_tiocmset(struct tty_struct *tty, unsigned int set, unsigned int clear)
 {
 	struct uart_state *state = tty->driver_data;
 	struct uart_port *uport = state->uart_port;
@@ -934,8 +933,7 @@ uart_tiocmset(struct tty_struct *tty, struct file *file,
 	int ret = -EIO;
 
 	mutex_lock(&port->mutex);
-	if ((!file || !tty_hung_up_p(file)) &&
-	    !(tty->flags & (1 << TTY_IO_ERROR))) {
+	if (!(tty->flags & (1 << TTY_IO_ERROR))) {
 		uart_update_mctrl(uport, set, clear);
 		ret = 0;
 	}
diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index fde5a4d..83af24c 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -2481,7 +2481,6 @@ static int tty_tiocmget(struct tty_struct *tty, int __user *p)
 /**
  *	tty_tiocmset		-	set modem status
  *	@tty: tty device
- *	@file: user file pointer
  *	@cmd: command - clear bits, set bits or set all
  *	@p: pointer to desired bits
  *
@@ -2491,7 +2490,7 @@ static int tty_tiocmget(struct tty_struct *tty, int __user *p)
  *	Locking: none (up to the driver)
  */
 
-static int tty_tiocmset(struct tty_struct *tty, struct file *file, unsigned int cmd,
+static int tty_tiocmset(struct tty_struct *tty, unsigned int cmd,
 	     unsigned __user *p)
 {
 	int retval;
@@ -2518,7 +2517,7 @@ static int tty_tiocmset(struct tty_struct *tty, struct file *file, unsigned int
 	}
 	set &= TIOCM_DTR|TIOCM_RTS|TIOCM_OUT1|TIOCM_OUT2|TIOCM_LOOP;
 	clear &= TIOCM_DTR|TIOCM_RTS|TIOCM_OUT1|TIOCM_OUT2|TIOCM_LOOP;
-	return tty->ops->tiocmset(tty, file, set, clear);
+	return tty->ops->tiocmset(tty, set, clear);
 }
 
 static int tty_tiocgicount(struct tty_struct *tty, void __user *arg)
@@ -2659,7 +2658,7 @@ long tty_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	case TIOCMSET:
 	case TIOCMBIC:
 	case TIOCMBIS:
-		return tty_tiocmset(tty, file, cmd, p);
+		return tty_tiocmset(tty, cmd, p);
 	case TIOCGICOUNT:
 		retval = tty_tiocgicount(tty, p);
 		/* For the moment allow fall through to the old method */
diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index 844bb9d..5a68cef 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -791,7 +791,7 @@ static int acm_tty_tiocmget(struct tty_struct *tty)
 	       TIOCM_CTS;
 }
 
-static int acm_tty_tiocmset(struct tty_struct *tty, struct file *file,
+static int acm_tty_tiocmset(struct tty_struct *tty,
 			    unsigned int set, unsigned int clear)
 {
 	struct acm *acm = tty->driver_data;
diff --git a/drivers/usb/serial/ark3116.c b/drivers/usb/serial/ark3116.c
index 35b610a..2f837e9 100644
--- a/drivers/usb/serial/ark3116.c
+++ b/drivers/usb/serial/ark3116.c
@@ -511,7 +511,7 @@ static int ark3116_tiocmget(struct tty_struct *tty)
 		(ctrl   & UART_MCR_OUT2 ? TIOCM_OUT2 : 0);
 }
 
-static int ark3116_tiocmset(struct tty_struct *tty, struct file *file,
+static int ark3116_tiocmset(struct tty_struct *tty,
 			unsigned set, unsigned clr)
 {
 	struct usb_serial_port *port = tty->driver_data;
diff --git a/drivers/usb/serial/belkin_sa.c b/drivers/usb/serial/belkin_sa.c
index 48fb3ba..d6921fa 100644
--- a/drivers/usb/serial/belkin_sa.c
+++ b/drivers/usb/serial/belkin_sa.c
@@ -101,7 +101,7 @@ static void belkin_sa_set_termios(struct tty_struct *tty,
 			struct usb_serial_port *port, struct ktermios * old);
 static void belkin_sa_break_ctl(struct tty_struct *tty, int break_state);
 static int  belkin_sa_tiocmget(struct tty_struct *tty);
-static int  belkin_sa_tiocmset(struct tty_struct *tty, struct file *file,
+static int  belkin_sa_tiocmset(struct tty_struct *tty,
 					unsigned int set, unsigned int clear);
 
 
@@ -513,7 +513,7 @@ static int belkin_sa_tiocmget(struct tty_struct *tty)
 	return control_state;
 }
 
-static int belkin_sa_tiocmset(struct tty_struct *tty, struct file *file,
+static int belkin_sa_tiocmset(struct tty_struct *tty,
 			       unsigned int set, unsigned int clear)
 {
 	struct usb_serial_port *port = tty->driver_data;
diff --git a/drivers/usb/serial/ch341.c b/drivers/usb/serial/ch341.c
index aa0962b..5cbef31 100644
--- a/drivers/usb/serial/ch341.c
+++ b/drivers/usb/serial/ch341.c
@@ -431,7 +431,7 @@ out:
 	kfree(break_reg);
 }
 
-static int ch341_tiocmset(struct tty_struct *tty, struct file *file,
+static int ch341_tiocmset(struct tty_struct *tty,
 			  unsigned int set, unsigned int clear)
 {
 	struct usb_serial_port *port = tty->driver_data;
diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c
index b387381..4df3e0c 100644
--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -42,9 +42,8 @@ static void cp210x_get_termios_port(struct usb_serial_port *port,
 static void cp210x_set_termios(struct tty_struct *, struct usb_serial_port *,
 							struct ktermios*);
 static int cp210x_tiocmget(struct tty_struct *);
-static int cp210x_tiocmset(struct tty_struct *, struct file *,
-		unsigned int, unsigned int);
-static int cp210x_tiocmset_port(struct usb_serial_port *port, struct file *,
+static int cp210x_tiocmset(struct tty_struct *, unsigned int, unsigned int);
+static int cp210x_tiocmset_port(struct usb_serial_port *port,
 		unsigned int, unsigned int);
 static void cp210x_break_ctl(struct tty_struct *, int);
 static int cp210x_startup(struct usb_serial *);
@@ -698,14 +697,14 @@ static void cp210x_set_termios(struct tty_struct *tty,
 
 }
 
-static int cp210x_tiocmset (struct tty_struct *tty, struct file *file,
+static int cp210x_tiocmset (struct tty_struct *tty,
 		unsigned int set, unsigned int clear)
 {
 	struct usb_serial_port *port = tty->driver_data;
-	return cp210x_tiocmset_port(port, file, set, clear);
+	return cp210x_tiocmset_port(port, set, clear);
 }
 
-static int cp210x_tiocmset_port(struct usb_serial_port *port, struct file *file,
+static int cp210x_tiocmset_port(struct usb_serial_port *port,
 		unsigned int set, unsigned int clear)
 {
 	unsigned int control = 0;
@@ -737,9 +736,9 @@ static int cp210x_tiocmset_port(struct usb_serial_port *port, struct file *file,
 static void cp210x_dtr_rts(struct usb_serial_port *p, int on)
 {
 	if (on)
-		cp210x_tiocmset_port(p, NULL,  TIOCM_DTR|TIOCM_RTS, 0);
+		cp210x_tiocmset_port(p, TIOCM_DTR|TIOCM_RTS, 0);
 	else
-		cp210x_tiocmset_port(p, NULL,  0, TIOCM_DTR|TIOCM_RTS);
+		cp210x_tiocmset_port(p, 0, TIOCM_DTR|TIOCM_RTS);
 }
 
 static int cp210x_tiocmget (struct tty_struct *tty)
diff --git a/drivers/usb/serial/cypress_m8.c b/drivers/usb/serial/cypress_m8.c
index 9c96cff..2beb5a6 100644
--- a/drivers/usb/serial/cypress_m8.c
+++ b/drivers/usb/serial/cypress_m8.c
@@ -174,7 +174,7 @@ static int  cypress_ioctl(struct tty_struct *tty, struct file *file,
 static void cypress_set_termios(struct tty_struct *tty,
 			struct usb_serial_port *port, struct ktermios *old);
 static int  cypress_tiocmget(struct tty_struct *tty);
-static int  cypress_tiocmset(struct tty_struct *tty, struct file *file,
+static int  cypress_tiocmset(struct tty_struct *tty,
 			unsigned int set, unsigned int clear);
 static int  cypress_chars_in_buffer(struct tty_struct *tty);
 static void cypress_throttle(struct tty_struct *tty);
@@ -892,7 +892,7 @@ static int cypress_tiocmget(struct tty_struct *tty)
 }
 
 
-static int cypress_tiocmset(struct tty_struct *tty, struct file *file,
+static int cypress_tiocmset(struct tty_struct *tty,
 			       unsigned int set, unsigned int clear)
 {
 	struct usb_serial_port *port = tty->driver_data;
diff --git a/drivers/usb/serial/digi_acceleport.c b/drivers/usb/serial/digi_acceleport.c
index 08da46c..86fbba6 100644
--- a/drivers/usb/serial/digi_acceleport.c
+++ b/drivers/usb/serial/digi_acceleport.c
@@ -446,10 +446,10 @@ static void digi_set_termios(struct tty_struct *tty,
 		struct usb_serial_port *port, struct ktermios *old_termios);
 static void digi_break_ctl(struct tty_struct *tty, int break_state);
 static int digi_tiocmget(struct tty_struct *tty);
-static int digi_tiocmset(struct tty_struct *tty, struct file *file,
-	unsigned int set, unsigned int clear);
+static int digi_tiocmset(struct tty_struct *tty, unsigned int set,
+		unsigned int clear);
 static int digi_write(struct tty_struct *tty, struct usb_serial_port *port,
-	const unsigned char *buf, int count);
+		const unsigned char *buf, int count);
 static void digi_write_bulk_callback(struct urb *urb);
 static int digi_write_room(struct tty_struct *tty);
 static int digi_chars_in_buffer(struct tty_struct *tty);
@@ -1134,8 +1134,8 @@ static int digi_tiocmget(struct tty_struct *tty)
 }
 
 
-static int digi_tiocmset(struct tty_struct *tty, struct file *file,
-	unsigned int set, unsigned int clear)
+static int digi_tiocmset(struct tty_struct *tty,
+					unsigned int set, unsigned int clear)
 {
 	struct usb_serial_port *port = tty->driver_data;
 	struct digi_port *priv = usb_get_serial_port_data(port);
diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index f05bc53..de5f493 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -865,7 +865,7 @@ static int ftdi_prepare_write_buffer(struct usb_serial_port *port,
 static void ftdi_set_termios(struct tty_struct *tty,
 			struct usb_serial_port *port, struct ktermios *old);
 static int  ftdi_tiocmget(struct tty_struct *tty);
-static int  ftdi_tiocmset(struct tty_struct *tty, struct file *file,
+static int  ftdi_tiocmset(struct tty_struct *tty,
 			unsigned int set, unsigned int clear);
 static int  ftdi_ioctl(struct tty_struct *tty, struct file *file,
 			unsigned int cmd, unsigned long arg);
@@ -2229,7 +2229,7 @@ out:
 	return ret;
 }
 
-static int ftdi_tiocmset(struct tty_struct *tty, struct file *file,
+static int ftdi_tiocmset(struct tty_struct *tty,
 			unsigned int set, unsigned int clear)
 {
 	struct usb_serial_port *port = tty->driver_data;
diff --git a/drivers/usb/serial/io_edgeport.c b/drivers/usb/serial/io_edgeport.c
index c285e9b..a82649f 100644
--- a/drivers/usb/serial/io_edgeport.c
+++ b/drivers/usb/serial/io_edgeport.c
@@ -220,7 +220,7 @@ static int  edge_ioctl(struct tty_struct *tty, struct file *file,
 					unsigned int cmd, unsigned long arg);
 static void edge_break(struct tty_struct *tty, int break_state);
 static int  edge_tiocmget(struct tty_struct *tty);
-static int  edge_tiocmset(struct tty_struct *tty, struct file *file,
+static int  edge_tiocmset(struct tty_struct *tty,
 					unsigned int set, unsigned int clear);
 static int  edge_get_icount(struct tty_struct *tty,
 				struct serial_icounter_struct *icount);
@@ -1568,7 +1568,7 @@ static int get_lsr_info(struct edgeport_port *edge_port,
 	return 0;
 }
 
-static int edge_tiocmset(struct tty_struct *tty, struct file *file,
+static int edge_tiocmset(struct tty_struct *tty,
 					unsigned int set, unsigned int clear)
 {
 	struct usb_serial_port *port = tty->driver_data;
diff --git a/drivers/usb/serial/io_ti.c b/drivers/usb/serial/io_ti.c
index 7cb9f5c..8812052 100644
--- a/drivers/usb/serial/io_ti.c
+++ b/drivers/usb/serial/io_ti.c
@@ -2444,7 +2444,7 @@ static void edge_set_termios(struct tty_struct *tty,
 	change_port_settings(tty, edge_port, old_termios);
 }
 
-static int edge_tiocmset(struct tty_struct *tty, struct file *file,
+static int edge_tiocmset(struct tty_struct *tty,
 					unsigned int set, unsigned int clear)
 {
 	struct usb_serial_port *port = tty->driver_data;
diff --git a/drivers/usb/serial/iuu_phoenix.c b/drivers/usb/serial/iuu_phoenix.c
index 1d96142..6aca631 100644
--- a/drivers/usb/serial/iuu_phoenix.c
+++ b/drivers/usb/serial/iuu_phoenix.c
@@ -150,7 +150,7 @@ static void iuu_release(struct usb_serial *serial)
 	}
 }
 
-static int iuu_tiocmset(struct tty_struct *tty, struct file *file,
+static int iuu_tiocmset(struct tty_struct *tty,
 			unsigned int set, unsigned int clear)
 {
 	struct usb_serial_port *port = tty->driver_data;
diff --git a/drivers/usb/serial/keyspan.c b/drivers/usb/serial/keyspan.c
index 1beebbb..c6e968f 100644
--- a/drivers/usb/serial/keyspan.c
+++ b/drivers/usb/serial/keyspan.c
@@ -317,7 +317,7 @@ static int keyspan_tiocmget(struct tty_struct *tty)
 	return value;
 }
 
-static int keyspan_tiocmset(struct tty_struct *tty, struct file *file,
+static int keyspan_tiocmset(struct tty_struct *tty,
 			    unsigned int set, unsigned int clear)
 {
 	struct usb_serial_port *port = tty->driver_data;
diff --git a/drivers/usb/serial/keyspan.h b/drivers/usb/serial/keyspan.h
index 5e5fc71..13fa1d1 100644
--- a/drivers/usb/serial/keyspan.h
+++ b/drivers/usb/serial/keyspan.h
@@ -60,7 +60,7 @@ static void keyspan_break_ctl		(struct tty_struct *tty,
 					 int break_state);
 static int  keyspan_tiocmget		(struct tty_struct *tty);
 static int  keyspan_tiocmset		(struct tty_struct *tty,
-					 struct file *file, unsigned int set,
+					 unsigned int set,
 					 unsigned int clear);
 static int  keyspan_fake_startup	(struct usb_serial *serial);
 
diff --git a/drivers/usb/serial/keyspan_pda.c b/drivers/usb/serial/keyspan_pda.c
index 49ad2ba..207caab 100644
--- a/drivers/usb/serial/keyspan_pda.c
+++ b/drivers/usb/serial/keyspan_pda.c
@@ -478,7 +478,7 @@ static int keyspan_pda_tiocmget(struct tty_struct *tty)
 	return value;
 }
 
-static int keyspan_pda_tiocmset(struct tty_struct *tty, struct file *file,
+static int keyspan_pda_tiocmset(struct tty_struct *tty,
 				unsigned int set, unsigned int clear)
 {
 	struct usb_serial_port *port = tty->driver_data;
diff --git a/drivers/usb/serial/kl5kusb105.c b/drivers/usb/serial/kl5kusb105.c
index a570f52..19373cb 100644
--- a/drivers/usb/serial/kl5kusb105.c
+++ b/drivers/usb/serial/kl5kusb105.c
@@ -69,7 +69,7 @@ static void klsi_105_close(struct usb_serial_port *port);
 static void klsi_105_set_termios(struct tty_struct *tty,
 			struct usb_serial_port *port, struct ktermios *old);
 static int  klsi_105_tiocmget(struct tty_struct *tty);
-static int  klsi_105_tiocmset(struct tty_struct *tty, struct file *file,
+static int  klsi_105_tiocmset(struct tty_struct *tty,
 			unsigned int set, unsigned int clear);
 static void klsi_105_process_read_urb(struct urb *urb);
 static int klsi_105_prepare_write_buffer(struct usb_serial_port *port,
@@ -661,7 +661,7 @@ static int klsi_105_tiocmget(struct tty_struct *tty)
 	return (int)line_state;
 }
 
-static int klsi_105_tiocmset(struct tty_struct *tty, struct file *file,
+static int klsi_105_tiocmset(struct tty_struct *tty,
 			     unsigned int set, unsigned int clear)
 {
 	int retval = -EINVAL;
diff --git a/drivers/usb/serial/kobil_sct.c b/drivers/usb/serial/kobil_sct.c
index 81d07fb..22cd0c0 100644
--- a/drivers/usb/serial/kobil_sct.c
+++ b/drivers/usb/serial/kobil_sct.c
@@ -78,7 +78,7 @@ static int  kobil_write_room(struct tty_struct *tty);
 static int  kobil_ioctl(struct tty_struct *tty, struct file *file,
 			unsigned int cmd, unsigned long arg);
 static int  kobil_tiocmget(struct tty_struct *tty);
-static int  kobil_tiocmset(struct tty_struct *tty, struct file *file,
+static int  kobil_tiocmset(struct tty_struct *tty,
 			   unsigned int set, unsigned int clear);
 static void kobil_read_int_callback(struct urb *urb);
 static void kobil_write_callback(struct urb *purb);
@@ -544,7 +544,7 @@ static int kobil_tiocmget(struct tty_struct *tty)
 	return result;
 }
 
-static int kobil_tiocmset(struct tty_struct *tty, struct file *file,
+static int kobil_tiocmset(struct tty_struct *tty,
 			   unsigned int set, unsigned int clear)
 {
 	struct usb_serial_port *port = tty->driver_data;
diff --git a/drivers/usb/serial/mct_u232.c b/drivers/usb/serial/mct_u232.c
index 0cae206..d2c0196 100644
--- a/drivers/usb/serial/mct_u232.c
+++ b/drivers/usb/serial/mct_u232.c
@@ -104,7 +104,7 @@ static void mct_u232_set_termios(struct tty_struct *tty,
 			struct usb_serial_port *port, struct ktermios *old);
 static void mct_u232_break_ctl(struct tty_struct *tty, int break_state);
 static int  mct_u232_tiocmget(struct tty_struct *tty);
-static int  mct_u232_tiocmset(struct tty_struct *tty, struct file *file,
+static int  mct_u232_tiocmset(struct tty_struct *tty,
 			unsigned int set, unsigned int clear);
 static int  mct_u232_ioctl(struct tty_struct *tty, struct file *file,
 			unsigned int cmd, unsigned long arg);
@@ -806,7 +806,7 @@ static int mct_u232_tiocmget(struct tty_struct *tty)
 	return control_state;
 }
 
-static int mct_u232_tiocmset(struct tty_struct *tty, struct file *file,
+static int mct_u232_tiocmset(struct tty_struct *tty,
 			      unsigned int set, unsigned int clear)
 {
 	struct usb_serial_port *port = tty->driver_data;
diff --git a/drivers/usb/serial/mos7720.c b/drivers/usb/serial/mos7720.c
index 5d40d41..95b1c64 100644
--- a/drivers/usb/serial/mos7720.c
+++ b/drivers/usb/serial/mos7720.c
@@ -1858,7 +1858,7 @@ static int mos7720_tiocmget(struct tty_struct *tty)
 	return result;
 }
 
-static int mos7720_tiocmset(struct tty_struct *tty, struct file *file,
+static int mos7720_tiocmset(struct tty_struct *tty,
 			    unsigned int set, unsigned int clear)
 {
 	struct usb_serial_port *port = tty->driver_data;
diff --git a/drivers/usb/serial/mos7840.c b/drivers/usb/serial/mos7840.c
index ee0dc9a..9424178 100644
--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -1674,7 +1674,7 @@ static int mos7840_tiocmget(struct tty_struct *tty)
 	return result;
 }
 
-static int mos7840_tiocmset(struct tty_struct *tty, struct file *file,
+static int mos7840_tiocmset(struct tty_struct *tty,
 			    unsigned int set, unsigned int clear)
 {
 	struct usb_serial_port *port = tty->driver_data;
diff --git a/drivers/usb/serial/oti6858.c b/drivers/usb/serial/oti6858.c
index 4cd3b0e..63734cb 100644
--- a/drivers/usb/serial/oti6858.c
+++ b/drivers/usb/serial/oti6858.c
@@ -145,7 +145,7 @@ static int oti6858_write(struct tty_struct *tty, struct usb_serial_port *port,
 static int oti6858_write_room(struct tty_struct *tty);
 static int oti6858_chars_in_buffer(struct tty_struct *tty);
 static int oti6858_tiocmget(struct tty_struct *tty);
-static int oti6858_tiocmset(struct tty_struct *tty, struct file *file,
+static int oti6858_tiocmset(struct tty_struct *tty,
 				unsigned int set, unsigned int clear);
 static int oti6858_startup(struct usb_serial *serial);
 static void oti6858_release(struct usb_serial *serial);
@@ -624,7 +624,7 @@ static void oti6858_close(struct usb_serial_port *port)
 	usb_kill_urb(port->interrupt_in_urb);
 }
 
-static int oti6858_tiocmset(struct tty_struct *tty, struct file *file,
+static int oti6858_tiocmset(struct tty_struct *tty,
 				unsigned int set, unsigned int clear)
 {
 	struct usb_serial_port *port = tty->driver_data;
diff --git a/drivers/usb/serial/pl2303.c b/drivers/usb/serial/pl2303.c
index 6cb4f50..b797992 100644
--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -505,7 +505,7 @@ static int pl2303_open(struct tty_struct *tty, struct usb_serial_port *port)
 	return 0;
 }
 
-static int pl2303_tiocmset(struct tty_struct *tty, struct file *file,
+static int pl2303_tiocmset(struct tty_struct *tty,
 			   unsigned int set, unsigned int clear)
 {
 	struct usb_serial_port *port = tty->driver_data;
diff --git a/drivers/usb/serial/sierra.c b/drivers/usb/serial/sierra.c
index 66437f1..79ee6c7 100644
--- a/drivers/usb/serial/sierra.c
+++ b/drivers/usb/serial/sierra.c
@@ -408,7 +408,7 @@ static int sierra_tiocmget(struct tty_struct *tty)
 	return value;
 }
 
-static int sierra_tiocmset(struct tty_struct *tty, struct file *file,
+static int sierra_tiocmset(struct tty_struct *tty,
 			unsigned int set, unsigned int clear)
 {
 	struct usb_serial_port *port = tty->driver_data;
diff --git a/drivers/usb/serial/spcp8x5.c b/drivers/usb/serial/spcp8x5.c
index cac1300..dfbc543 100644
--- a/drivers/usb/serial/spcp8x5.c
+++ b/drivers/usb/serial/spcp8x5.c
@@ -595,7 +595,7 @@ static int spcp8x5_ioctl(struct tty_struct *tty, struct file *file,
 	return -ENOIOCTLCMD;
 }
 
-static int spcp8x5_tiocmset(struct tty_struct *tty, struct file *file,
+static int spcp8x5_tiocmset(struct tty_struct *tty,
 			    unsigned int set, unsigned int clear)
 {
 	struct usb_serial_port *port = tty->driver_data;
diff --git a/drivers/usb/serial/ssu100.c b/drivers/usb/serial/ssu100.c
index b21583f..abceee9 100644
--- a/drivers/usb/serial/ssu100.c
+++ b/drivers/usb/serial/ssu100.c
@@ -517,7 +517,7 @@ mget_out:
 	return r;
 }
 
-static int ssu100_tiocmset(struct tty_struct *tty, struct file *file,
+static int ssu100_tiocmset(struct tty_struct *tty,
 			   unsigned int set, unsigned int clear)
 {
 	struct usb_serial_port *port = tty->driver_data;
diff --git a/drivers/usb/serial/ti_usb_3410_5052.c b/drivers/usb/serial/ti_usb_3410_5052.c
index 7fa96dc..7bd89e1 100644
--- a/drivers/usb/serial/ti_usb_3410_5052.c
+++ b/drivers/usb/serial/ti_usb_3410_5052.c
@@ -113,7 +113,7 @@ static int ti_get_icount(struct tty_struct *tty,
 static void ti_set_termios(struct tty_struct *tty,
 		struct usb_serial_port *port, struct ktermios *old_termios);
 static int ti_tiocmget(struct tty_struct *tty);
-static int ti_tiocmset(struct tty_struct *tty, struct file *file,
+static int ti_tiocmset(struct tty_struct *tty,
 		unsigned int set, unsigned int clear);
 static void ti_break(struct tty_struct *tty, int break_state);
 static void ti_interrupt_callback(struct urb *urb);
@@ -1033,8 +1033,8 @@ static int ti_tiocmget(struct tty_struct *tty)
 }
 
 
-static int ti_tiocmset(struct tty_struct *tty, struct file *file,
-	unsigned int set, unsigned int clear)
+static int ti_tiocmset(struct tty_struct *tty,
+				unsigned int set, unsigned int clear)
 {
 	struct usb_serial_port *port = tty->driver_data;
 	struct ti_port *tport = usb_get_serial_port_data(port);
diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-serial.c
index df105c6..dab679e 100644
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -507,7 +507,7 @@ static int serial_tiocmget(struct tty_struct *tty)
 	return -EINVAL;
 }
 
-static int serial_tiocmset(struct tty_struct *tty, struct file *file,
+static int serial_tiocmset(struct tty_struct *tty,
 			    unsigned int set, unsigned int clear)
 {
 	struct usb_serial_port *port = tty->driver_data;
@@ -515,7 +515,7 @@ static int serial_tiocmset(struct tty_struct *tty, struct file *file,
 	dbg("%s - port %d", __func__, port->number);
 
 	if (port->serial->type->tiocmset)
-		return port->serial->type->tiocmset(tty, file, set, clear);
+		return port->serial->type->tiocmset(tty, set, clear);
 	return -EINVAL;
 }
 
diff --git a/drivers/usb/serial/usb-wwan.h b/drivers/usb/serial/usb-wwan.h
index 8b68fc7..4d65f1c 100644
--- a/drivers/usb/serial/usb-wwan.h
+++ b/drivers/usb/serial/usb-wwan.h
@@ -16,7 +16,7 @@ extern void usb_wwan_set_termios(struct tty_struct *tty,
 				 struct usb_serial_port *port,
 				 struct ktermios *old);
 extern int usb_wwan_tiocmget(struct tty_struct *tty);
-extern int usb_wwan_tiocmset(struct tty_struct *tty, struct file *file,
+extern int usb_wwan_tiocmset(struct tty_struct *tty,
 			     unsigned int set, unsigned int clear);
 extern int usb_wwan_ioctl(struct tty_struct *tty, struct file *file,
 			  unsigned int cmd, unsigned long arg);
diff --git a/drivers/usb/serial/usb_wwan.c b/drivers/usb/serial/usb_wwan.c
index 60f9426..b729120 100644
--- a/drivers/usb/serial/usb_wwan.c
+++ b/drivers/usb/serial/usb_wwan.c
@@ -98,7 +98,7 @@ int usb_wwan_tiocmget(struct tty_struct *tty)
 }
 EXPORT_SYMBOL(usb_wwan_tiocmget);
 
-int usb_wwan_tiocmset(struct tty_struct *tty, struct file *file,
+int usb_wwan_tiocmset(struct tty_struct *tty,
 		      unsigned int set, unsigned int clear)
 {
 	struct usb_serial_port *port = tty->driver_data;
diff --git a/drivers/usb/serial/whiteheat.c b/drivers/usb/serial/whiteheat.c
index bf85013..6e0c397 100644
--- a/drivers/usb/serial/whiteheat.c
+++ b/drivers/usb/serial/whiteheat.c
@@ -157,7 +157,7 @@ static int  whiteheat_ioctl(struct tty_struct *tty, struct file *file,
 static void whiteheat_set_termios(struct tty_struct *tty,
 			struct usb_serial_port *port, struct ktermios *old);
 static int  whiteheat_tiocmget(struct tty_struct *tty);
-static int  whiteheat_tiocmset(struct tty_struct *tty, struct file *file,
+static int  whiteheat_tiocmset(struct tty_struct *tty,
 			unsigned int set, unsigned int clear);
 static void whiteheat_break_ctl(struct tty_struct *tty, int break_state);
 static int  whiteheat_chars_in_buffer(struct tty_struct *tty);
@@ -850,7 +850,7 @@ static int whiteheat_tiocmget(struct tty_struct *tty)
 	return modem_signals;
 }
 
-static int whiteheat_tiocmset(struct tty_struct *tty, struct file *file,
+static int whiteheat_tiocmset(struct tty_struct *tty,
 			       unsigned int set, unsigned int clear)
 {
 	struct usb_serial_port *port = tty->driver_data;
diff --git a/include/linux/tty_driver.h b/include/linux/tty_driver.h
index 9539d74..5dabaa2 100644
--- a/include/linux/tty_driver.h
+++ b/include/linux/tty_driver.h
@@ -272,7 +272,7 @@ struct tty_operations {
 	void (*wait_until_sent)(struct tty_struct *tty, int timeout);
 	void (*send_xchar)(struct tty_struct *tty, char ch);
 	int (*tiocmget)(struct tty_struct *tty);
-	int (*tiocmset)(struct tty_struct *tty, struct file *file,
+	int (*tiocmset)(struct tty_struct *tty,
 			unsigned int set, unsigned int clear);
 	int (*resize)(struct tty_struct *tty, struct winsize *ws);
 	int (*set_termiox)(struct tty_struct *tty, struct termiox *tnew);
diff --git a/include/linux/usb/serial.h b/include/linux/usb/serial.h
index 30b9453..c1aa1b2 100644
--- a/include/linux/usb/serial.h
+++ b/include/linux/usb/serial.h
@@ -269,7 +269,7 @@ struct usb_serial_driver {
 	void (*throttle)(struct tty_struct *tty);
 	void (*unthrottle)(struct tty_struct *tty);
 	int  (*tiocmget)(struct tty_struct *tty);
-	int  (*tiocmset)(struct tty_struct *tty, struct file *file,
+	int  (*tiocmset)(struct tty_struct *tty,
 			 unsigned int set, unsigned int clear);
 	int  (*get_icount)(struct tty_struct *tty,
 			struct serial_icounter_struct *icount);
diff --git a/include/net/irda/ircomm_tty.h b/include/net/irda/ircomm_tty.h
index fa3793b..980ccb6 100644
--- a/include/net/irda/ircomm_tty.h
+++ b/include/net/irda/ircomm_tty.h
@@ -121,7 +121,7 @@ void ircomm_tty_start(struct tty_struct *tty);
 void ircomm_tty_check_modem_status(struct ircomm_tty_cb *self);
 
 extern int ircomm_tty_tiocmget(struct tty_struct *tty);
-extern int ircomm_tty_tiocmset(struct tty_struct *tty, struct file *file,
+extern int ircomm_tty_tiocmset(struct tty_struct *tty,
 			       unsigned int set, unsigned int clear);
 extern int ircomm_tty_ioctl(struct tty_struct *tty, struct file *file, 
 			    unsigned int cmd, unsigned long arg);
diff --git a/net/bluetooth/rfcomm/tty.c b/net/bluetooth/rfcomm/tty.c
index 7f67fa4..8e78e74 100644
--- a/net/bluetooth/rfcomm/tty.c
+++ b/net/bluetooth/rfcomm/tty.c
@@ -1098,7 +1098,7 @@ static int rfcomm_tty_tiocmget(struct tty_struct *tty)
 	return dev->modem_status;
 }
 
-static int rfcomm_tty_tiocmset(struct tty_struct *tty, struct file *filp, unsigned int set, unsigned int clear)
+static int rfcomm_tty_tiocmset(struct tty_struct *tty, unsigned int set, unsigned int clear)
 {
 	struct rfcomm_dev *dev = (struct rfcomm_dev *) tty->driver_data;
 	struct rfcomm_dlc *dlc = dev->dlc;
diff --git a/net/irda/ircomm/ircomm_tty_ioctl.c b/net/irda/ircomm/ircomm_tty_ioctl.c
index bb47cae..5e0e718 100644
--- a/net/irda/ircomm/ircomm_tty_ioctl.c
+++ b/net/irda/ircomm/ircomm_tty_ioctl.c
@@ -214,12 +214,12 @@ int ircomm_tty_tiocmget(struct tty_struct *tty)
 }
 
 /*
- * Function ircomm_tty_tiocmset (tty, file, set, clear)
+ * Function ircomm_tty_tiocmset (tty, set, clear)
  *
  *
  *
  */
-int ircomm_tty_tiocmset(struct tty_struct *tty, struct file *file,
+int ircomm_tty_tiocmset(struct tty_struct *tty,
 			unsigned int set, unsigned int clear)
 {
 	struct ircomm_tty_cb *self = (struct ircomm_tty_cb *) tty->driver_data;

