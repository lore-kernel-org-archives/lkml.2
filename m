Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485Ab3ACOxt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 09:53:49 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:60989 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753074Ab3ACOxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 09:53:46 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, jirislaby@gmail.com, linux-kernel@vger.kernel.org
Subject: [PATCH 10/10] TTY: nozomi, remove dead code
Date: Thu,  3 Jan 2013 15:53:40 +0100
Message-Id: <1357224820-2942-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1357224789-2853-1-git-send-email-jslaby@suse.cz>
References: <1357224789-2853-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We test for !dc twice, remove the second test. Coverity found this.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/tty/nozomi.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/tty/nozomi.c b/drivers/tty/nozomi.c
index afdd773..2dff197 100644
--- a/drivers/tty/nozomi.c
+++ b/drivers/tty/nozomi.c
@@ -1679,12 +1679,6 @@ static int ntty_write(struct tty_struct *tty, const unsigned char *buffer,
 
 	rval = kfifo_in(&port->fifo_ul, (unsigned char *)buffer, count);
 
-	/* notify card */
-	if (unlikely(dc == NULL)) {
-		DBG1("No device context?");
-		goto exit;
-	}
-
 	spin_lock_irqsave(&dc->spin_mutex, flags);
 	/* CTS is only valid on the modem channel */
 	if (port == &(dc->port[PORT_MDM])) {
@@ -1700,7 +1694,6 @@ static int ntty_write(struct tty_struct *tty, const unsigned char *buffer,
 	}
 	spin_unlock_irqrestore(&dc->spin_mutex, flags);
 
-exit:
 	return rval;
 }
 
-- 
1.8.1


