Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071Ab2HLMSN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2012 08:18:13 -0400
Received: from mail1.windriver.com ([147.11.146.13]:36013 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722Ab2HLMRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2012 08:17:21 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: <kgdb-bugreport@lists.sourceforge.net>,
        Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 4/4] kgdboc: Accept either kbd or kdb to activate the vga + keyboard kdb shell
Date: Sun, 12 Aug 2012 07:16:45 -0500
Message-ID: <1344773805-12844-4-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1344773805-12844-1-git-send-email-jason.wessel@windriver.com>
References: <1344773805-12844-1-git-send-email-jason.wessel@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is a common enough mistake for people to specify "kdb" when they
meant to type "kbd" that the kgdboc can just accept both since they
both mean the same thing anyway.  Specifically it is for the case
where you want kdb to be active on your graphics console + keyboard
(where kbd was the original abbreviation for keyboard).

With this change kgdboc will now accept either to mean the same thing:
   kgdboc=kbd
   kgdboc=kdb

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 drivers/tty/serial/kgdboc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/kgdboc.c b/drivers/tty/serial/kgdboc.c
index 2b42a01..509e714 100644
--- a/drivers/tty/serial/kgdboc.c
+++ b/drivers/tty/serial/kgdboc.c
@@ -97,7 +97,8 @@ static void kgdboc_restore_input(void)
 
 static int kgdboc_register_kbd(char **cptr)
 {
-	if (strncmp(*cptr, "kbd", 3) == 0) {
+	if (strncmp(*cptr, "kbd", 3) == 0 ||
+		strncmp(*cptr, "kdb", 3) == 0) {
 		if (kdb_poll_idx < KDB_POLL_FUNC_MAX) {
 			kdb_poll_funcs[kdb_poll_idx] = kdb_get_kbd_char;
 			kdb_poll_idx++;
-- 
1.7.9.5

