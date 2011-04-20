Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797Ab1DTInv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 04:43:51 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:51024 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161Ab1DTIn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 04:43:28 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@suse.de
Cc: jirislaby@gmail.com, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        Alan Cox <alan@linux.intel.com>
Subject: [PATCH 6/7] TTY: serial_core, remove superfluous set_task_state
Date: Wed, 20 Apr 2011 10:43:17 +0200
Message-Id: <1303288998-31718-6-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.4.2
In-Reply-To: <1303288998-31718-1-git-send-email-jslaby@suse.cz>
References: <1303288998-31718-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

msleep* is guaranteed to return with TASK_RUNNING task state. And
since there is no other set_task_state in the paths of
uart_wait_until_sent, we need not to set_task_state to TASK_RUNNING.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Alan Cox <alan@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/tty/serial/serial_core.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 848fd13..cda1089 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -1427,7 +1427,6 @@ static void __uart_wait_until_sent(struct uart_port *port, int timeout)
 		if (time_after(jiffies, expire))
 			break;
 	}
-	set_current_state(TASK_RUNNING); /* might not be needed */
 }
 
 static void uart_wait_until_sent(struct tty_struct *tty, int timeout)
-- 
1.7.4.2


