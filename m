Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430Ab1IWQjP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 12:39:15 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:54164 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147Ab1IWQjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 12:39:11 -0400
From: Kautuk Consul <consul.kautuk@gmail.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>, Jiri Kosina <trivial@kernel.org>,
        jkosina@suse.cz
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kautuk Consul <consul.kautuk@gmail.com>
Subject: [PATCH 1/1] Trivial: mnt_want_write: Remove unused label out
Date: Fri, 23 Sep 2011 22:08:29 +0530
Message-Id: <1316795909-3722-1-git-send-email-consul.kautuk@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was studying the code and I saw that the out label is not being used 
at all so I removed it and its usage from the function.

Signed-off-by: Kautuk Consul <consul.kautuk@gmail.com>
---
 fs/namespace.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 22bfe82..2e906e9 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -352,9 +352,7 @@ int mnt_want_write(struct vfsmount *mnt)
 	if (__mnt_is_readonly(mnt)) {
 		mnt_dec_writers(mnt);
 		ret = -EROFS;
-		goto out;
 	}
-out:
 	preempt_enable();
 	return ret;
 }
-- 
1.7.4.1

