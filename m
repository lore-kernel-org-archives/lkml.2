Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932765Ab1ELXuc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 19:50:32 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:13001 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758906Ab1ELXuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 19:50:17 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6344"; a="91115531"
From: Stephen Boyd <sboyd@codeaurora.org>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 4/9] debugfs: Silence DEBUG_STRICT_USER_COPY_CHECKS=y warning
Date: Thu, 12 May 2011 16:50:07 -0700
Message-Id: <1305244212-19183-5-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.5.1.217.g4e3aa
In-Reply-To: <1305244212-19183-1-git-send-email-sboyd@codeaurora.org>
References: <1305244212-19183-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 fs/debugfs/file.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/debugfs/file.c b/fs/debugfs/file.c
index 89d394d..7ead5b8 100644
--- a/fs/debugfs/file.c
+++ b/fs/debugfs/file.c
@@ -428,7 +428,7 @@ static ssize_t write_file_bool(struct file *file, const char __user *user_buf,
 			       size_t count, loff_t *ppos)
 {
 	char buf[32];
-	int buf_size;
+	size_t buf_size;
 	u32 *val = file->private_data;
 
 	buf_size = min(count, (sizeof(buf)-1));
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

