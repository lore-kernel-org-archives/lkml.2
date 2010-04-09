Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753632Ab0DIODk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 10:03:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36383 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752674Ab0DIOBZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 10:01:25 -0400
From: Jan Blunck <jblunck@suse.de>
To: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
       Alan Cox <alan@linux.intel.com>, Jan Blunck <jblunck@suse.de>
Subject: [PATCH 05/12] mISDN: Remove unnecessary test on f_pos
Date: Fri,  9 Apr 2010 16:00:48 +0200
Message-Id: <1270821655-4368-6-git-send-email-jblunck@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1270821655-4368-1-git-send-email-jblunck@suse.de>
References: <1270821655-4368-1-git-send-email-jblunck@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This test is not doing anything since it is always false if the mISDN_read()
is called from vfs_read(). Besides that the driver uses nonseekable_open()
and is not using off or file->f_pos anywhere.

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 drivers/isdn/mISDN/timerdev.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/isdn/mISDN/timerdev.c b/drivers/isdn/mISDN/timerdev.c
index 5b7e9bf..0a8b440 100644
--- a/drivers/isdn/mISDN/timerdev.c
+++ b/drivers/isdn/mISDN/timerdev.c
@@ -96,8 +96,6 @@ mISDN_read(struct file *filep, char __user *buf, size_t count, loff_t *off)
 	if (*debug & DEBUG_TIMER)
 		printk(KERN_DEBUG "%s(%p, %p, %d, %p)\n", __func__,
 			filep, buf, (int)count, off);
-	if (*off != filep->f_pos)
-		return -ESPIPE;
 
 	if (list_empty(&dev->expired) && (dev->work == 0)) {
 		if (filep->f_flags & O_NONBLOCK)
-- 
1.6.4.2

