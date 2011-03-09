Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756969Ab1CIAp2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 19:45:28 -0500
Received: from mout.perfora.net ([74.208.4.195]:51644 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756520Ab1CIAp0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 19:45:26 -0500
From: Stephen Wilson <wilsons@start.ca>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Roland McGrath <roland@redhat.com>, Matt Mackall <mpm@selenic.com>,
        David Rientjes <rientjes@google.com>, Nick Piggin <npiggin@kernel.dk>,
        Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
        Ingo Molnar <mingo@elte.hu>, Michel Lespinasse <walken@google.com>,
        Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
        Stephen Wilson <wilsons@start.ca>
Subject: [PATCH 6/6] proc: enable writing to /proc/pid/mem
Date: Tue,  8 Mar 2011 19:42:23 -0500
Message-Id: <1299631343-4499-7-git-send-email-wilsons@start.ca>
X-Mailer: git-send-email 1.7.3.5
In-Reply-To: <1299631343-4499-1-git-send-email-wilsons@start.ca>
References: <1299631343-4499-1-git-send-email-wilsons@start.ca>
X-Provags-ID: V02:K0:6yau1/NDEJdGFBipobRjnjPRvFCT5jOWIR6eUIL8wkw
 JrVfswv4lleLeC/wItwaCsAsZONdGNc2PKfugfaXpxP8IYRKWz
 Dy+6AmyRyv3MlmAXNNlW26ZxLLuw/oZlFV9/Dw0FZi4jfbr+cg
 bjG3w/Swb8HXEXg9ZurHZvL7upSVmteEZcj3tzWR59Qdj9UuZ8
 b9RsznyGwYjC5rJWElIjY+IowRVXRyvYAK3WScgjK4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With recent changes there is no longer a security hazard with writing to
/proc/pid/mem.  Remove the #ifdef.

Signed-off-by: Stephen Wilson <wilsons@start.ca>
---
 fs/proc/base.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 5ffc927..41d9c46 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -833,10 +833,6 @@ out_no_task:
 	return ret;
 }
 
-#define mem_write NULL
-
-#ifndef mem_write
-/* This is a security hazard */
 static ssize_t mem_write(struct file * file, const char __user *buf,
 			 size_t count, loff_t *ppos)
 {
@@ -894,7 +890,6 @@ out:
 out_no_task:
 	return copied;
 }
-#endif
 
 loff_t mem_lseek(struct file *file, loff_t offset, int orig)
 {
-- 
1.7.3.5

