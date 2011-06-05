Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098Ab1FEMQ2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 08:16:28 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:34393 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755925Ab1FEMQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 08:16:26 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@suse.de
Cc: jirislaby@gmail.com, linux-kernel@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH v2 2/2] TTY: ntty, add one more sanity check
Date: Sun,  5 Jun 2011 14:16:17 +0200
Message-Id: <1307276177-20957-2-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.5.3
In-Reply-To: <1307276177-20957-1-git-send-email-jslaby@suse.cz>
References: <BANLkTik5QP7e=+FWSa1kLVpCjZpWEtF1PQ@mail.gmail.com>
 <1307276177-20957-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the previous patch, we fixed another bug where read_buf was freed
while we still was in n_tty_read. We currently check whether read_buf
is NULL at the start of the function. Add one more check after we wake
up from waiting for input.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
---
 drivers/tty/n_tty.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 95d0a9c..c62c856 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -1785,6 +1785,7 @@ do_it_again:
 				break;
 			}
 			timeout = schedule_timeout(timeout);
+			BUG_ON(!tty->read_buf);
 			continue;
 		}
 		__set_current_state(TASK_RUNNING);
-- 
1.7.5.3


