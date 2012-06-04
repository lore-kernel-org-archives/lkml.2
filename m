Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932260Ab2FDLkd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 07:40:33 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:45000 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754966Ab2FDLfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 07:35:44 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: [PATCH 14/24] PTY: remove one empty ops->remove
Date: Mon,  4 Jun 2012 13:35:28 +0200
Message-Id: <1338809738-18967-15-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.10.3
In-Reply-To: <1338809738-18967-1-git-send-email-jslaby@suse.cz>
References: <1338809738-18967-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, there are two as a left-over from previous patches.
Although we really need to provide an empty handler, we do not need
two. So remove one of them.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/tty/pty.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
index 5505ffc..4bcaf89 100644
--- a/drivers/tty/pty.c
+++ b/drivers/tty/pty.c
@@ -557,18 +557,14 @@ err_free_tty:
 	return -ENOMEM;
 }
 
-static void ptm_unix98_remove(struct tty_driver *driver, struct tty_struct *tty)
-{
-}
-
-static void pts_unix98_remove(struct tty_driver *driver, struct tty_struct *tty)
+static void pty_unix98_remove(struct tty_driver *driver, struct tty_struct *tty)
 {
 }
 
 static const struct tty_operations ptm_unix98_ops = {
 	.lookup = ptm_unix98_lookup,
 	.install = pty_unix98_install,
-	.remove = ptm_unix98_remove,
+	.remove = pty_unix98_remove,
 	.open = pty_open,
 	.close = pty_close,
 	.write = pty_write,
@@ -585,7 +581,7 @@ static const struct tty_operations ptm_unix98_ops = {
 static const struct tty_operations pty_unix98_ops = {
 	.lookup = pts_unix98_lookup,
 	.install = pty_unix98_install,
-	.remove = pts_unix98_remove,
+	.remove = pty_unix98_remove,
 	.open = pty_open,
 	.close = pty_close,
 	.write = pty_write,
-- 
1.7.10.3


