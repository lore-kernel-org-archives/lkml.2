Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030316Ab2CNCIY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 22:08:24 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:38425 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965196Ab2CNCIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 22:08:23 -0400
From: Jesse Gross <jesse@nicira.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Pravin B Shelar <pshelar@nicira.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Justin Pettit <jpettit@nicira.com>
Subject: [PATCH] proc-ns: Use d_set_d_op() API to set dentry ops in proc_ns_instantiate().
Date: Tue, 13 Mar 2012 19:08:17 -0700
Message-Id: <1331690897-26496-1-git-send-email-jesse@nicira.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pravin B Shelar <pshelar@nicira.com>

Use d_set_d_op() so that DCACHE_OP_* flags are set correctly which fixes ns
cleanup path i.e. `ip netns delete `.

This issue exists back to 3.0.

CC: Eric W. Biederman <ebiederm@xmission.com>
Reported-by: Justin Pettit <jpettit@nicira.com>
Signed-off-by: Pravin B Shelar <pshelar@nicira.com>
Signed-off-by: Jesse Gross <jesse@nicira.com>
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
1.7.5.4

