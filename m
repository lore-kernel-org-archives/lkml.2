Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756236Ab1DHMZO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 08:25:14 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:49043 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755015Ab1DHMZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 08:25:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=CDGS1N6Gir7LB2BebanFJIaCSD6zQCBBJs19I4L/oZazjN8QWrg8G76ZP7pxvDyY/g
         UmFpxPOorz/uGybNnECo8dR57gmOoIUaqOufX6sL+w769fXDUz8ao3SyhbDXsdo4bT1H
         aHMawuZ1YMdjnhuWiGt1wiYG6bQfGbMcj8n78=
From: wanlong.gao@gmail.com
To: dmitry.torokhov@gmail.com
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wanlong Gao <wanlong.gao@gmail.com>
Subject: [PATCH] INPUT:Change a more clearly name for the input handlers' table
Date: Fri,  8 Apr 2011 20:23:44 +0800
Message-Id: <1302265424-4434-1-git-send-email-wanlong.gao@gmail.com>
X-Mailer: git-send-email 1.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wanlong Gao <wanlong.gao@gmail.com>

Change the input handlers' table name to input_handler_table for
making more clearly sense .

Signed-off-by: Wanlong Gao <wanlong.gao@gmail.com>
---
 drivers/input/input.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/input/input.c b/drivers/input/input.c
index d6e8bd8..00511dc 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -45,7 +45,7 @@ static LIST_HEAD(input_handler_list);
  */
 static DEFINE_MUTEX(input_mutex);
 
-static struct input_handler *input_table[8];
+static struct input_handler *input_handler_table[8];
 
 static inline int is_event_supported(unsigned int code,
 				     unsigned long *bm, unsigned int max)
@@ -1893,11 +1893,11 @@ int input_register_handler(struct input_handler *handler)
 	INIT_LIST_HEAD(&handler->h_list);
 
 	if (handler->fops != NULL) {
-		if (input_table[handler->minor >> 5]) {
+		if (input_handler_table[handler->minor >> 5]) {
 			retval = -EBUSY;
 			goto out;
 		}
-		input_table[handler->minor >> 5] = handler;
+		input_handler_table[handler->minor >> 5] = handler;
 	}
 
 	list_add_tail(&handler->node, &input_handler_list);
@@ -1933,7 +1933,7 @@ void input_unregister_handler(struct input_handler *handler)
 	list_del_init(&handler->node);
 
 	if (handler->fops != NULL)
-		input_table[handler->minor >> 5] = NULL;
+		input_handler_table[handler->minor >> 5] = NULL;
 
 	input_wakeup_procfs_readers();
 
@@ -2062,7 +2062,7 @@ static int input_open_file(struct inode *inode, struct file *file)
 		return err;
 
 	/* No load-on-demand here? */
-	handler = input_table[iminor(inode) >> 5];
+	handler = input_handler_table[iminor(inode) >> 5];
 	if (handler)
 		new_fops = fops_get(handler->fops);
 
-- 
1.7.3

