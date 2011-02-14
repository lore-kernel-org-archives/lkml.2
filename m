Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198Ab1BNQ4b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 11:56:31 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:59839 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756037Ab1BNQ42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 11:56:28 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 3/6] tty: remove filp from the USB tty ioctls
To: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 14 Feb 2011 16:27:06 +0000
Message-ID: <20110214162701.10571.44591.stgit@bob.linux.org.uk>
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

We don't use it so we can trim it from here as we try and stamp the file
object dependencies out of the serial code.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/quatech_usb2/quatech_usb2.c |    2 +-
 drivers/staging/serqt_usb2/serqt_usb2.c     |    2 +-
 drivers/usb/serial/ark3116.c                |    2 +-
 drivers/usb/serial/ch341.c                  |    3 +--
 drivers/usb/serial/cypress_m8.c             |    4 ++--
 drivers/usb/serial/ftdi_sio.c               |    4 ++--
 drivers/usb/serial/io_edgeport.c            |    4 ++--
 drivers/usb/serial/io_ti.c                  |    2 +-
 drivers/usb/serial/kobil_sct.c              |    4 ++--
 drivers/usb/serial/mct_u232.c               |    4 ++--
 drivers/usb/serial/mos7720.c                |    2 +-
 drivers/usb/serial/mos7840.c                |    2 +-
 drivers/usb/serial/opticon.c                |    2 +-
 drivers/usb/serial/oti6858.c                |    4 ++--
 drivers/usb/serial/pl2303.c                 |    2 +-
 drivers/usb/serial/spcp8x5.c                |    2 +-
 drivers/usb/serial/ssu100.c                 |    2 +-
 drivers/usb/serial/ti_usb_3410_5052.c       |    4 ++--
 drivers/usb/serial/usb-serial.c             |    2 +-
 drivers/usb/serial/usb-wwan.h               |    2 +-
 drivers/usb/serial/usb_wwan.c               |    2 +-
 drivers/usb/serial/whiteheat.c              |    4 ++--
 include/linux/usb/serial.h                  |    2 +-
 23 files changed, 31 insertions(+), 32 deletions(-)


diff --git a/drivers/staging/quatech_usb2/quatech_usb2.c b/drivers/staging/quatech_usb2/quatech_usb2.c
index 3734448..36b18e3 100644
--- a/drivers/staging/quatech_usb2/quatech_usb2.c
+++ b/drivers/staging/quatech_usb2/quatech_usb2.c
@@ -852,7 +852,7 @@ static int qt2_chars_in_buffer(struct tty_struct *tty)
  * TIOCMGET and TIOCMSET are filtered off to their own methods before they get
  * here, so we don't have to handle them.
  */
