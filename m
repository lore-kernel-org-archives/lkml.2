Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757031Ab1DBBES (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 21:04:18 -0400
Received: from oproxy2-pub.bluehost.com ([67.222.39.60]:45364 "HELO
	oproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756873Ab1DBBEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 21:04:16 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=RwHsMpI7tq1KYsQojnu6NW888uPpv2uvBC5UninWTXn7dgzsmQAHoHLK1XHtYNcyei+6CbdSP2vAReUl1veG0R+IxaTby6TuPYAZNaCnxnvt3nMqrKSfJ2XuiiWWIe4+;
Date: Fri, 1 Apr 2011 18:04:13 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: lkml <linux-kernel@vger.kernel.org>,
        torvalds <torvalds@linux-foundation.org>
Cc: lud <linux-usb@vger.kernel.org>, gregkh <greg@kroah.com>,
        Alan Cox <alan@linux.intel.com>
Subject: [PATCH] usb/serial: fix function args warnings, dropping *filp
Message-Id: <20110401180413.cb6e35fa.rdunlap@xenotime.net>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix build warnings caused by removal of *filp arg in
struct usb_serial_driver.
These changes were missed somehow in commits
00a0d0d65b61241a718d0aee96f46b9a2d93bf26 and
60b33c133ca0b7c0b6072c87234b63fee6e80558.

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
