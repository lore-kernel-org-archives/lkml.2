Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753733Ab0DIODH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 10:03:07 -0400
Received: from cantor.suse.de ([195.135.220.2]:45357 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752698Ab0DIOB0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 10:01:26 -0400
From: Jan Blunck <jblunck@suse.de>
To: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
       Alan Cox <alan@linux.intel.com>, Jan Blunck <jblunck@suse.de>
Subject: [PATCH 06/12] zcrypt: Use nonseekable_open()
Date: Fri,  9 Apr 2010 16:00:49 +0200
Message-Id: <1270821655-4368-7-git-send-email-jblunck@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1270821655-4368-1-git-send-email-jblunck@suse.de>
References: <1270821655-4368-1-git-send-email-jblunck@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

zcrypt doesn't even allow to read/write the files it opens. So seeking on
it shouldn't fall back to defaults either but should be disallowed as well.

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 drivers/s390/crypto/zcrypt_api.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/s390/crypto/zcrypt_api.c b/drivers/s390/crypto/zcrypt_api.c
index ba50fe0..18a986d 100644
--- a/drivers/s390/crypto/zcrypt_api.c
+++ b/drivers/s390/crypto/zcrypt_api.c
@@ -301,7 +301,7 @@ static ssize_t zcrypt_write(struct file *filp, const char __user *buf,
 static int zcrypt_open(struct inode *inode, struct file *filp)
 {
 	atomic_inc(&zcrypt_open_count);
-	return 0;
+	return nonseekable_open(inode, filp);
 }
 
 /**
-- 
1.6.4.2

