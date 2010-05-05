Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934703Ab0EEKnj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 06:43:39 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54782 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934647Ab0EEKkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 06:40:51 -0400
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 08/20] epca: Kill the big kernel lock
To: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de
Date: Wed, 05 May 2010 11:02:25 +0100
Message-ID: <20100505100225.3595.67851.stgit@localhost.localdomain>
In-Reply-To: <20100505100144.3595.65633.stgit@localhost.localdomain>
References: <20100505100144.3595.65633.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

