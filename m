Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755791Ab0GLUyb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 16:54:31 -0400
Received: from mail.perches.com ([173.55.12.10]:1760 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754825Ab0GLUuy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 16:50:54 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org
Subject: [PATCH 19/36] drivers/usb/gadget: Remove unnecessary casts of private_data
Date: Mon, 12 Jul 2010 13:50:11 -0700
Message-Id: <2ca088f9b83577f328c67334cc1e2e8470a866cc.1278967121.git.joe@perches.com>
X-Mailer: git-send-email 1.7.1.337.g6068.dirty
In-Reply-To: <cover.1278967120.git.joe@perches.com>
References: <cover.1278967120.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/usb/gadget/f_hid.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/gadget/f_hid.c b/drivers/usb/gadget/f_hid.c
index 1e00ff9..53e1202 100644
--- a/drivers/usb/gadget/f_hid.c
+++ b/drivers/usb/gadget/f_hid.c
@@ -142,7 +142,7 @@ static struct usb_descriptor_header *hidg_fs_descriptors[] = {
 static ssize_t f_hidg_read(struct file *file, char __user *buffer,
 			size_t count, loff_t *ptr)
 {
-	struct f_hidg	*hidg     = (struct f_hidg *)file->private_data;
+	struct f_hidg	*hidg     = file->private_data;
 	char		*tmp_buff = NULL;
 	unsigned long	flags;
 
@@ -200,7 +200,7 @@ static void f_hidg_req_complete(struct usb_ep *ep, struct usb_request *req)
 static ssize_t f_hidg_write(struct file *file, const char __user *buffer,
 			    size_t count, loff_t *offp)
 {
-	struct f_hidg *hidg  = (struct f_hidg *)file->private_data;
+	struct f_hidg *hidg  = file->private_data;
 	ssize_t status = -ENOMEM;
 
 	if (!access_ok(VERIFY_READ, buffer, count))
@@ -257,7 +257,7 @@ static ssize_t f_hidg_write(struct file *file, const char __user *buffer,
 
 static unsigned int f_hidg_poll(struct file *file, poll_table *wait)
 {
-	struct f_hidg	*hidg  = (struct f_hidg *)file->private_data;
+	struct f_hidg	*hidg  = file->private_data;
 	unsigned int	ret = 0;
 
 	poll_wait(file, &hidg->read_queue, wait);
-- 
1.7.1.337.g6068.dirty

