Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757701Ab0GGVnR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 17:43:17 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:57426 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757667Ab0GGVkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 17:40:42 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: John Kacur <jkacur@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@lst.de>,
       Christoph Hellwig <hch@infradead.org>,
       Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org
Subject: [PATCH 18/18] vfs: make no_llseek the default
Date: Wed,  7 Jul 2010 23:40:20 +0200
Message-Id: <1278538820-1392-19-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1278538820-1392-1-git-send-email-arnd@arndb.de>
References: <1278538820-1392-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:S7RjoyxVgY1j/KqP0uSoxrxixgOD0iwrgt4eCdcP5Vu
 XZkuSa6QtddFCZ5MbzzHL5YIdQxxVTquGDH72sO692RCHsa4f0
 CWhMyqbyaWxCxNH81xBjTIOKPwkqsQ8rMl+EF8vxeLv5lbNyup
 s7qdjTTp5lqJe4DLqjcKc8byVSQuX4jeDNoNbeQfZkDkgSgg9W
 EoC0xeOIye29PUt3/jURw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All file operations now have an explicit .llseek
operation pointer, so we can change the default
action for future code.

This makes changes the default from default_llseek
to no_llseek, which always returns -ESPIPE if
a user tries to seek on a file without a .llseek
operation.

The name of the default_llseek function remains
unchanged, if anyone thinks we should change it,
please speak up.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org
---
 fs/read_write.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index 31c0be7..d2ed19a 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -156,7 +156,6 @@ loff_t vfs_llseek(struct file *file, loff_t offset, int origin)
 
 	fn = no_llseek;
 	if (file->f_mode & FMODE_LSEEK) {
-		fn = default_llseek;
 		if (file->f_op && file->f_op->llseek)
 			fn = file->f_op->llseek;
 	}
-- 
1.7.1

