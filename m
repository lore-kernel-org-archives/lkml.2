Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753716Ab2DFGQl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 02:16:41 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:60962 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689Ab2DFGQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 02:16:40 -0400
From: Liu Ping Fan <kernelfans@gmail.com>
To: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] pid: remove redundant condition
Date: Fri,  6 Apr 2012 14:16:29 +0800
Message-Id: <1333692989-9230-1-git-send-email-kernelfans@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Liu Ping Fan <pingfank@linux.vnet.ibm.com>

Signed-off-by: Liu Ping Fan <pingfank@linux.vnet.ibm.com>
---
 kernel/pid.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/kernel/pid.c b/kernel/pid.c
index 9f08dfa..e4ca244 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -248,8 +248,7 @@ void put_pid(struct pid *pid)
 		return;
 
 	ns = pid->numbers[pid->level].ns;
-	if ((atomic_read(&pid->count) == 1) ||
-	     atomic_dec_and_test(&pid->count)) {
+	if (atomic_dec_and_test(&pid->count) {
 		kmem_cache_free(ns->pid_cachep, pid);
 		put_pid_ns(ns);
 	}
-- 
1.7.4.4

