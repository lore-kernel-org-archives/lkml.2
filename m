Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758288Ab0DAQgA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 12:36:00 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44910 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758239Ab0DAQfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 12:35:42 -0400
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 12/14] epca: Kill the big kernel lock
To: linux-kernel@vger.kernel.org
Date: Thu, 01 Apr 2010 17:06:52 +0100
Message-ID: <20100401160648.8882.29963.stgit@localhost.localdomain>
In-Reply-To: <20100401155513.8882.54006.stgit@localhost.localdomain>
References: <20100401155513.8882.54006.stgit@localhost.localdomain>
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

