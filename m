Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753896Ab0KEDMo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 23:12:44 -0400
Received: from mail.perches.com ([173.55.12.10]:4147 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753793Ab0KEDI7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 23:08:59 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 33/49] drivers/s390: Use vzalloc
Date: Thu,  4 Nov 2010 20:07:57 -0700
Message-Id: <d52a1fa9af14a23c1b98e44a978e9535f9b41822.1288925425.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <alpine.DEB.2.00.1011031108260.11625@router.home>
References: <alpine.DEB.2.00.1011031108260.11625@router.home>
In-Reply-To: <cover.1288925424.git.joe@perches.com>
References: <cover.1288925424.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/s390/cio/blacklist.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/cio/blacklist.c b/drivers/s390/cio/blacklist.c
index 76058a5..08c6603 100644
--- a/drivers/s390/cio/blacklist.c
+++ b/drivers/s390/cio/blacklist.c
@@ -335,10 +335,9 @@ cio_ignore_write(struct file *file, const char __user *user_buf,
 		return -EINVAL;
 	if (user_len > 65536)
 		user_len = 65536;
-	buf = vmalloc (user_len + 1); /* maybe better use the stack? */
+	buf = vzalloc(user_len + 1); /* maybe better use the stack? */
 	if (buf == NULL)
 		return -ENOMEM;
-	memset(buf, 0, user_len + 1);
 
 	if (strncpy_from_user (buf, user_buf, user_len) < 0) {
 		rc = -EFAULT;
-- 
1.7.3.1.g432b3.dirty

