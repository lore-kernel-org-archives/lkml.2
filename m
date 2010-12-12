Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754994Ab0LMAPt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 19:15:49 -0500
Received: from one.firstfloor.org ([213.235.205.2]:35956 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754846Ab0LLXqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:46:23 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: segooon@gmail.com, viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org,
        gregkh@suse.de, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        stable@kernel.org
Subject: [PATCH] [83/223] ipc: shm: fix information leak to userland
Message-Id: <20101212234622.85AB0B27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:46:22 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Vasiliy Kulikov <segooon@gmail.com>

commit 3af54c9bd9e6f14f896aac1bb0e8405ae0bc7a44 upstream.

The shmid_ds structure is copied to userland with shm_unused{,2,3}
fields unitialized.  It leads to leaking of contents of kernel stack
memory.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
Acked-by: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 ipc/shm.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux/ipc/shm.c
===================================================================
--- linux.orig/ipc/shm.c
+++ linux/ipc/shm.c
@@ -473,6 +473,7 @@ static inline unsigned long copy_shmid_t
 	    {
 		struct shmid_ds out;
 
+		memset(&out, 0, sizeof(out));
 		ipc64_perm_to_ipc_perm(&in->shm_perm, &out.shm_perm);
 		out.shm_segsz	= in->shm_segsz;
 		out.shm_atime	= in->shm_atime;
