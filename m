Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932346Ab1CWIuL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 04:50:11 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:56907 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755898Ab1CWIuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 04:50:06 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: jirislaby@gmail.com
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 3/7] Char: cyclades, fix unused variable
Date: Wed, 23 Mar 2011 09:49:56 +0100
Message-Id: <1300870200-24405-3-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300870200-24405-1-git-send-email-jslaby@suse.cz>
References: <1300870200-24405-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/tty/cyclades.c:1454:2: warning: Value stored to 'channel' is never read
	channel = info->line - card->first_line;
	^         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Fix it by moving it to the appropriate debug section where it is used.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/tty/cyclades.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/cyclades.c b/drivers/tty/cyclades.c
index c99728f..e6f20d2 100644
--- a/drivers/tty/cyclades.c
+++ b/drivers/tty/cyclades.c
@@ -1445,13 +1445,11 @@ static void cy_shutdown(struct cyclades_port *info, struct tty_struct *tty)
 {
 	struct cyclades_card *card;
 	unsigned long flags;
-	int channel;
 
 	if (!(info->port.flags & ASYNC_INITIALIZED))
 		return;
 
 	card = info->card;
-	channel = info->line - card->first_line;
 	if (!cy_is_Z(card)) {
 		spin_lock_irqsave(&card->card_lock, flags);
 
@@ -1476,6 +1474,7 @@ static void cy_shutdown(struct cyclades_port *info, struct tty_struct *tty)
 		spin_unlock_irqrestore(&card->card_lock, flags);
 	} else {
 #ifdef CY_DEBUG_OPEN
+		int channel = info->line - card->first_line;
 		printk(KERN_DEBUG "cyc shutdown Z card %d, channel %d, "
 			"base_addr %p\n", card, channel, card->base_addr);
 #endif
-- 
1.7.4.1


