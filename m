Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176Ab1DCSmP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Apr 2011 14:42:15 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:53874 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752974Ab1DCSmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Apr 2011 14:42:14 -0400
Date: Sun, 3 Apr 2011 11:42:00 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
        torvalds <torvalds@linux-foundation.org>,
        lud <linux-usb@vger.kernel.org>, gregkh <greg@kroah.com>,
        Alan Cox <alan@linux.intel.com>
Subject: [PATCH v2] usb/serial: fix function args warnings, dropping *filp
Message-Id: <20110403114200.85546616.randy.dunlap@oracle.com>
In-Reply-To: <4D971BD7.5040203@ru.mvista.com>
References: <20110401180413.cb6e35fa.rdunlap@xenotime.net>
	<4D971BD7.5040203@ru.mvista.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4D98BF7C.00EF:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix build warnings caused by removal of *filp arg in
struct usb_serial_driver.

These changes were missed somehow in commits
  00a0d0d65b61241a718d0aee96f46b9a2d93bf26:
  tty: remove filp from the USB tty ioctls
and
  60b33c133ca0b7c0b6072c87234b63fee6e80558:
  tiocmget: kill off the passing of the struct file

drivers/usb/serial/mct_u232.c:159: warning: initialization from incompatible pointer type
drivers/usb/serial/opticon.c:627: warning: initialization from incompatible pointer type

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Alan Cox <alan@linux.intel.com>
---
 drivers/usb/serial/mct_u232.c |    4 ++--
 drivers/usb/serial/opticon.c  |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- linux-next-20110401.orig/drivers/usb/serial/mct_u232.c
+++ linux-next-20110401/drivers/usb/serial/mct_u232.c
@@ -106,7 +106,7 @@ static void mct_u232_break_ctl(struct tt
 static int  mct_u232_tiocmget(struct tty_struct *tty);
 static int  mct_u232_tiocmset(struct tty_struct *tty,
 			unsigned int set, unsigned int clear);
-static int  mct_u232_ioctl(struct tty_struct *tty, struct file *file,
+static int  mct_u232_ioctl(struct tty_struct *tty,
 			unsigned int cmd, unsigned long arg);
 static int  mct_u232_get_icount(struct tty_struct *tty,
 			struct serial_icounter_struct *icount);
@@ -874,7 +874,7 @@ static void mct_u232_unthrottle(struct t
 	}
 }
 
-static int  mct_u232_ioctl(struct tty_struct *tty, struct file *file,
+static int  mct_u232_ioctl(struct tty_struct *tty,
 			unsigned int cmd, unsigned long arg)
 {
 	DEFINE_WAIT(wait);
--- linux-next-20110401.orig/drivers/usb/serial/opticon.c
+++ linux-next-20110401/drivers/usb/serial/opticon.c
@@ -413,7 +413,7 @@ static int opticon_tiocmget(struct tty_s
 	return result;
 }
 
-static int opticon_tiocmset(struct tty_struct *tty, struct file *file,
+static int opticon_tiocmset(struct tty_struct *tty,
 			   unsigned int set, unsigned int clear)
 {
 	struct usb_serial_port *port = tty->driver_data;
---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
