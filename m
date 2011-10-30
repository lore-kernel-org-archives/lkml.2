Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934256Ab1J3QiP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Oct 2011 12:38:15 -0400
Received: from casper.infradead.org ([85.118.1.10]:41902 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934235Ab1J3QiM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Oct 2011 12:38:12 -0400
Date: Sun, 30 Oct 2011 09:42:34 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: gregkh@suse.de
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] tty: remove the (now) unused tty_default_fops()
 function
Message-ID: <20111030094234.276fb8aa@infradead.org>
In-Reply-To: <20111030094038.7046d529@infradead.org>
References: <20111030094038.7046d529@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 0e52df366ca86e54b8dec9bf6617cee065c9f359 Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Sat, 29 Oct 2011 10:48:37 -0700
Subject: [PATCH 3/3] tty: remove the (now) unused tty_default_fops() function

Now that the pty code uses compile time initialization for its
ptmx file operations structure, the tty_default_fops() is completely
unused.
This patch removes it.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 drivers/tty/tty_io.c |    5 -----
 include/linux/tty.h  |    1 -
 2 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 1f79760..0eb1df5 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -3201,11 +3201,6 @@ struct tty_struct *get_current_tty(void)
 }
 EXPORT_SYMBOL_GPL(get_current_tty);
 
-void tty_default_fops(struct file_operations *fops)
-{
-	*fops = tty_fops;
-}
-
 /*
  * Initialize the console device. This is called *early*, so
  * we can't necessarily depend on lots of kernel help here.
diff --git a/include/linux/tty.h b/include/linux/tty.h
index f1ba6c1..1831c24 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -472,7 +472,6 @@ extern int tty_perform_flush(struct tty_struct *tty, unsigned long arg);
 extern dev_t tty_devnum(struct tty_struct *tty);
 extern void proc_clear_tty(struct task_struct *p);
 extern struct tty_struct *get_current_tty(void);
-extern void tty_default_fops(struct file_operations *fops);
 extern struct tty_struct *alloc_tty_struct(void);
 extern int tty_add_file(struct tty_struct *tty, struct file *file);
 extern void free_tty_struct(struct tty_struct *tty);
-- 
1.7.6



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
