Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759893Ab2FGIUe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 04:20:34 -0400
Received: from www84.your-server.de ([213.133.104.84]:39286 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752420Ab2FGIU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 04:20:27 -0400
From: stefani@seibold.net
To: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org, oneukum@suse.de
Cc: linux-usb@vger.kernel.org, Stefani Seibold <stefani@seibold.net>
Subject: [PATCH 01/13] fix wrong label in skel_open
Date: Thu,  7 Jun 2012 10:20:31 +0200
Message-Id: <1339057243-10029-2-git-send-email-stefani@seibold.net>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1339057243-10029-1-git-send-email-stefani@seibold.net>
References: <1339057243-10029-1-git-send-email-stefani@seibold.net>
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefani Seibold <stefani@seibold.net>

Signed-off-by: Stefani Seibold <stefani@seibold.net>
---
 drivers/usb/usb-skeleton.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/usb-skeleton.c b/drivers/usb/usb-skeleton.c
index 0616f23..efda3a5 100644
--- a/drivers/usb/usb-skeleton.c
+++ b/drivers/usb/usb-skeleton.c
@@ -114,10 +114,11 @@ static int skel_open(struct inode *inode, struct file *file)
 
 	retval = usb_autopm_get_interface(interface);
 	if (retval)
-		goto out_err;
+		goto exit2;
 
 	/* save our object in the file's private structure */
 	file->private_data = dev;
+exit2:
 	mutex_unlock(&dev->io_mutex);
 
 exit:
-- 
1.7.8.6

