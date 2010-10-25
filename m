Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758650Ab0JYX6Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 19:58:16 -0400
Received: from smtp.outflux.net ([198.145.64.163]:47801 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757539Ab0JYX6P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 19:58:15 -0400
Date: Mon, 25 Oct 2010 16:58:04 -0700
From: Kees Cook <kees.cook@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>, Jiri Slaby <jslaby@suse.cz>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH] ipc: explicitly clear stack memory in user structs
Message-ID: <20101025235804.GA11760@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CVE-2010-4072

The old shm interface will leak a few bytes of stack contents. Explicitly
clear structure using memset instead of C99-style initialization in case
there are ever holes in the packing.

Cc: stable <stable@kernel.org>
Signed-off-by: Kees Cook <kees.cook@canonical.com>
---

This was originally sent as http://lkml.org/lkml/2010/10/6/486 but was
never taken into any tree.

---
 ipc/shm.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/ipc/shm.c b/ipc/shm.c
index 52ed77e..f943b1e 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -473,6 +473,7 @@ static inline unsigned long copy_shmid_to_user(void __user *buf, struct shmid64_
 	    {
 		struct shmid_ds out;
 
+		memset(&out, 0, sizeof(out));
 		ipc64_perm_to_ipc_perm(&in->shm_perm, &out.shm_perm);
 		out.shm_segsz	= in->shm_segsz;
 		out.shm_atime	= in->shm_atime;
@@ -524,6 +525,7 @@ static inline unsigned long copy_shminfo_to_user(void __user *buf, struct shminf
 	    {
 		struct shminfo out;
 
+		memset(&out, 0, sizeof(out));
 		if(in->shmmax > INT_MAX)
 			out.shmmax = INT_MAX;
 		else
-- 
1.7.1

-- 
Kees Cook
Ubuntu Security Team
