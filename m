Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933610Ab1DNR5L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 13:57:11 -0400
Received: from mail.windriver.com ([147.11.1.11]:38275 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933216Ab1DNRqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:46:40 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Vasiliy Kulikov <segooon@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 044/209] ipc: shm: fix information leak to userland
Date: Thu, 14 Apr 2011 13:41:14 -0400
Message-Id: <1302803039-9400-45-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vasiliy Kulikov <segooon@gmail.com>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

commit 3af54c9bd9e6f14f896aac1bb0e8405ae0bc7a44 upstream.

The shmid_ds structure is copied to userland with shm_unused{,2,3}
fields unitialized.  It leads to leaking of contents of kernel stack
memory.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
Acked-by: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 ipc/shm.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/ipc/shm.c b/ipc/shm.c
index 1a314c8..2225a77 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -476,6 +476,7 @@ static inline unsigned long copy_shmid_to_user(void __user *buf, struct shmid64_
 	    {
 		struct shmid_ds out;
 
+		memset(&out, 0, sizeof(out));
 		ipc64_perm_to_ipc_perm(&in->shm_perm, &out.shm_perm);
 		out.shm_segsz	= in->shm_segsz;
 		out.shm_atime	= in->shm_atime;
-- 
1.7.4.4

