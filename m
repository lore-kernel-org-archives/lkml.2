Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758483Ab2HJOVg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 10:21:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20008 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754871Ab2HJOVf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 10:21:35 -0400
Date: Fri, 10 Aug 2012 23:08:48 +0900 (JST)
Message-Id: <20120810.230848.945503091743716021.yamato@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 08/15] Declaring unix protocols has its own proc entry
From: Masatake YAMATO <yamato@redhat.com>
Organization: Red Hat Japan, Inc.
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Declaring unix protocols has its own proc entry.

Signed-off-by: Masatake YAMATO <yamato@redhat.com>
---
 net/unix/af_unix.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index e4768c1..e2d9869 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -616,6 +616,9 @@ static struct proto unix_proto = {
 	.name			= "UNIX",
 	.owner			= THIS_MODULE,
 	.obj_size		= sizeof(struct unix_sock),
+#ifdef CONFIG_PROC_FS
+	.has_own_proc_entry= 1,
+#endif
 };
 
 /*
-- 
1.7.11.2

