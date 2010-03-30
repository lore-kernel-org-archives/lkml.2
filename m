Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757350Ab0C3Xr4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:47:56 -0400
Received: from kroah.org ([198.145.64.141]:45941 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932494Ab0C3XTx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:19:53 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:47:49 2010
Message-Id: <20100330224748.510081090@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:41:18 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Tilman Schmidt <tilman@imap.cc>, Karsten Keil <keil@b1-systems.de>,
       "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [044/156] gigaset: correct clearing of at_state strings on RING
In-Reply-To: <20100330230630.GA28824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tilman Schmidt <tilman@imap.cc>

commit 3a0a3a6b92edf181f849ebd8417122392ba73a96 upstream.

In RING handling, clear the table of received parameter strings in
a loop like everywhere else, instead of by enumeration which had
already gotten out of sync.

Impact: minor bugfix
Signed-off-by: Tilman Schmidt <tilman@imap.cc>
Acked-by: Karsten Keil <keil@b1-systems.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/isdn/gigaset/ev-layer.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

--- a/drivers/isdn/gigaset/ev-layer.c
+++ b/drivers/isdn/gigaset/ev-layer.c
@@ -1259,14 +1259,10 @@ static void do_action(int action, struct
 		 * note that bcs may be NULL if no B channel is free
 		 */
 		at_state2->ConState = 700;
-		kfree(at_state2->str_var[STR_NMBR]);
-		at_state2->str_var[STR_NMBR] = NULL;
-		kfree(at_state2->str_var[STR_ZCPN]);
-		at_state2->str_var[STR_ZCPN] = NULL;
-		kfree(at_state2->str_var[STR_ZBC]);
-		at_state2->str_var[STR_ZBC] = NULL;
-		kfree(at_state2->str_var[STR_ZHLC]);
-		at_state2->str_var[STR_ZHLC] = NULL;
+		for (i = 0; i < STR_NUM; ++i) {
+			kfree(at_state2->str_var[i]);
+			at_state2->str_var[i] = NULL;
+		}
 		at_state2->int_var[VAR_ZCTP] = -1;
 
 		spin_lock_irqsave(&cs->lock, flags);


