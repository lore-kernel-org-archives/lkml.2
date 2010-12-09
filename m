Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757238Ab0LIUIB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 15:08:01 -0500
Received: from mail.perches.com ([173.55.12.10]:2404 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757060Ab0LIUEN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 15:04:13 -0500
From: Joe Perches <joe@perches.com>
To: David Brownell <dbrownell@users.sourceforge.net>
Cc: Jiri Kosina <trivial@kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 08/15] gadget: Remove duplicate unlikely from IS_ERR
Date: Thu,  9 Dec 2010 12:04:01 -0800
Message-Id: <ccf227058494b903a84b66f4a56249373d9c5897.1291923889.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.3.464.gf80b6
In-Reply-To: <1291906801-1389-2-git-send-email-tklauser@distanz.ch>
References: <1291906801-1389-2-git-send-email-tklauser@distanz.ch>
In-Reply-To: <cover.1291923888.git.joe@perches.com>
References: <cover.1291923888.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IS_ERR already uses unlikely, remove unlikely from the call sites.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/usb/gadget/f_fs.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/f_fs.c b/drivers/usb/gadget/f_fs.c
index a21349c..1499f9e 100644
--- a/drivers/usb/gadget/f_fs.c
+++ b/drivers/usb/gadget/f_fs.c
@@ -426,7 +426,7 @@ static ssize_t ffs_ep0_write(struct file *file, const char __user *buf,
 		}
 
 		data = ffs_prepare_buffer(buf, len);
-		if (unlikely(IS_ERR(data))) {
+		if (IS_ERR(data)) {
 			ret = PTR_ERR(data);
 			break;
 		}
@@ -499,7 +499,7 @@ static ssize_t ffs_ep0_write(struct file *file, const char __user *buf,
 		spin_unlock_irq(&ffs->ev.waitq.lock);
 
 		data = ffs_prepare_buffer(buf, len);
-		if (unlikely(IS_ERR(data))) {
+		if (IS_ERR(data)) {
 			ret = PTR_ERR(data);
 			break;
 		}
-- 
1.7.3.3.464.gf80b6

