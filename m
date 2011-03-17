Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754419Ab1CQMhp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 08:37:45 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:56721 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753257Ab1CQMhn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 08:37:43 -0400
From: Richard Weinberger <richard@nod.at>
To: akpm@linux-foundation.org
Cc: alan@linux.intel.com, gregkh@suse.de,
        user-mode-linux-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, jdike@addtoit.com,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH] um: Remove file pointer from ioctl
Date: Thu, 17 Mar 2011 13:37:29 +0100
Message-Id: <1300365449-12548-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 6caa76b (tty: now phase out the ioctl file pointer for good)
removed the ioctl file pointer.
User Mode Linux's line driver uses this ioctl and needs a
signature update too.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/um/drivers/line.c        |    4 ++--
 arch/um/include/shared/line.h |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/um/drivers/line.c b/arch/um/drivers/line.c
index 050e4dd..35dd0b8 100644
--- a/arch/um/drivers/line.c
+++ b/arch/um/drivers/line.c
@@ -255,8 +255,8 @@ static const struct {
 	{ KDSIGACCEPT, KERN_INFO,  "KDSIGACCEPT" },
 };
 
-int line_ioctl(struct tty_struct *tty, struct file * file,
-	       unsigned int cmd, unsigned long arg)
+int line_ioctl(struct tty_struct *tty, unsigned int cmd,
+				unsigned long arg)
 {
 	int ret;
 	int i;
diff --git a/arch/um/include/shared/line.h b/arch/um/include/shared/line.h
index 311a0d3..72f4f25 100644
--- a/arch/um/include/shared/line.h
+++ b/arch/um/include/shared/line.h
@@ -77,8 +77,8 @@ extern int line_chars_in_buffer(struct tty_struct *tty);
 extern void line_flush_buffer(struct tty_struct *tty);
 extern void line_flush_chars(struct tty_struct *tty);
 extern int line_write_room(struct tty_struct *tty);
-extern int line_ioctl(struct tty_struct *tty, struct file * file,
-		      unsigned int cmd, unsigned long arg);
+extern int line_ioctl(struct tty_struct *tty, unsigned int cmd,
+				unsigned long arg);
 extern void line_throttle(struct tty_struct *tty);
 extern void line_unthrottle(struct tty_struct *tty);
 
-- 
1.6.6.1

