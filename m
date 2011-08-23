Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425Ab1HWVsT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 17:48:19 -0400
Received: from smtp-out.google.com ([74.125.121.67]:21190 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754434Ab1HWVsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 17:48:11 -0400
From: Thieu Le <thieule@chromium.org>
To: viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thieu Le <thieule@chromium.org>
Subject: [PATCH] vfs: Export do_fallocate() to kernel modules
Date: Tue, 23 Aug 2011 14:47:55 -0700
Message-Id: <1314136075-8784-1-git-send-email-thieule@chromium.org>
X-Mailer: git-send-email 1.7.3.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export do_fallocate() so layered file systems such as ecryptfs can take
advantage of this interface.  Existing interfaces to the fallocate
facilities require a file descriptor which is not available to layered
file systems.

Signed-off-by: Thieu Le <thieule@chromium.org>
---
 fs/open.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index f711921..5c3bcba 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -268,6 +268,7 @@ int do_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 
 	return file->f_op->fallocate(file, mode, offset, len);
 }
+EXPORT_SYMBOL_GPL(do_fallocate);
 
 SYSCALL_DEFINE(fallocate)(int fd, int mode, loff_t offset, loff_t len)
 {
-- 
1.7.3.1

