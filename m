Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756100Ab0D0OZH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 10:25:07 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:57281 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756063Ab0D0OZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 10:25:04 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: John Kacur <jkacur@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jan Blunck <jblunck@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 5/7] um/mmapper: remove BKL usage
Date: Tue, 27 Apr 2010 16:24:23 +0200
Message-Id: <1272378265-10909-6-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <alpine.LFD.2.00.1004271359180.3318@localhost>
References: <alpine.LFD.2.00.1004271359180.3318@localhost>
X-Provags-ID: V01U2FsdGVkX19M24tfqfK2ZPjTD0/JHqLvbZeXaMs+qFyC5CT
 SSbvwZjFJ9+QwEA27IJEl/g8aKJsTFNOio66YhP0wyRBmAOVk8
 toLk9tcovE1vl5DzmxNWw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An empty function does not need the BKL, so just remove it.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/um/drivers/mmapper_kern.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/um/drivers/mmapper_kern.c b/arch/um/drivers/mmapper_kern.c
index d22f9e5..7158393 100644
--- a/arch/um/drivers/mmapper_kern.c
+++ b/arch/um/drivers/mmapper_kern.c
@@ -46,8 +46,7 @@ static ssize_t mmapper_write(struct file *file, const char __user *buf,
 	return count;
 }
 
-static int mmapper_ioctl(struct inode *inode, struct file *file,
-			 unsigned int cmd, unsigned long arg)
+static long mmapper_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	return -ENOIOCTLCMD;
 }
@@ -90,7 +89,7 @@ static const struct file_operations mmapper_fops = {
 	.owner		= THIS_MODULE,
 	.read		= mmapper_read,
 	.write		= mmapper_write,
-	.ioctl		= mmapper_ioctl,
+	.unlocked_ioctl	= mmapper_ioctl,
 	.mmap		= mmapper_mmap,
 	.open		= mmapper_open,
 	.release	= mmapper_release,
-- 
1.6.3.3

