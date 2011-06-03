Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755154Ab1FCNHG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 09:07:06 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:43427 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755096Ab1FCNHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 09:07:03 -0400
X-Greylist: delayed 318 seconds by postgrey-1.27 at vger.kernel.org; Fri, 03 Jun 2011 09:07:02 EDT
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@suse.de
Cc: jirislaby@gmail.com, linux-kernel@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 2/2] TTY: ntty, add one more sanoty check
Date: Fri,  3 Jun 2011 15:01:36 +0200
Message-Id: <1307106096-6461-2-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.5.3
In-Reply-To: <1307106096-6461-1-git-send-email-jslaby@suse.cz>
References: <1307106096-6461-1-git-send-email-jslaby@suse.cz>
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


