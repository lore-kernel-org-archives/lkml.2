Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932303Ab1CWIuK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 04:50:10 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:56911 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088Ab1CWIuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 04:50:06 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: jirislaby@gmail.com
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 4/7] TTY: VT, remove unused variables
Date: Wed, 23 Mar 2011 09:49:57 +0100
Message-Id: <1300870200-24405-4-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300870200-24405-1-git-send-email-jslaby@suse.cz>
References: <1300870200-24405-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/tty/vt/vt.c:892:2: warning: Value stored to 'old_screen_size' is never read
        old_screen_size = vc->vc_screenbuf_size;
        ^                 ~~~~~~~~~~~~~~~~~~~~~
drivers/tty/vt/vt.c:890:2: warning: Value stored to 'old_cols' is never read
	old_cols = vc->vc_cols;
	^          ~~~~~~~~~~~

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/tty/vt/vt.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index c83cdfb..10e9854 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -858,7 +858,7 @@ static int vc_do_resize(struct tty_struct *tty, struct vc_data *vc,
 {
 	unsigned long old_origin, new_origin, new_scr_end, rlth, rrem, err = 0;
 	unsigned long end;
-	unsigned int old_cols, old_rows, old_row_size, old_screen_size;
+	unsigned int old_rows, old_row_size;
 	unsigned int new_cols, new_rows, new_row_size, new_screen_size;
 	unsigned int user;
 	unsigned short *newscreen;
@@ -887,9 +887,7 @@ static int vc_do_resize(struct tty_struct *tty, struct vc_data *vc,
 		return -ENOMEM;
 
 	old_rows = vc->vc_rows;
-	old_cols = vc->vc_cols;
 	old_row_size = vc->vc_size_row;
-	old_screen_size = vc->vc_screenbuf_size;
 
 	err = resize_screen(vc, new_cols, new_rows, user);
 	if (err) {
-- 
1.7.4.1


