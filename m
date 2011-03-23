Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932113Ab1CWJtn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 05:49:43 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:54667 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754517Ab1CWJsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 05:48:43 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@suse.de
Cc: jirislaby@gmail.com, linux-kernel@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 6/6] TTY: fix fail path in tty_open
Date: Wed, 23 Mar 2011 10:48:37 +0100
Message-Id: <1300873717-27941-6-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300873717-27941-1-git-send-email-jslaby@suse.cz>
References: <1300873717-27941-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When tty_add_file fails we omit to clean up. Fix that by calling
tty_release appropriatelly.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
---
 drivers/tty/tty_io.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 48eb1aa..2ec3df9 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -1894,6 +1894,7 @@ got_driver:
 	retval = tty_add_file(tty, filp);
 	if (retval) {
 		tty_unlock();
+		tty_release(inode, filp);
 		return retval;
 	}
 
-- 
1.7.4.1


