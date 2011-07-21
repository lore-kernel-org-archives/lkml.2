Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752101Ab1GUAm6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 20:42:58 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:65439 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918Ab1GUAm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 20:42:57 -0400
X-Nat-Received: from [202.181.97.72]:56648 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1311208965.31986
Message-Id: <201107210042.p6L0gji8071518@www262.sakura.ne.jp>
Subject: Re: [PATCH linux-next-20110718] Fix build error at mm/slab.c .
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: penberg@kernel.org
Cc: linux-kernel@vger.kernel.org, cl@linux.com
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Thu, 21 Jul 2011 09:42:45 +0900
References: <201107200319.p6K3JWN5001223@www262.sakura.ne.jp> <alpine.DEB.2.00.1107201616120.3528@tiger> <alpine.DEB.2.00.1107200857350.32737@router.home> <alpine.DEB.2.00.1107202036130.2847@tiger>
In-Reply-To: <alpine.DEB.2.00.1107202036130.2847@tiger>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE, bases: 20072011 #5646396, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg wrote:
> On Wed, 20 Jul 2011, Christoph Lameter wrote:
> > Looks okay but I thought you already had a patch that took out the #if
> > there?
> 
> Indeed. Tetsuo, it's commit c225150 ("slab: fix DEBUG_SLAB build") in 
> slab.git. It should appear in linux-next soon.

Ah, that commit is in linux-next-20110720, but I think it wants below one.
----------------------------------------
[PATCH] slab: fix DEBUG_SLAB warning.

In commit c225150b "slab: fix DEBUG_SLAB build",
"if ((unsigned long)objp & (ARCH_SLAB_MINALIGN-1))" is always true if
ARCH_SLAB_MINALIGN == 0. Do not print warning if ARCH_SLAB_MINALIGN == 0.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 mm/slab.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- linux-next.orig/mm/slab.c
+++ linux-next/mm/slab.c
@@ -3153,7 +3153,8 @@ static void *cache_alloc_debugcheck_afte
 	objp += obj_offset(cachep);
 	if (cachep->ctor && cachep->flags & SLAB_POISON)
 		cachep->ctor(objp);
-	if ((unsigned long)objp & (ARCH_SLAB_MINALIGN-1)) {
+	if (ARCH_SLAB_MINALIGN &&
+	    ((unsigned long)objp & (ARCH_SLAB_MINALIGN-1))) {
 		printk(KERN_ERR "0x%p: not aligned to ARCH_SLAB_MINALIGN=%d\n",
 		       objp, (int)ARCH_SLAB_MINALIGN);
 	}