-static int qt2_ioctl(struct tty_struct *tty, struct file *file,
+static int qt2_ioctl(struct tty_struct *tty,
 		     unsigned int cmd, unsigned long arg)
 {
 	struct usb_serial_port *port = tty->driver_data;
diff --git a/drivers/staging/serqt_usb2/serqt_usb2.c b/drivers/staging/serqt_usb2/serqt_usb2.c
index 39776c1..e0aae86 100644
--- a/drivers/staging/serqt_usb2/serqt_usb2.c
+++ b/drivers/staging/serqt_usb2/serqt_usb2.c
@@ -1191,7 +1191,7 @@ static int qt_write_room(struct tty_struct *tty)
 
 }
 
-static int qt_ioctl(struct tty_struct *tty, struct file *file,
+static int qt_ioctl(struct tty_struct *tty,
 		    unsigned int cmd, unsigned long arg)
 {
 	struct usb_serial_port *port = tty->driver_data;
diff --git a/drivers/usb/serial/ark3116.c b/drivers/usb/serial/ark3116.c
index 2f837e9..5cdb9d9 100644
--- a/drivers/usb/serial/ark3116.c
+++ b/drivers/usb/serial/ark3116.c
@@ -431,7 +431,7 @@ static int ark3116_get_icount(struct tty_struct *tty,
 	return 0;
 }
 
-static int ark3116_ioctl(struct tty_struct *tty, struct file *file,
+static int ark3116_ioctl(struct tty_struct *tty,
 			 unsigned int cmd, unsigned long arg)
 {
 	struct usb_serial_port *port = tty->driver_data;
diff --git a/drivers/usb/serial/ch341.c b/drivers/usb/serial/ch341.c
index 5cbef31..d0b9fea 100644
--- a/drivers/usb/serial/ch341.c
+++ b/drivers/usb/serial/ch341.c
@@ -552,8 +552,7 @@ static int wait_modem_info(struct usb_serial_port *port, unsigned int arg)
 	return 0;
 }
 
-/*static int ch341_ioctl(struct usb_serial_port *port, struct file *file,*/
-static int ch341_ioctl(struct tty_struct *tty, struct file *file,
+static int ch341_ioctl(struct tty_struct *tty,
 			unsigned int cmd, unsigned long arg)
 {
 	struct usb_serial_port *port = tty->driver_data;
diff --git a/drivers/usb/serial/cypress_m8.c b/drivers/usb/serial/cypress_m8.c
index 2beb5a6..987e9bf 100644
--- a/drivers/usb/serial/cypress_m8.c
+++ b/drivers/usb/serial/cypress_m8.c
@@ -169,7 +169,7 @@ static int  cypress_write(struct tty_struct *tty, struct usb_serial_port *port,
 			const unsigned char *buf, int count);
 static void cypress_send(struct usb_serial_port *port);
 static int  cypress_write_room(struct tty_struct *tty);
-static int  cypress_ioctl(struct tty_struct *tty, struct file *file,
+static int  cypress_ioctl(struct tty_struct *tty,
 			unsigned int cmd, unsigned long arg);
 static void cypress_set_termios(struct tty_struct *tty,
 			struct usb_serial_port *port, struct ktermios *old);
@@ -917,7 +917,7 @@ static int cypress_tiocmset(struct tty_struct *tty,
 }
 
 
-static int cypress_ioctl(struct tty_struct *tty, struct file *file,
+static int cypress_ioctl(struct tty_struct *tty,
 					unsigned int cmd, unsigned long arg)
 {
 	struct usb_serial_port *port = tty->driver_data;
diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index de5f493..c0ccb4a 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -867,7 +867,7 @@ static void ftdi_set_termios(struct tty_struct *tty,
 static int  ftdi_tiocmget(struct tty_struct *tty);
 static int  ftdi_tiocmset(struct tty_struct *tty,
 			unsigned int set, unsigned int clear);
-static int  ftdi_ioctl(struct tty_struct *tty, struct file *file,
+static int  ftdi_ioctl(struct tty_struct *tty,
 			unsigned int cmd, unsigned long arg);
 static void ftdi_break_ctl(struct tty_struct *tty, int break_state);
 
@@ -2237,7 +2237,7 @@ static int ftdi_tiocmset(struct tty_struct *tty,
 	return update_mctrl(port, set, clear);
 }
 
-static int ftdi_ioctl(struct tty_struct *tty, struct file *file,
+static int ftdi_ioctl(struct tty_struct *tty,
 					unsigned int cmd, unsigned long arg)
 {
 	struct usb_serial_port *port = tty->driver_data;
diff --git a/drivers/usb/serial/io_edgeport.c b/drivers/usb/serial/io_edgeport.c
index a82649f..c675a32 100644
--- a/drivers/usb/serial/io_edgeport.c
+++ b/drivers/usb/serial/io_edgeport.c
@@ -216,7 +216,7 @@ static void edge_unthrottle(struct tty_struct *tty);
 static void edge_set_termios(struct tty_struct *tty,
 					struct usb_serial_port *port,
 					struct ktermios *old_termios);
-static int  edge_ioctl(struct tty_struct *tty, struct file *file,
+static int  edge_ioctl(struct tty_struct *tty,
 					unsigned int cmd, unsigned long arg);
 static void edge_break(struct tty_struct *tty, int break_state);
 static int  edge_tiocmget(struct tty_struct *tty);
@@ -1679,7 +1679,7 @@ static int get_serial_info(struct edgeport_port *edge_port,
  * SerialIoctl
  *	this function handles any ioctl calls to the driver
  *****************************************************************************/
-static int edge_ioctl(struct tty_struct *tty, struct file *file,
+static int edge_ioctl(struct tty_struct *tty,
 					unsigned int cmd, unsigned long arg)
 {
 	struct usb_serial_port *port = tty->driver_data;
diff --git a/drivers/usb/serial/io_ti.c b/drivers/usb/serial/io_ti.c
index 8812052..d843491 100644
--- a/drivers/usb/serial/io_ti.c
+++ b/drivers/usb/serial/io_ti.c
@@ -2552,7 +2552,7 @@ static int get_serial_info(struct edgeport_port *edge_port,
 	return 0;
 }
 
-static int edge_ioctl(struct tty_struct *tty, struct file *file,
+static int edge_ioctl(struct tty_struct *tty,
 					unsigned int cmd, unsigned long arg)
 {
 	struct usb_serial_port *port = tty->driver_data;
diff --git a/drivers/usb/serial/kobil_sct.c b/drivers/usb/serial/kobil_sct.c
index 22cd0c0..667863e 100644
--- a/drivers/usb/serial/kobil_sct.c
+++ b/drivers/usb/serial/kobil_sct.c
@@ -75,7 +75,7 @@ static void kobil_close(struct usb_serial_port *port);
 static int  kobil_write(struct tty_struct *tty, struct usb_serial_port *port,
 			 const unsigned char *buf, int count);
 static int  kobil_write_room(struct tty_struct *tty);
-static int  kobil_ioctl(struct tty_struct *tty, struct file *file,
+static int  kobil_ioctl(struct tty_struct *tty,
 			unsigned int cmd, unsigned long arg);
 static int  kobil_tiocmget(struct tty_struct *tty);
 static int  kobil_tiocmset(struct tty_struct *tty,
@@ -668,7 +668,7 @@ static void kobil_set_termios(struct tty_struct *tty,
 		);
 }
 
-static int kobil_ioctl(struct tty_struct *tty, struct file *file,
+static int kobil_ioctl(struct tty_struct *tty,
 					unsigned int cmd, unsigned long arg)
 {
 	struct usb_serial_port *port = tty->driver_data;
diff --git a/drivers/usb/serial/mct_u232.c b/drivers/usb/serial/mct_u232.c
index d2c0196..ba0d287 100644
--- a/drivers/usb/serial/mct_u232.c
+++ b/drivers/usb/serial/mct_u232.c
@@ -106,7 +106,7 @@ static void mct_u232_break_ctl(struct tty_struct *tty, int break_state);
 static int  mct_u232_tiocmget(struct tty_struct *tty);
 static int  mct_u232_tiocmset(struct tty_struct *tty,
 			unsigned int set, unsigned int clear);
-static int  mct_u232_ioctl(struct tty_struct *tty, struct file *file,
+static int  mct_u232_ioctl(struct tty_struct *tty,
 			unsigned int cmd, unsigned long arg);
 static int  mct_u232_get_icount(struct tty_struct *tty,
 			struct serial_icounter_struct *icount);
@@ -874,7 +874,7 @@ static void mct_u232_unthrottle(struct tty_struct *tty)
 	}
 }
 
-static int  mct_u232_ioctl(struct tty_struct *tty, struct file *file,
+static int  mct_u232_ioctl(struct tty_struct *tty,
 			unsigned int cmd, unsigned long arg)
 {
 	DEFINE_WAIT(wait);
diff --git a/drivers/usb/serial/mos7720.c b/drivers/usb/serial/mos7720.c
index 95b1c64..d8b3e8f 100644
--- a/drivers/usb/serial/mos7720.c
+++ b/drivers/usb/serial/mos7720.c
@@ -1987,7 +1987,7 @@ static int get_serial_info(struct moschip_port *mos7720_port,
 	return 0;
 }
 
-static int mos7720_ioctl(struct tty_struct *tty, struct file *file,
+static int mos7720_ioctl(struct tty_struct *tty,
 			 unsigned int cmd, unsigned long arg)
 {
 	struct usb_serial_port *port = tty->driver_data;
diff --git a/drivers/usb/serial/mos7840.c b/drivers/usb/serial/mos7840.c
index 9424178..7b50aa1 100644
--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -2235,7 +2235,7 @@ static int mos7840_get_icount(struct tty_struct *tty,
  *	this function handles any ioctl calls to the driver
  *****************************************************************************/
 
-static int mos7840_ioctl(struct tty_struct *tty, struct file *file,
+static int mos7840_ioctl(struct tty_struct *tty,
 			 unsigned int cmd, unsigned long arg)
 {
 	struct usb_serial_port *port = tty->driver_data;
diff --git a/drivers/usb/serial/opticon.c b/drivers/usb/serial/opticon.c
index e305df8..8d603a1 100644
--- a/drivers/usb/serial/opticon.c
+++ b/drivers/usb/serial/opticon.c
@@ -396,7 +396,7 @@ static int get_serial_info(struct opticon_private *priv,
 	return 0;
 }
 
-static int opticon_ioctl(struct tty_struct *tty, struct file *file,
+static int opticon_ioctl(struct tty_struct *tty,
 			 unsigned int cmd, unsigned long arg)
 {
 	struct usb_serial_port *port = tty->driver_data;
diff --git a/drivers/usb/serial/oti6858.c b/drivers/usb/serial/oti6858.c
index 63734cb..4c29e6c 100644
--- a/drivers/usb/serial/oti6858.c
+++ b/drivers/usb/serial/oti6858.c
@@ -135,7 +135,7 @@ static void oti6858_close(struct usb_serial_port *port);
 static void oti6858_set_termios(struct tty_struct *tty,
 			struct usb_serial_port *port, struct ktermios *old);
 static void oti6858_init_termios(struct tty_struct *tty);
-static int oti6858_ioctl(struct tty_struct *tty, struct file *file,
+static int oti6858_ioctl(struct tty_struct *tty,
 			unsigned int cmd, unsigned long arg);
 static void oti6858_read_int_callback(struct urb *urb);
 static void oti6858_read_bulk_callback(struct urb *urb);
@@ -728,7 +728,7 @@ static int wait_modem_info(struct usb_serial_port *port, unsigned int arg)
 	return 0;
 }
 
-static int oti6858_ioctl(struct tty_struct *tty, struct file *file,
+static int oti6858_ioctl(struct tty_struct *tty,
 			unsigned int cmd, unsigned long arg)
 {
 	struct usb_serial_port *port = tty->driver_data;
diff --git a/drivers/usb/serial/pl2303.c b/drivers/usb/serial/pl2303.c
index b797992..30461fc 100644
--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -606,7 +606,7 @@ static int wait_modem_info(struct usb_serial_port *port, unsigned int arg)
 	return 0;
 }
 
-static int pl2303_ioctl(struct tty_struct *tty, struct file *file,
+static int pl2303_ioctl(struct tty_struct *tty,
 			unsigned int cmd, unsigned long arg)
 {
 	struct serial_struct ser;
diff --git a/drivers/usb/serial/spcp8x5.c b/drivers/usb/serial/spcp8x5.c
index dfbc543..180ea6c 100644
--- a/drivers/usb/serial/spcp8x5.c
+++ b/drivers/usb/serial/spcp8x5.c
@@ -576,7 +576,7 @@ static int spcp8x5_wait_modem_info(struct usb_serial_port *port,
 	return 0;
 }
 
-static int spcp8x5_ioctl(struct tty_struct *tty, struct file *file,
+static int spcp8x5_ioctl(struct tty_struct *tty,
 			 unsigned int cmd, unsigned long arg)
 {
 	struct usb_serial_port *port = tty->driver_data;
diff --git a/drivers/usb/serial/ssu100.c b/drivers/usb/serial/ssu100.c
index abceee9..87362e4 100644
--- a/drivers/usb/serial/ssu100.c
+++ b/drivers/usb/serial/ssu100.c
@@ -439,7 +439,7 @@ static int ssu100_get_icount(struct tty_struct *tty,
 
 
 
-static int ssu100_ioctl(struct tty_struct *tty, struct file *file,
+static int ssu100_ioctl(struct tty_struct *tty,
 		    unsigned int cmd, unsigned long arg)
 {
 	struct usb_serial_port *port = tty->driver_data;
diff --git a/drivers/usb/serial/ti_usb_3410_5052.c b/drivers/usb/serial/ti_usb_3410_5052.c
index 7bd89e1..c6d92a5 100644
--- a/drivers/usb/serial/ti_usb_3410_5052.c
+++ b/drivers/usb/serial/ti_usb_3410_5052.c
@@ -106,7 +106,7 @@ static int ti_write_room(struct tty_struct *tty);
 static int ti_chars_in_buffer(struct tty_struct *tty);
 static void ti_throttle(struct tty_struct *tty);
 static void ti_unthrottle(struct tty_struct *tty);
-static int ti_ioctl(struct tty_struct *tty, struct file *file,
+static int ti_ioctl(struct tty_struct *tty,
 		unsigned int cmd, unsigned long arg);
 static int ti_get_icount(struct tty_struct *tty,
 		struct serial_icounter_struct *icount);
@@ -818,7 +818,7 @@ static int ti_get_icount(struct tty_struct *tty,
 	return 0;
 }
 
-static int ti_ioctl(struct tty_struct *tty, struct file *file,
+static int ti_ioctl(struct tty_struct *tty,
 	unsigned int cmd, unsigned long arg)
 {
 	struct usb_serial_port *port = tty->driver_data;
diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-serial.c
index dab679e..b1110e1 100644
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -417,7 +417,7 @@ static int serial_ioctl(struct tty_struct *tty, struct file *file,
 	/* pass on to the driver specific version of this function
 	   if it is available */
 	if (port->serial->type->ioctl) {
-		retval = port->serial->type->ioctl(tty, file, cmd, arg);
+		retval = port->serial->type->ioctl(tty, cmd, arg);
 	} else
 		retval = -ENOIOCTLCMD;
 	return retval;
diff --git a/drivers/usb/serial/usb-wwan.h b/drivers/usb/serial/usb-wwan.h
index 4d65f1c..c47b6ec 100644
--- a/drivers/usb/serial/usb-wwan.h
+++ b/drivers/usb/serial/usb-wwan.h
@@ -18,7 +18,7 @@ extern void usb_wwan_set_termios(struct tty_struct *tty,
 extern int usb_wwan_tiocmget(struct tty_struct *tty);
 extern int usb_wwan_tiocmset(struct tty_struct *tty,
 			     unsigned int set, unsigned int clear);
-extern int usb_wwan_ioctl(struct tty_struct *tty, struct file *file,
+extern int usb_wwan_ioctl(struct tty_struct *tty,
 			  unsigned int cmd, unsigned long arg);
 extern int usb_wwan_send_setup(struct usb_serial_port *port);
 extern int usb_wwan_write(struct tty_struct *tty, struct usb_serial_port *port,
diff --git a/drivers/usb/serial/usb_wwan.c b/drivers/usb/serial/usb_wwan.c
index b729120..b38d77b 100644
--- a/drivers/usb/serial/usb_wwan.c
+++ b/drivers/usb/serial/usb_wwan.c
@@ -178,7 +178,7 @@ static int set_serial_info(struct usb_serial_port *port,
 	return retval;
 }
 
-int usb_wwan_ioctl(struct tty_struct *tty, struct file *file,
+int usb_wwan_ioctl(struct tty_struct *tty,
 		   unsigned int cmd, unsigned long arg)
 {
 	struct usb_serial_port *port = tty->driver_data;
diff --git a/drivers/usb/serial/whiteheat.c b/drivers/usb/serial/whiteheat.c
index 6e0c397..5b073bc 100644
--- a/drivers/usb/serial/whiteheat.c
+++ b/drivers/usb/serial/whiteheat.c
@@ -152,7 +152,7 @@ static int  whiteheat_write(struct tty_struct *tty,
 			struct usb_serial_port *port,
 			const unsigned char *buf, int count);
 static int  whiteheat_write_room(struct tty_struct *tty);
-static int  whiteheat_ioctl(struct tty_struct *tty, struct file *file,
+static int  whiteheat_ioctl(struct tty_struct *tty,
 			unsigned int cmd, unsigned long arg);
 static void whiteheat_set_termios(struct tty_struct *tty,
 			struct usb_serial_port *port, struct ktermios *old);
@@ -874,7 +874,7 @@ static int whiteheat_tiocmset(struct tty_struct *tty,
 }
 
 
-static int whiteheat_ioctl(struct tty_struct *tty, struct file *file,
+static int whiteheat_ioctl(struct tty_struct *tty,
 					unsigned int cmd, unsigned long arg)
 {
 	struct usb_serial_port *port = tty->driver_data;
diff --git a/include/linux/usb/serial.h b/include/linux/usb/serial.h
index c1aa1b2..00e98ee 100644
--- a/include/linux/usb/serial.h
+++ b/include/linux/usb/serial.h
@@ -260,7 +260,7 @@ struct usb_serial_driver {
 			const unsigned char *buf, int count);
 	/* Called only by the tty layer */
 	int  (*write_room)(struct tty_struct *tty);
-	int  (*ioctl)(struct tty_struct *tty, struct file *file,
+	int  (*ioctl)(struct tty_struct *tty,
 		      unsigned int cmd, unsigned long arg);
 	void (*set_termios)(struct tty_struct *tty,
 			struct usb_serial_port *port, struct ktermios *old);

