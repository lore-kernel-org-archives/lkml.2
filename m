Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756135Ab0D0OZN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 10:25:13 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:65364 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756102Ab0D0OZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 10:25:07 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: John Kacur <jkacur@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jan Blunck <jblunck@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 6/7] coda/psdev: remove BKL from ioctl function
Date: Tue, 27 Apr 2010 16:24:24 +0200
Message-Id: <1272378265-10909-7-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <alpine.LFD.2.00.1004271359180.3318@localhost>
References: <alpine.LFD.2.00.1004271359180.3318@localhost>
X-Provags-ID: V01U2FsdGVkX18KeJREGTInZMP+w1XioXaUY8XtY4iaSn41KRB
 vfHqKd5Oj2DsGWYUgI54ZjQr60qEcyWiARC240sLIeWwlISy0C
 pVdraaWjbmOCnPEanVm+Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ioctl function returns constant results, so it obviously
does not need the BKL and can be converted to unlocked_ioctl.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 fs/coda/psdev.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/coda/psdev.c b/fs/coda/psdev.c
index be4392c..66b9cf7 100644
--- a/fs/coda/psdev.c
+++ b/fs/coda/psdev.c
@@ -73,8 +73,7 @@ static unsigned int coda_psdev_poll(struct file *file, poll_table * wait)
 	return mask;
 }
 
-static int coda_psdev_ioctl(struct inode * inode, struct file * filp, 
-			    unsigned int cmd, unsigned long arg)
+static long coda_psdev_ioctl(struct file * filp, unsigned int cmd, unsigned long arg)
 {
 	unsigned int data;
 
@@ -344,7 +343,7 @@ static const struct file_operations coda_psdev_fops = {
 	.read		= coda_psdev_read,
 	.write		= coda_psdev_write,
 	.poll		= coda_psdev_poll,
-	.ioctl		= coda_psdev_ioctl,
+	.unlocked_ioctl	= coda_psdev_ioctl,
 	.open		= coda_psdev_open,
 	.release	= coda_psdev_release,
 };
-- 
1.6.3.3

