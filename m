Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933861Ab1FWRis (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:38:48 -0400
Received: from mail.windriver.com ([147.11.1.11]:35651 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933849Ab1FWRin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:38:43 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Dan Rosenberg <drosenberg@vsecurity.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 237/247] CAN: Use inode instead of kernel address for /proc file
Date: Thu, 23 Jun 2011 13:35:05 -0400
Message-Id: <1308850515-15242-178-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Rosenberg <drosenberg@vsecurity.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 9f260e0efa4766e56d0ac14f1aeea6ee5eb8fe83 upstream.

Since the socket address is just being used as a unique identifier, its
inode number is an alternative that does not leak potentially sensitive
information.

CC-ing stable because MITRE has assigned CVE-2010-4565 to the issue.

Signed-off-by: Dan Rosenberg <drosenberg@vsecurity.com>
Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/can/bcm.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/can/bcm.c b/net/can/bcm.c
index b8f7a2f..dd23fb1 100644
--- a/net/can/bcm.c
+++ b/net/can/bcm.c
@@ -125,7 +125,7 @@ struct bcm_sock {
 	struct list_head tx_ops;
 	unsigned long dropped_usr_msgs;
 	struct proc_dir_entry *bcm_proc_read;
-	char procname [20]; /* pointer printed in ASCII with \0 */
+	char procname [32]; /* inode number in decimal with \0 */
 };
 
 static inline struct bcm_sock *bcm_sk(const struct sock *sk)
@@ -1523,7 +1523,7 @@ static int bcm_connect(struct socket *sock, struct sockaddr *uaddr, int len,
 
 	if (proc_dir) {
 		/* unique socket address as filename */
-		sprintf(bo->procname, "%p", sock);
+		sprintf(bo->procname, "%lu", sock_i_ino(sk));
 		bo->bcm_proc_read = proc_create_data(bo->procname, 0644,
 						     proc_dir,
 						     &bcm_proc_fops, sk);
-- 
1.7.4.4

