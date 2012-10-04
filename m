Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946079Ab2JDVYA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 17:24:00 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45178 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934009Ab2JDVXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 17:23:55 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Christopher Brannon <chris@the-brannons.com>,
        Alan Cox <alan@linux.intel.com>
Subject: [ 11/52] tty: keyboard.c: Remove locking from vt_get_leds.
Date: Thu,  4 Oct 2012 14:21:02 -0700
Message-Id: <20121004210636.753135044@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121004210635.372689554@linuxfoundation.org>
References: <20121004210635.372689554@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christopher Brannon <chris@the-brannons.com>

commit 157a4b311c45c9aba75a990464d9680867dc8805 upstream.

There are three call sites for this function, and all three
are called within a keyboard handler.
kbd_event_lock is already held within keyboard handlers,
so attempting to lock it in vt_get_leds causes deadlock.

Signed-off-by: Christopher Brannon <chris@the-brannons.com>
Acked-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/vt/keyboard.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/tty/vt/keyboard.c
+++ b/drivers/tty/vt/keyboard.c
@@ -1053,13 +1053,10 @@ static int kbd_update_leds_helper(struct
  */
 int vt_get_leds(int console, int flag)
 {
-	unsigned long flags;
 	struct kbd_struct * kbd = kbd_table + console;
 	int ret;
 
-	spin_lock_irqsave(&kbd_event_lock, flags);
 	ret = vc_kbd_led(kbd, flag);
-	spin_unlock_irqrestore(&kbd_event_lock, flags);
 
 	return ret;
 }


