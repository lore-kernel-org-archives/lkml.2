Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890Ab2DBMLB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 08:11:01 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:47936 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145Ab2DBLzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 07:55:00 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: [PATCH 03/69] TTY: deprecate linux/generic_serial.h
Date: Mon,  2 Apr 2012 13:53:47 +0200
Message-Id: <1333367693-3244-4-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
References: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since nobody in the kernel includes that file, let us remove the
structs visible to the kernel.

However since the userspace sees the file, it still may include that.
hence deprecate the use of the header by an added cpp #warning.

We should remove the file completely after a couple of years.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 include/linux/generic_serial.h |   64 ++--------------------------------------
 1 file changed, 2 insertions(+), 62 deletions(-)

diff --git a/include/linux/generic_serial.h b/include/linux/generic_serial.h
index fadff28..79b3eb3 100644
--- a/include/linux/generic_serial.h
+++ b/include/linux/generic_serial.h
@@ -4,7 +4,6 @@
  *  Copyright (C) 1998 R.E.Wolff@BitWizard.nl
  *
  *  written for the SX serial driver.
- *     Contains the code that should be shared over all the serial drivers.
  *
  *  Version 0.1 -- December, 1998.
  */
@@ -12,45 +11,8 @@
 #ifndef GENERIC_SERIAL_H
 #define GENERIC_SERIAL_H
 
-#ifdef __KERNEL__
-#include <linux/mutex.h>
-#include <linux/tty.h>
-
-struct real_driver {
-  void                    (*disable_tx_interrupts) (void *);
-  void                    (*enable_tx_interrupts) (void *);
-  void                    (*disable_rx_interrupts) (void *);
-  void                    (*enable_rx_interrupts) (void *);
-  void                    (*shutdown_port) (void*);
-  int                     (*set_real_termios) (void*);
-  int                     (*chars_in_buffer) (void*);
-  void                    (*close) (void*);
-  void                    (*hungup) (void*);
-  void                    (*getserial) (void*, struct serial_struct *sp);
-};
-
-
-
-struct gs_port {
-  int                     magic;
-  struct tty_port	  port;
-  unsigned char           *xmit_buf; 
-  int                     xmit_head;
-  int                     xmit_tail;
-  int                     xmit_cnt;
-  struct mutex            port_write_mutex;
-  unsigned long           event;
-  unsigned short          closing_wait;
-  int                     close_delay;
-  struct real_driver      *rd;
-  int                     wakeup_chars;
-  int                     baud_base;
-  int                     baud;
-  int                     custom_divisor;
-  spinlock_t              driver_lock;
-};
-
-#endif /* __KERNEL__ */
+#warning Use of this header is deprecated.
+#warning Since nobody sets the constants defined here for you, you should not, in any case, use them. Including the header is thus pointless.
 
 /* Flags */
 /* Warning: serial.h defines some ASYNC_ flags, they say they are "only"
@@ -60,8 +22,6 @@ struct gs_port {
 #define GS_RX_INTEN      0x00400000
 #define GS_ACTIVE        0x00200000
 
-
-
 #define GS_TYPE_NORMAL   1
 
 #define GS_DEBUG_FLUSH   0x00000001
@@ -72,24 +32,4 @@ struct gs_port {
 #define GS_DEBUG_FLOW    0x00000020
 #define GS_DEBUG_WRITE   0x00000040
 
-#ifdef __KERNEL__
-int gs_put_char(struct tty_struct *tty, unsigned char ch);
-int  gs_write(struct tty_struct *tty, 
-             const unsigned char *buf, int count);
-int  gs_write_room(struct tty_struct *tty);
-int  gs_chars_in_buffer(struct tty_struct *tty);
-void gs_flush_buffer(struct tty_struct *tty);
-void gs_flush_chars(struct tty_struct *tty);
-void gs_stop(struct tty_struct *tty);
-void gs_start(struct tty_struct *tty);
-void gs_hangup(struct tty_struct *tty);
-int  gs_block_til_ready(void *port, struct file *filp);
-void gs_close(struct tty_struct *tty, struct file *filp);
-void gs_set_termios (struct tty_struct * tty, 
-                     struct ktermios * old_termios);
-int  gs_init_port(struct gs_port *port);
-int  gs_setserial(struct gs_port *port, struct serial_struct __user *sp);
-int  gs_getserial(struct gs_port *port, struct serial_struct __user *sp);
-void gs_got_break(struct gs_port *port);
-#endif /* __KERNEL__ */
 #endif
-- 
1.7.9.2


