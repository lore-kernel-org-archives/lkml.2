Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935072Ab1ETAMc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 20:12:32 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:48135 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935025Ab1ETAM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 20:12:26 -0400
X-Sasl-enc: kE3ZxsJQ0XfhlTX0O++mvajt0CtzeWJO6UV8iHU9DUsB 1305850346
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Stephen Boyd <sboyd@codeaurora.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 44/44] debugfs: Silence DEBUG_STRICT_USER_COPY_CHECKS=y warning
Date: Thu, 19 May 2011 17:11:02 -0700
Message-Id: <1305850262-9575-44-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.4.2
In-Reply-To: <1305850262-9575-1-git-send-email-gregkh@suse.de>
References: <20110520000821.GA9367@kroah.com>
 <1305850262-9575-1-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Boyd <sboyd@codeaurora.org>

Enabling DEBUG_STRICT_USER_COPY_CHECKS causes the following
warning:

In file included from arch/x86/include/asm/uaccess.h:573,
                 from include/linux/uaccess.h:5,
                 from include/linux/highmem.h:7,
                 from include/linux/pagemap.h:10,
                 from fs/debugfs/file.c:18:
In function 'copy_from_user',
    inlined from 'write_file_bool' at fs/debugfs/file.c:435:
arch/x86/include/asm/uaccess_64.h:65: warning: call to
'copy_from_user_overflow' declared with attribute warning:
copy_from_user() buffer size is not provably correct

presumably due to buf_size being signed causing GCC to fail to
see that buf_size can't become negative.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/debugfs/file.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/debugfs/file.c b/fs/debugfs/file.c
index 568304d..90f7657 100644
--- a/fs/debugfs/file.c
+++ b/fs/debugfs/file.c
@@ -428,7 +428,7 @@ static ssize_t write_file_bool(struct file *file, const char __user *user_buf,
 			       size_t count, loff_t *ppos)
 {
 	char buf[32];
-	int buf_size;
+	size_t buf_size;
 	bool bv;
 	u32 *val = file->private_data;
 
-- 
1.7.4.2

