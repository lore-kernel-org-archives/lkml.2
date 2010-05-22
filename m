Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753776Ab0EVJ7h (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 05:59:37 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:35909 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753084Ab0EVJ7e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 05:59:34 -0400
Date: Sat, 22 May 2010 11:59:29 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 1/8] ipc/sem.c: Use ERR_CAST
Message-ID: <Pine.LNX.4.64.1005221159101.13021@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Use ERR_CAST(x) rather than ERR_PTR(PTR_ERR(x)).  The former makes more
clear what is the purpose of the operation, which otherwise looks like a
no-op.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
type T;
T x;
identifier f;
@@

T f (...) { <+...
- ERR_PTR(PTR_ERR(x))
+ x
 ...+> }

@@
expression x;
@@

- ERR_PTR(PTR_ERR(x))
+ ERR_CAST(x)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 ipc/sem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -u -p a/ipc/sem.c b/ipc/sem.c
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -1069,7 +1069,7 @@ static struct sem_undo *find_alloc_undo(
 	/* step 1: figure out the size of the semaphore array */
 	sma = sem_lock_check(ns, semid);
 	if (IS_ERR(sma))
-		return ERR_PTR(PTR_ERR(sma));
+		return ERR_CAST(sma);
 
 	nsems = sma->sem_nsems;
 	sem_getref_and_unlock(sma);
