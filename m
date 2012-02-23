Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985Ab2BWEFq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 23:05:46 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:48214 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753403Ab2BWEFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 23:05:44 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of pshelar@nicira.com designates 10.68.226.166 as permitted sender) smtp.mail=pshelar@nicira.com
MIME-Version: 1.0
From: Pravin B Shelar <pshelar@nicira.com>
To: jpettit@nicira.com, ebiederm@xmission.com, linux-kernel@vger.kernel.org
Cc: jesse@nicira.com, Pravin B Shelar <pshelar@nicira.com>
Subject: [PATCH] proc-ns: Use d_set_d_op() API to set dentry ops in proc_ns_instantiate().
Date: Wed, 22 Feb 2012 20:05:28 -0800
Message-Id: <1329969928-11176-1-git-send-email-pshelar@nicira.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use d_set_d_op() so that DCACHE_OP_* flags are set correctly which fixes ns
cleanup path i.e. `ip netns delete `.

Reported-by: Justin Pettit <jpettit@nicira.com>
Signed-off-by: Pravin B Shelar <pshelar@nicira.com>

---
 fs/proc/namespaces.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/proc/namespaces.c b/fs/proc/namespaces.c
index 27da860..3551f1f 100644
--- a/fs/proc/namespaces.c
+++ b/fs/proc/namespaces.c
@@ -53,7 +53,7 @@ static struct dentry *proc_ns_instantiate(struct inode *dir,
 	ei->ns_ops    = ns_ops;
 	ei->ns	      = ns;
 
-	dentry->d_op = &pid_dentry_operations;
+	d_set_d_op(dentry, &pid_dentry_operations);
 	d_add(dentry, inode);
 	/* Close the race of the process dying before we return the dentry */
 	if (pid_revalidate(dentry, NULL))
-- 
1.7.1

