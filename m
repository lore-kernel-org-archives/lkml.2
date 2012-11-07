Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754638Ab2KGKCx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 05:02:53 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:20428 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751573Ab2KGKCu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 05:02:50 -0500
Subject: [PATCH 4/4] ipc: add more comments to message copying related code
To: akpm@linux-foundation.org
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: ebiederm@xmission.com, devel@openvz.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, jmorris@namei.org
Date: Wed, 07 Nov 2012 13:05:10 +0300
Message-ID: <20121107100510.22846.706.stgit@localhost.localdomain>
In-Reply-To: <20121107100317.22846.94715.stgit@localhost.localdomain>
References: <20121107100317.22846.94715.stgit@localhost.localdomain>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
---
 ipc/msg.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/ipc/msg.c b/ipc/msg.c
index 5e317fe..4a4725c 100644
--- a/ipc/msg.c
+++ b/ipc/msg.c
@@ -770,6 +770,10 @@ static long do_msg_fill(void __user *dest, struct msg_msg *msg, size_t bufsz)
 }
 
 #ifdef CONFIG_CHECKPOINT_RESTORE
+/*
+ * This function creates new kernel message structure, large enough to store
+ * bufsz message bytes.
+ */
 static inline struct msg_msg *prepare_copy(void __user *buf, size_t bufsz,
 					   int msgflg, long *msgtyp,
 					   unsigned long *copy_number)
@@ -881,6 +885,10 @@ long do_msgrcv(int msqid, void __user *buf, size_t bufsz, long msgtyp,
 				msg = ERR_PTR(-E2BIG);
 				goto out_unlock;
 			}
+			/*
+			 * If we are copying, then do not unlink message and do
+			 * not update queue parameters.
+			 */
 			if (msgflg & MSG_COPY)
 				goto out_unlock;
 			list_del(&msg->m_list);

