Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752083Ab2KHNjC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 08:39:02 -0500
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:39133 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751118Ab2KHNjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 08:39:00 -0500
From: Tao Ma <tm@tao.ma>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>
Subject: [PATCH] cgroup: set 'start' with the right value in cgroup_path.
Date: Thu,  8 Nov 2012 21:36:38 +0800
Message-Id: <1352381798-2357-1-git-send-email-tm@tao.ma>
X-Mailer: git-send-email 1.7.4.1
X-Identified-User: {1390:box585.bluehost.com:colyli:tao.ma} {sentby:smtp auth 122.224.222.226 authed with tm@tao.ma}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tao Ma <boyu.mt@taobao.com>

'start' is set to buf + buflen and do the '--' immediately.
Just set it to 'buf + buflen - 1' directly.

Cc: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>
---
 kernel/cgroup.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index f24f724..a9f8388 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1821,9 +1821,9 @@ int cgroup_path(const struct cgroup *cgrp, char *buf, int buflen)
 		return 0;
 	}
 
-	start = buf + buflen;
+	start = buf + buflen - 1;
 
-	*--start = '\0';
+	*start = '\0';
 	for (;;) {
 		int len = dentry->d_name.len;
 
-- 
1.7.1

