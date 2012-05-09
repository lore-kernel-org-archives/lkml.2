Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759261Ab2EINKG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 09:10:06 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53446 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759078Ab2EINKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 09:10:04 -0400
From: Ben Minerds <puzzleduck@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ben Minerds <puzzleduck@gmail.com>
Subject: [PATCH 1/1] USB: serial: Whitespace and formatting to conform with checkpatch.sh script
Date: Wed,  9 May 2012 23:11:50 +1000
Message-Id: <1336569110-12835-1-git-send-email-puzzleduck@gmail.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed 19 errors and 53 warnings (space before tabs, spaces required
around '?' ':' '=', space prohibited '(', trailing whitespace, not a
function, and parentheses are not required).

Signed-off-by: Ben Minerds <puzzleduck@gmail.com>
Authored-by: Ben Minerds <puzzleduck@gmail.com>
---
 drivers/usb/serial/keyspan.c |  134 +++++++++++++++++++++---------------------
 1 files changed, 67 insertions(+), 67 deletions(-)

diff --git a/drivers/usb/serial/keyspan.c b/drivers/usb/serial/keyspan.c
index a39ddd1..677e70a 100644
--- a/drivers/usb/serial/keyspan.c
+++ b/drivers/usb/serial/keyspan.c
@@ -135,7 +135,7 @@ module_usb_serial_driver(keyspan_driver, serial_drivers);
 static void keyspan_break_ctl(struct tty_struct *tty, int break_state)
 {
 	struct usb_serial_port *port = tty->driver_data;
-	struct keyspan_port_private 	*p_priv;
+	struct keyspan_port_private	*p_priv;
 
 	dbg("%s", __func__);
 
@@ -154,9 +154,9 @@ static void keyspan_set_termios(struct tty_struct *tty,
 		struct usb_serial_port *port, struct ktermios *old_termios)
 {
 	int				baud_rate, device_port;
-	struct keyspan_port_private 	*p_priv;
+	struct keyspan_port_private	*p_priv;
 	const struct keyspan_device_details	*d_details;
-	unsigned int 			cflag;
+	unsigned int			cflag;
 
 	dbg("%s", __func__);
 
@@ -180,7 +180,7 @@ static void keyspan_set_termios(struct tty_struct *tty,
 	tty_encode_baud_rate(tty, baud_rate, baud_rate);
 	/* set CTS/RTS handshake etc. */
 	p_priv->cflag = cflag;
-	p_priv->flow_control = (cflag & CRTSCTS)? flow_cts: flow_none;
+	p_priv->flow_control = (cflag & CRTSCTS) ? flow_cts : flow_none;
 
 	/* Mark/Space not supported */
 	tty->termios->c_cflag &= ~CMSPAR;
@@ -227,12 +227,12 @@ static int keyspan_tiocmset(struct tty_struct *tty,
 static int keyspan_write(struct tty_struct *tty,
 	struct usb_serial_port *port, const unsigned char *buf, int count)
 {
-	struct keyspan_port_private 	*p_priv;
+	struct keyspan_port_private	*p_priv;
 	const struct keyspan_device_details	*d_details;
 	int				flip;
-	int 				left, todo;
+	int				left, todo;
 	struct urb			*this_urb;
-	int 				err, maxDataLen, dataOffset;
+	int				err, maxDataLen, dataOffset;
 
 	p_priv = usb_get_serial_port_data(port);
 	d_details = p_priv->device_details;
@@ -303,7 +303,7 @@ static void	usa26_indat_callback(struct urb *urb)
 	int			endpoint;
 	struct usb_serial_port	*port;
 	struct tty_struct	*tty;
-	unsigned char 		*data = urb->transfer_buffer;
+	unsigned char		*data = urb->transfer_buffer;
 	int status = urb->status;
 
 	dbg("%s", __func__);
@@ -390,11 +390,11 @@ static void	usa26_outcont_callback(struct urb *urb)
 
 static void	usa26_instat_callback(struct urb *urb)
 {
-	unsigned char 				*data = urb->transfer_buffer;
+	unsigned char				*data = urb->transfer_buffer;
 	struct keyspan_usa26_portStatusMessage	*msg;
 	struct usb_serial			*serial;
 	struct usb_serial_port			*port;
-	struct keyspan_port_private	 	*p_priv;
+	struct keyspan_port_private		*p_priv;
 	struct tty_struct			*tty;
 	int old_dcd_state, err;
 	int status = urb->status;
@@ -485,7 +485,7 @@ static void usa28_indat_callback(struct urb *urb)
 		p_priv = usb_get_serial_port_data(port);
 		data = urb->transfer_buffer;
 
-		tty =tty_port_tty_get(&port->port);
+		tty = tty_port_tty_get(&port->port);
 		if (tty && urb->actual_length) {
 			tty_insert_flip_string(tty, data, urb->actual_length);
 			tty_flip_buffer_push(tty);
@@ -526,11 +526,11 @@ static void	usa28_outcont_callback(struct urb *urb)
 static void	usa28_instat_callback(struct urb *urb)
 {
 	int					err;
-	unsigned char 				*data = urb->transfer_buffer;
+	unsigned char				*data = urb->transfer_buffer;
 	struct keyspan_usa28_portStatusMessage	*msg;
 	struct usb_serial			*serial;
 	struct usb_serial_port			*port;
-	struct keyspan_port_private	 	*p_priv;
+	struct keyspan_port_private		*p_priv;
 	struct tty_struct			*tty;
 	int old_dcd_state;
 	int status = urb->status;
@@ -569,9 +569,9 @@ static void	usa28_instat_callback(struct urb *urb)
 	p_priv->dcd_state = ((msg->dcd) ? 1 : 0);
 	p_priv->ri_state = ((msg->ri) ? 1 : 0);
 
-	if( old_dcd_state != p_priv->dcd_state && old_dcd_state) {
+	if (old_dcd_state != p_priv->dcd_state && old_dcd_state) {
 		tty = tty_port_tty_get(&port->port);
-		if (tty && !C_CLOCAL(tty)) 
+		if (tty && !C_CLOCAL(tty))
 			tty_hangup(tty);
 		tty_kref_put(tty);
 	}
@@ -617,11 +617,11 @@ static void	usa49_glocont_callback(struct urb *urb)
 static void	usa49_instat_callback(struct urb *urb)
 {
 	int					err;
-	unsigned char 				*data = urb->transfer_buffer;
+	unsigned char				*data = urb->transfer_buffer;
 	struct keyspan_usa49_portStatusMessage	*msg;
 	struct usb_serial			*serial;
 	struct usb_serial_port			*port;
-	struct keyspan_port_private	 	*p_priv;
+	struct keyspan_port_private		*p_priv;
 	int old_dcd_state;
 	int status = urb->status;
 
@@ -688,7 +688,7 @@ static void	usa49_indat_callback(struct urb *urb)
 	int			endpoint;
 	struct usb_serial_port	*port;
 	struct tty_struct	*tty;
-	unsigned char 		*data = urb->transfer_buffer;
+	unsigned char		*data = urb->transfer_buffer;
 	int status = urb->status;
 
 	dbg("%s", __func__);
@@ -739,7 +739,7 @@ static void usa49wg_indat_callback(struct urb *urb)
 	struct usb_serial	*serial;
 	struct usb_serial_port	*port;
 	struct tty_struct	*tty;
-	unsigned char 		*data = urb->transfer_buffer;
+	unsigned char		*data = urb->transfer_buffer;
 	int status = urb->status;
 
 	dbg("%s", __func__);
@@ -814,9 +814,9 @@ static void usa90_indat_callback(struct urb *urb)
 	int			i, err;
 	int			endpoint;
 	struct usb_serial_port	*port;
-	struct keyspan_port_private	 	*p_priv;
+	struct keyspan_port_private		*p_priv;
 	struct tty_struct	*tty;
-	unsigned char 		*data = urb->transfer_buffer;
+	unsigned char		*data = urb->transfer_buffer;
 	int status = urb->status;
 
 	dbg("%s", __func__);
@@ -881,11 +881,11 @@ static void usa90_indat_callback(struct urb *urb)
 
 static void	usa90_instat_callback(struct urb *urb)
 {
-	unsigned char 				*data = urb->transfer_buffer;
+	unsigned char				*data = urb->transfer_buffer;
 	struct keyspan_usa90_portStatusMessage	*msg;
 	struct usb_serial			*serial;
 	struct usb_serial_port			*port;
-	struct keyspan_port_private	 	*p_priv;
+	struct keyspan_port_private		*p_priv;
 	struct tty_struct			*tty;
 	int old_dcd_state, err;
 	int status = urb->status;
@@ -949,11 +949,11 @@ static void	usa90_outcont_callback(struct urb *urb)
 static void	usa67_instat_callback(struct urb *urb)
 {
 	int					err;
-	unsigned char 				*data = urb->transfer_buffer;
+	unsigned char				*data = urb->transfer_buffer;
 	struct keyspan_usa67_portStatusMessage	*msg;
 	struct usb_serial			*serial;
 	struct usb_serial_port			*port;
-	struct keyspan_port_private	 	*p_priv;
+	struct keyspan_port_private		*p_priv;
 	int old_dcd_state;
 	int status = urb->status;
 
@@ -1065,9 +1065,9 @@ static int keyspan_write_room(struct tty_struct *tty)
 
 static int keyspan_open(struct tty_struct *tty, struct usb_serial_port *port)
 {
-	struct keyspan_port_private 	*p_priv;
-	struct keyspan_serial_private 	*s_priv;
-	struct usb_serial 		*serial = port->serial;
+	struct keyspan_port_private	*p_priv;
+	struct keyspan_serial_private	*s_priv;
+	struct usb_serial		*serial = port->serial;
 	const struct keyspan_device_details	*d_details;
 	int				i, err;
 	int				baud_rate, device_port;
@@ -1127,14 +1127,14 @@ static int keyspan_open(struct tty_struct *tty, struct usb_serial_port *port)
 		baud_rate = tty_get_baud_rate(tty);
 		/* If no match or invalid, leave as default */
 		if (baud_rate >= 0
-		    && d_details->calculate_baud_rate(baud_rate, d_details->baudclk,
+			&& d_details->calculate_baud_rate(baud_rate, d_details->baudclk,
 					NULL, NULL, NULL, device_port) == KEYSPAN_BAUD_RATE_OK) {
 			p_priv->baud = baud_rate;
 		}
 	}
 	/* set CTS/RTS handshake etc. */
 	p_priv->cflag = cflag;
-	p_priv->flow_control = (cflag & CRTSCTS)? flow_cts: flow_none;
+	p_priv->flow_control = (cflag & CRTSCTS) ? flow_cts : flow_none;
 
 	keyspan_send_setup(port, 1);
 	/* mdelay(100); */
@@ -1162,8 +1162,8 @@ static void keyspan_close(struct usb_serial_port *port)
 {
 	int			i;
 	struct usb_serial	*serial = port->serial;
-	struct keyspan_serial_private 	*s_priv;
-	struct keyspan_port_private 	*p_priv;
+	struct keyspan_serial_private	*s_priv;
+	struct keyspan_port_private	*p_priv;
 
 	dbg("%s", __func__);
 	s_priv = usb_get_serial_data(serial);
@@ -1200,8 +1200,8 @@ static void keyspan_close(struct usb_serial_port *port)
 /* download the firmware to a pre-renumeration device */
 static int keyspan_fake_startup(struct usb_serial *serial)
 {
-	int 				response;
-	const struct ihex_binrec 	*record;
+	int				response;
+	const struct ihex_binrec	*record;
 	char				*fw_name;
 	const struct firmware		*fw;
 
@@ -1273,7 +1273,7 @@ static int keyspan_fake_startup(struct usb_serial *serial)
 
 	if (request_ihex_firmware(&fw, fw_name, &serial->dev->dev)) {
 		dev_err(&serial->dev->dev, "Required keyspan firmware image (%s) unavailable.\n", fw_name);
-		return(1);
+		return 1;
 	}
 
 	dbg("Uploading Keyspan %s firmware.", fw_name);
@@ -1431,7 +1431,7 @@ static struct callbacks {
 static void keyspan_setup_urbs(struct usb_serial *serial)
 {
 	int				i, j;
-	struct keyspan_serial_private 	*s_priv;
+	struct keyspan_serial_private	*s_priv;
 	const struct keyspan_device_details	*d_details;
 	struct usb_serial_port		*port;
 	struct keyspan_port_private	*p_priv;
@@ -1507,7 +1507,7 @@ static void keyspan_setup_urbs(struct usb_serial *serial)
 static int keyspan_usa19_calc_baud(u32 baud_rate, u32 baudclk, u8 *rate_hi,
 				   u8 *rate_low, u8 *prescaler, int portnum)
 {
-	u32 	b16,	/* baud rate times 16 (actual rate used internally) */
+	u32	b16,	/* baud rate times 16 (actual rate used internally) */
 		div,	/* divisor */
 		cnt;	/* inverse of divisor (programmed into 8051) */
 
@@ -1547,7 +1547,7 @@ static int keyspan_usa19_calc_baud(u32 baud_rate, u32 baudclk, u8 *rate_hi,
 static int keyspan_usa19hs_calc_baud(u32 baud_rate, u32 baudclk, u8 *rate_hi,
 				   u8 *rate_low, u8 *prescaler, int portnum)
 {
-	u32 	b16,	/* baud rate times 16 (actual rate used internally) */
+	u32	b16,	/* baud rate times 16 (actual rate used internally) */
 			div;	/* divisor */
 
 	dbg("%s - %d.", __func__, baud_rate);
@@ -1582,7 +1582,7 @@ static int keyspan_usa19hs_calc_baud(u32 baud_rate, u32 baudclk, u8 *rate_hi,
 static int keyspan_usa19w_calc_baud(u32 baud_rate, u32 baudclk, u8 *rate_hi,
 				    u8 *rate_low, u8 *prescaler, int portnum)
 {
-	u32 	b16,	/* baud rate times 16 (actual rate used internally) */
+	u32	b16,	/* baud rate times 16 (actual rate used internally) */
 		clk,	/* clock with 13/8 prescaler */
 		div,	/* divisor using 13/8 prescaler */
 		res,	/* resulting baud rate using 13/8 prescaler */
@@ -1645,7 +1645,7 @@ static int keyspan_usa19w_calc_baud(u32 baud_rate, u32 baudclk, u8 *rate_hi,
 static int keyspan_usa28_calc_baud(u32 baud_rate, u32 baudclk, u8 *rate_hi,
 				    u8 *rate_low, u8 *prescaler, int portnum)
 {
-	u32 	b16,	/* baud rate times 16 (actual rate used internally) */
+	u32	b16,	/* baud rate times 16 (actual rate used internally) */
 		div,	/* divisor */
 		cnt;	/* inverse of divisor (programmed into 8051) */
 
@@ -1691,12 +1691,12 @@ static int keyspan_usa26_send_setup(struct usb_serial *serial,
 				    int reset_port)
 {
 	struct keyspan_usa26_portControlMessage	msg;
-	struct keyspan_serial_private 		*s_priv;
-	struct keyspan_port_private 		*p_priv;
+	struct keyspan_serial_private		*s_priv;
+	struct keyspan_port_private		*p_priv;
 	const struct keyspan_device_details	*d_details;
-	int 					outcont_urb;
+	int					outcont_urb;
 	struct urb				*this_urb;
-	int 					device_port, err;
+	int					device_port, err;
 
 	dbg("%s reset=%d", __func__, reset_port);
 
@@ -1744,7 +1744,7 @@ static int keyspan_usa26_send_setup(struct usb_serial *serial,
 		msg.setPrescaler = 0xff;
 	}
 
-	msg.lcr = (p_priv->cflag & CSTOPB)? STOPBITS_678_2: STOPBITS_5678_1;
+	msg.lcr = (p_priv->cflag & CSTOPB) ? STOPBITS_678_2 : STOPBITS_5678_1;
 	switch (p_priv->cflag & CSIZE) {
 	case CS5:
 		msg.lcr |= USA_DATABITS_5;
@@ -1761,7 +1761,7 @@ static int keyspan_usa26_send_setup(struct usb_serial *serial,
 	}
 	if (p_priv->cflag & PARENB) {
 		/* note USA_PARITY_NONE == 0 */
-		msg.lcr |= (p_priv->cflag & PARODD)?
+		msg.lcr |= (p_priv->cflag & PARODD) ?
 			USA_PARITY_ODD : USA_PARITY_EVEN;
 	}
 	msg.setLcr = 0xff;
@@ -1847,11 +1847,11 @@ static int keyspan_usa28_send_setup(struct usb_serial *serial,
 				    int reset_port)
 {
 	struct keyspan_usa28_portControlMessage	msg;
-	struct keyspan_serial_private	 	*s_priv;
-	struct keyspan_port_private 		*p_priv;
+	struct keyspan_serial_private		*s_priv;
+	struct keyspan_port_private		*p_priv;
 	const struct keyspan_device_details	*d_details;
 	struct urb				*this_urb;
-	int 					device_port, err;
+	int					device_port, err;
 
 	dbg("%s", __func__);
 
@@ -1973,12 +1973,12 @@ static int keyspan_usa49_send_setup(struct usb_serial *serial,
 				    int reset_port)
 {
 	struct keyspan_usa49_portControlMessage	msg;
-	struct usb_ctrlrequest 			*dr = NULL;
-	struct keyspan_serial_private 		*s_priv;
-	struct keyspan_port_private 		*p_priv;
+	struct usb_ctrlrequest			*dr = NULL;
+	struct keyspan_serial_private		*s_priv;
+	struct keyspan_port_private		*p_priv;
 	const struct keyspan_device_details	*d_details;
 	struct urb				*this_urb;
-	int 					err, device_port;
+	int					err, device_port;
 
 	dbg("%s", __func__);
 
@@ -2033,7 +2033,7 @@ static int keyspan_usa49_send_setup(struct usb_serial *serial,
 		/* msg.setPrescaler = 0xff; */
 	}
 
-	msg.lcr = (p_priv->cflag & CSTOPB)? STOPBITS_678_2: STOPBITS_5678_1;
+	msg.lcr = (p_priv->cflag & CSTOPB) ? STOPBITS_678_2 : STOPBITS_5678_1;
 	switch (p_priv->cflag & CSIZE) {
 	case CS5:
 		msg.lcr |= USA_DATABITS_5;
@@ -2050,7 +2050,7 @@ static int keyspan_usa49_send_setup(struct usb_serial *serial,
 	}
 	if (p_priv->cflag & PARENB) {
 		/* note USA_PARITY_NONE == 0 */
-		msg.lcr |= (p_priv->cflag & PARODD)?
+		msg.lcr |= (p_priv->cflag & PARODD) ?
 			USA_PARITY_ODD : USA_PARITY_EVEN;
 	}
 	msg.setLcr = 0xff;
@@ -2161,11 +2161,11 @@ static int keyspan_usa90_send_setup(struct usb_serial *serial,
 				    int reset_port)
 {
 	struct keyspan_usa90_portControlMessage	msg;
-	struct keyspan_serial_private 		*s_priv;
-	struct keyspan_port_private 		*p_priv;
+	struct keyspan_serial_private		*s_priv;
+	struct keyspan_port_private		*p_priv;
 	const struct keyspan_device_details	*d_details;
 	struct urb				*this_urb;
-	int 					err;
+	int					err;
 	u8						prescaler;
 
 	dbg("%s", __func__);
@@ -2219,7 +2219,7 @@ static int keyspan_usa90_send_setup(struct usb_serial *serial,
 		msg.txMode = TXMODE_BYHAND;
 	}
 
-	msg.lcr = (p_priv->cflag & CSTOPB)? STOPBITS_678_2: STOPBITS_5678_1;
+	msg.lcr = (p_priv->cflag & CSTOPB) ? STOPBITS_678_2 : STOPBITS_5678_1;
 	switch (p_priv->cflag & CSIZE) {
 	case CS5:
 		msg.lcr |= USA_DATABITS_5;
@@ -2236,7 +2236,7 @@ static int keyspan_usa90_send_setup(struct usb_serial *serial,
 	}
 	if (p_priv->cflag & PARENB) {
 		/* note USA_PARITY_NONE == 0 */
-		msg.lcr |= (p_priv->cflag & PARODD)?
+		msg.lcr |= (p_priv->cflag & PARODD) ?
 			USA_PARITY_ODD : USA_PARITY_EVEN;
 	}
 	if (p_priv->old_cflag != p_priv->cflag) {
@@ -2294,11 +2294,11 @@ static int keyspan_usa67_send_setup(struct usb_serial *serial,
 				    int reset_port)
 {
 	struct keyspan_usa67_portControlMessage	msg;
-	struct keyspan_serial_private 		*s_priv;
-	struct keyspan_port_private 		*p_priv;
+	struct keyspan_serial_private		*s_priv;
+	struct keyspan_port_private		*p_priv;
 	const struct keyspan_device_details	*d_details;
 	struct urb				*this_urb;
-	int 					err, device_port;
+	int					err, device_port;
 
 	dbg("%s", __func__);
 
@@ -2365,7 +2365,7 @@ static int keyspan_usa67_send_setup(struct usb_serial *serial,
 	}
 	if (p_priv->cflag & PARENB) {
 		/* note USA_PARITY_NONE == 0 */
-		msg.lcr |= (p_priv->cflag & PARODD)?
+		msg.lcr |= (p_priv->cflag & PARODD) ?
 					USA_PARITY_ODD : USA_PARITY_EVEN;
 	}
 	msg.setLcr = 0xff;
@@ -2473,7 +2473,7 @@ static int keyspan_startup(struct usb_serial *serial)
 {
 	int				i, err;
 	struct usb_serial_port		*port;
-	struct keyspan_serial_private 	*s_priv;
+	struct keyspan_serial_private	*s_priv;
 	struct keyspan_port_private	*p_priv;
 	const struct keyspan_device_details	*d_details;
 
@@ -2535,7 +2535,7 @@ static void keyspan_disconnect(struct usb_serial *serial)
 {
 	int				i, j;
 	struct usb_serial_port		*port;
-	struct keyspan_serial_private 	*s_priv;
+	struct keyspan_serial_private	*s_priv;
 	struct keyspan_port_private	*p_priv;
 
 	dbg("%s", __func__);
@@ -2577,7 +2577,7 @@ static void keyspan_release(struct usb_serial *serial)
 {
 	int				i;
 	struct usb_serial_port		*port;
-	struct keyspan_serial_private 	*s_priv;
+	struct keyspan_serial_private	*s_priv;
 
 	dbg("%s", __func__);
 
-- 
1.7.2.5

