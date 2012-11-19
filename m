Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157Ab2KSFl5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 00:41:57 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:54832 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752920Ab2KSF3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 00:29:09 -0500
X-Originating-IP: 217.70.178.134
X-Originating-IP: 50.43.39.152
From: Josh Triplett <josh@joshtriplett.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc: Josh Triplett <josh@joshtriplett.org>
Subject: [PATCH 08/58] tty: Mark tty_del_file and __tty_hangup static
Date: Sun, 18 Nov 2012 21:27:47 -0800
Message-Id: <1353302917-13995-9-git-send-email-josh@joshtriplett.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
References: <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nothing outside of drivers/tty/tty_io.c references these functions, so
mark them static.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/tty/tty_io.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 2ea176b..023d1fd 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -237,7 +237,7 @@ void tty_free_file(struct file *file)
 }
 
 /* Delete file from its tty */
-void tty_del_file(struct file *file)
+static void tty_del_file(struct file *file)
 {
 	struct tty_file_private *priv = file->private_data;
 
@@ -555,7 +555,7 @@ EXPORT_SYMBOL_GPL(tty_wakeup);
  *		  tasklist_lock to walk task list for hangup event
  *		    ->siglock to protect ->signal/->sighand
  */
-void __tty_hangup(struct tty_struct *tty)
+static void __tty_hangup(struct tty_struct *tty)
 {
 	struct file *cons_filp = NULL;
 	struct file *filp, *f = NULL;
-- 
1.7.10.4

