Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759873Ab0JVTRx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 15:17:53 -0400
Received: from kroah.org ([198.145.64.141]:34070 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759302Ab0JVS4R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:56:17 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Oct 22 11:52:30 2010
Message-Id: <20101022185230.490998180@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 22 Oct 2010 11:51:09 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Maxim Levitsky <maximlevitsky@gmail.com>,
        Jarod Wilson <jarod@redhat.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [035/103] V4L/DVB: IR: fix keys beeing stuck down forever
In-Reply-To: <20101022185455.GA9114@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Maxim Levitsky <maximlevitsky@gmail.com>

commit e0172fd373ab77a83ea952fd6a75c612e1b0bf9e upstream.

The logic in ir_timer_keyup was inverted.

In case that values aren't equal,
the meaning of the time_is_after_eq_jiffies(ir->keyup_jiffies) is that
ir->keyup_jiffies is after the the jiffies or equally that
that jiffies are before the the ir->keyup_jiffies which is
exactly the situation we want to avoid (that the timeout is in the future)
Confusing Eh?

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
Acked-by: Jarod Wilson <jarod@redhat.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/IR/ir-keytable.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/IR/ir-keytable.c
+++ b/drivers/media/IR/ir-keytable.c
@@ -319,7 +319,7 @@ static void ir_timer_keyup(unsigned long
 	 * a keyup event might follow immediately after the keydown.
 	 */
 	spin_lock_irqsave(&ir->keylock, flags);
-	if (time_is_after_eq_jiffies(ir->keyup_jiffies))
+	if (time_is_before_eq_jiffies(ir->keyup_jiffies))
 		ir_keyup(ir);
 	spin_unlock_irqrestore(&ir->keylock, flags);
 }


