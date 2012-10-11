Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964893Ab2JKTIL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 15:08:11 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:58385 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933242Ab2JKTHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 15:07:47 -0400
From: j.glisse@gmail.com
To: linux-kernel@vger.kernel.org
Cc: roland@redhat.com, Jerome Glisse <jglisse@redhat.com>
Subject: [PATCH] coredump: always kill the task no matter what
Date: Thu, 11 Oct 2012 15:07:18 -0400
Message-Id: <1349982438-2062-1-git-send-email-j.glisse@gmail.com>
X-Mailer: git-send-email 1.7.12.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jerome Glisse <jglisse@redhat.com>

If do_coredump fails for any reason make sure that the task
is actualy wakeup and properly kill otherwise we endup with
zombies task.

Signed-off-by: Jerome Glisse <jglisse@redhat.com>
---
 fs/coredump.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/coredump.c b/fs/coredump.c
index fd37fac..4b61468 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -643,11 +643,11 @@ fail_dropcount:
 fail_unlock:
 	kfree(cn.corename);
 fail_corename:
-	coredump_finish(mm);
 	revert_creds(old_cred);
 fail_creds:
 	put_cred(cred);
 fail:
+	coredump_finish(mm);
 	return;
 }
 
-- 
1.7.12.1

