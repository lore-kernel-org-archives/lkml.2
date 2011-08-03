Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755275Ab1HCS1I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 14:27:08 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53577 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755187Ab1HCS1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 14:27:00 -0400
Date: Wed, 3 Aug 2011 22:26:55 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>,
        Manuel Lauss <manuel.lauss@googlemail.com>,
        Richard Weinberger <richard@nod.at>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        Marc Zyngier <marc.zyngier@arm.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] shm: fix wrong tests
Message-ID: <20110803182655.GA2865@albatros>
References: <20110803140456.GA14393@redhat.com>
 <20110803182417.GA2510@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110803182417.GA2510@albatros>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch 4c677e2eefdba9c5bfc4474e2e9 introduced a copy-paste bug.
Due to the bug cycle optimizations were disabled.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
---
 ipc/shm.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/ipc/shm.c b/ipc/shm.c
index bf46636..4e3c883 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -294,7 +294,7 @@ static int shm_try_destroy_orphaned(int id, void *p, void *data)
 void shm_destroy_orphaned(struct ipc_namespace *ns)
 {
 	down_write(&shm_ids(ns).rw_mutex);
-	if (&shm_ids(ns).in_use)
+	if (shm_ids(ns).in_use)
 		idr_for_each(&shm_ids(ns).ipcs_idr, &shm_try_destroy_orphaned, ns);
 	up_write(&shm_ids(ns).rw_mutex);
 }
@@ -306,7 +306,7 @@ void exit_shm(struct task_struct *task)
 
 	/* Destroy all already created segments, but not mapped yet */
 	down_write(&shm_ids(ns).rw_mutex);
-	if (&shm_ids(ns).in_use)
+	if (shm_ids(ns).in_use)
 		idr_for_each(&shm_ids(ns).ipcs_idr, &shm_try_destroy_current, ns);
 	up_write(&shm_ids(ns).rw_mutex);
 }
-- 
1.7.0.4

