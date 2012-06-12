Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753780Ab2FLSpI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 14:45:08 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:50517 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179Ab2FLSpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 14:45:06 -0400
From: Chris Yungmann <yungmann.chris@gmail.com>
To: samuel.thibault@ens-lyon.org
Cc: w.d.hubbs@gmail.com, chris@the-brannons.com, kirk@braille.uwo.ca,
        gregkh@linuxfoundation.org, speakup@braille.uwo.ca,
        linux-kernel@vger.kernel.org, kernelnewbies@kernelnewbies.org,
        Chris Yungmann <yungmann.chris@gmail.com>
Subject: [PATCH][RESEND] staging: speakup: fixed checkpatch and sparse warnings in selection.c
Date: Tue, 12 Jun 2012 14:44:11 -0400
Message-Id: <1339526651-14388-1-git-send-email-yungmann.chris@gmail.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Left in_atomic() call as more work is needed (see TODO note at top of function).

Signed-off-by: Chris Yungmann <yungmann.chris@gmail.com>
---
 drivers/staging/speakup/selection.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/speakup/selection.c b/drivers/staging/speakup/selection.c
index fe1f405..006403d 100644
--- a/drivers/staging/speakup/selection.c
+++ b/drivers/staging/speakup/selection.c
@@ -68,7 +68,7 @@ int speakup_set_selection(struct tty_struct *tty)
 	if (spk_sel_cons != vc_cons[fg_console].d) {
 		speakup_clear_selection();
 		spk_sel_cons = vc_cons[fg_console].d;
-		printk(KERN_WARNING
+		pr_warn(KERN_WARNING
 			"Selection: mark console not the same as cut\n");
 		return -EINVAL;
 	}
@@ -95,7 +95,7 @@ int speakup_set_selection(struct tty_struct *tty)
 	/* Allocate a new buffer before freeing the old one ... */
 	bp = kmalloc((sel_end-sel_start)/2+1, GFP_ATOMIC);
 	if (!bp) {
-		printk(KERN_WARNING "selection: kmalloc() failed\n");
+		pr_warn(KERN_WARNING "selection: kmalloc() failed\n");
 		speakup_clear_selection();
 		return -ENOMEM;
 	}
@@ -141,7 +141,7 @@ int speakup_paste_selection(struct tty_struct *tty)
 		count = sel_buffer_lth - pasted;
 		count = min_t(int, count, tty->receive_room);
 		tty->ldisc->ops->receive_buf(tty, sel_buffer + pasted,
-			0, count);
+			NULL, count);
 		pasted += count;
 	}
 	remove_wait_queue(&vc->paste_wait, &wait);
-- 
1.7.10

