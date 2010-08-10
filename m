Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933381Ab0HJWAG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 18:00:06 -0400
Received: from kroah.org ([198.145.64.141]:44847 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933238Ab0HJV7z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 17:59:55 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 20/68] epca: Kill the big kernel lock
Date: Tue, 10 Aug 2010 14:58:42 -0700
Message-Id: <1281477570-18944-20-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20100810214425.GB17385@kroah.com>
References: <20100810214425.GB17385@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

The lock is no longer needed for wait until sent paths so this can go

Signed-off-by: Alan Cox <alan@linux.intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
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
1.7.2

