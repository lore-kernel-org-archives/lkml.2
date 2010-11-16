Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932221Ab0KPT6p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 14:58:45 -0500
Received: from smtp.outflux.net ([198.145.64.163]:46767 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758072Ab0KPT6o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 14:58:44 -0500
From: Kees Cook <kees.cook@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Pekka Enberg <penberg@kernel.org>, Joe Perches <joe@perches.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>, Jiri Slaby <jslaby@suse.cz>,
        "David S. Miller" <davem@davemloft.net>,
        Hugh Dickins <hughd@google.com>,
        Manfred Spraul <manfred@colorfullife.com>,
        Vasiliy Kulikov <segooon@gmail.com>
Subject: [PATCH] ipc: explicitly clear stack memory for shminfo
Date: Tue, 16 Nov 2010 11:58:28 -0800
Message-Id: <1289937508-19458-1-git-send-email-kees.cook@canonical.com>
X-Mailer: git-send-email 1.7.2.3
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes a kernel stack memory contents leak by explicitly clearing
the shminfo structure on the kernel stack before it is populated and
copied back to userspace.

Signed-off-by: Kees Cook <kees.cook@canonical.com>
Acked-by: Pekka Enberg <penberg@kernel.org>
---
 ipc/shm.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/ipc/shm.c b/ipc/shm.c
index 7d3bb22..1d3d41f 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -531,6 +531,7 @@ static inline unsigned long copy_shminfo_to_user(void __user *buf, struct shminf
 	    {
 		struct shminfo out;
 
+		memset(&out, 0, sizeof(out));
 		if(in->shmmax > INT_MAX)
 			out.shmmax = INT_MAX;
 		else
-- 
1.7.2.3

