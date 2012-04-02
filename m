Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751840Ab2DBLzB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 07:55:01 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:47933 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047Ab2DBLzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 07:55:00 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>, linux-cris-kernel@axis.com
Subject: [PATCH 02/69] TTY: crisv10, initialize tty_port
Date: Mon,  2 Apr 2012 13:53:46 +0200
Message-Id: <1333367693-3244-3-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
References: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tty_port used in the driver is left uninitialized. Add the
initialization there.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: linux-cris-kernel@axis.com
---
 drivers/tty/serial/crisv10.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/tty/serial/crisv10.c b/drivers/tty/serial/crisv10.c
index 004ee2e..80b6b1b 100644
--- a/drivers/tty/serial/crisv10.c
+++ b/drivers/tty/serial/crisv10.c
@@ -4462,6 +4462,7 @@ static int __init rs_init(void)
 				info->enabled = 0;
 			}
 		}
+		tty_port_init(&info->port);
 		info->uses_dma_in = 0;
 		info->uses_dma_out = 0;
 		info->line = i;
-- 
1.7.9.2


