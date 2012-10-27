Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759626Ab2J0WhW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 18:37:22 -0400
Received: from smtp-03.mandic.com.br ([200.225.81.143]:58400 "EHLO
	smtp-03.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759567Ab2J0WhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 18:37:21 -0400
From: Cesar Eduardo Barros <cesarb@cesarb.net>
To: Ming Lei <ming.lei@canonical.com>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org,
        Cesar Eduardo Barros <cesarb@cesarb.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] firmware: use noinline_for_stack
Date: Sat, 27 Oct 2012 20:37:10 -0200
Message-Id: <1351377430-21247-1-git-send-email-cesarb@cesarb.net>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The comment above fw_file_size() suggests it is noinline for stack size
reasons. Use noinline_for_stack to make this more clear.

Cc: Ming Lei <ming.lei@canonical.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
---
 drivers/base/firmware_class.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 8945f4e..620b876 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -275,7 +275,7 @@ static const char *fw_path[] = {
 };
 
 /* Don't inline this: 'struct kstat' is biggish */
-static noinline long fw_file_size(struct file *file)
+static noinline_for_stack long fw_file_size(struct file *file)
 {
 	struct kstat st;
 	if (vfs_getattr(file->f_path.mnt, file->f_path.dentry, &st))
-- 
1.7.11.7

