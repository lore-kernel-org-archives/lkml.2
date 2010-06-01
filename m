Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932314Ab0FAU7V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 16:59:21 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:55133 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757355Ab0FAUxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 16:53:30 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       John Kacur <jkacur@redhat.com>, Alan Cox <alan@linux.intel.com>
Subject: [PATCH 08/31] epca: Kill the big kernel lock
Date: Tue,  1 Jun 2010 22:52:48 +0200
Message-Id: <1275425591-8803-9-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1275425591-8803-1-git-send-email-arnd@arndb.de>
References: <1275425591-8803-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+iVZuXrmvV4KRhrxTMCCRDmNe0DUr3Zr1/XT4
 Y5KNvEoSJ/SIzG3/8rjeaSi1ixVsu4PxmRTCpvuDD3PO9pK952
 6VG/s1H8ROBB5YUvVxG6A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

The lock is no longer needed for wait until sent paths so this can go

Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 drivers/char/epca.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/char/epca.c b/drivers/char/epca.c
index 6f5ffe1..d9df46a 100644
--- a/drivers/char/epca.c
+++ b/drivers/char/epca.c
@@ -36,7 +36,7 @@
 #include <linux/ctype.h>
 #include <linux/tty.h>
 #include <linux/tty_flip.h>
-#include <linux/smp_lock.h>
+#include <linux/slab.h>
 #include <linux/ioport.h>
 #include <linux/interrupt.h>
 #include <linux/uaccess.h>
@@ -2105,7 +2105,6 @@ static int pc_ioctl(struct tty_struct *tty, struct file *file,
 		break;
 	case DIGI_SETAW:
 	case DIGI_SETAF:
-		lock_kernel();
 		if (cmd == DIGI_SETAW) {
 			/* Setup an event to indicate when the transmit
 			   buffer empties */
@@ -2118,7 +2117,6 @@ static int pc_ioctl(struct tty_struct *tty, struct file *file,
 			if (tty->ldisc->ops->flush_buffer)
 				tty->ldisc->ops->flush_buffer(tty);
 		}
-		unlock_kernel();
 		/* Fall Thru */
 	case DIGI_SETA:
 		if (copy_from_user(&ch->digiext, argp, sizeof(digi_t)))
-- 
1.7.0.4

