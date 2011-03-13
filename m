Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756284Ab1CMT5V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 15:57:21 -0400
Received: from mout.perfora.net ([74.208.4.195]:52899 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755361Ab1CMT5U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 15:57:20 -0400
From: Stephen Wilson <wilsons@start.ca>
To: Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Michel Lespinasse <walken@google.com>, Andi Kleen <ak@linux.intel.com>,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Matt Mackall <mpm@selenic.com>, David Rientjes <rientjes@google.com>,
        Nick Piggin <npiggin@kernel.dk>,
        Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, x86@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Stephen Wilson <wilsons@start.ca>
Subject: [PATCH 12/12] proc: enable writing to /proc/pid/mem
Date: Sun, 13 Mar 2011 15:49:24 -0400
Message-Id: <1300045764-24168-13-git-send-email-wilsons@start.ca>
X-Mailer: git-send-email 1.7.3.5
In-Reply-To: <1300045764-24168-1-git-send-email-wilsons@start.ca>
References: <1300045764-24168-1-git-send-email-wilsons@start.ca>
X-Provags-ID: V02:K0:hvcA7sS8pymFSEu75q20EaiNJAvOPADYGxBzYIlRFjZ
 ToHMZaZUC+tYLWe421OSKleedST1dfofWd+mqIW88LP8jRcme8
 Wp54bJMgpyv3UKANaEIdbiTav17mofPbXytCEKkGR3/NdQUPln
 pM33I2eyyoTPdMoj20W7IIEWO5Y7yLXKaqAc3WxAE8ZzyKyXBW
 iMB5MFr+S0soudkWO8seW2bsazxI8b1mc0J6P5H3Ks=
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
index 2af83bd..964bc5d 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -852,10 +852,6 @@ out_no_task:
 	return ret;
 }
 
-#define mem_write NULL
-
-#ifndef mem_write
-/* This is a security hazard */
 static ssize_t mem_write(struct file * file, const char __user *buf,
 			 size_t count, loff_t *ppos)
 {
@@ -912,7 +908,6 @@ out_task:
 out_no_task:
 	return copied;
 }
-#endif
 
 loff_t mem_lseek(struct file *file, loff_t offset, int orig)
 {
-- 
1.7.3.5

