Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676Ab0LMASz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 19:18:55 -0500
Received: from one.firstfloor.org ([213.235.205.2]:35864 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753204Ab0LLXqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:46:06 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: richard@nod.at, penberg@kernel.org, jdike@addtoit.com,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        gregkh@suse.de, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        stable@kernel.org
Subject: [PATCH] [67/223] um: fix global timer issue when using CONFIG_NO_HZ
Message-Id: <20101212234605.86708B27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:46:05 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Richard Weinberger <richard@nod.at>

commit 482db6df1746c4fa7d64a2441d4cb2610249c679 upstream.

This fixes a issue which was introduced by fe2cc53e ("uml: track and make
up lost ticks").

timeval_to_ns() returns long long and not int.  Due to that UML's timer
did not work properlt and caused timer freezes.

Signed-off-by: Richard Weinberger <richard@nod.at>
Acked-by: Pekka Enberg <penberg@kernel.org>
Cc: Jeff Dike <jdike@addtoit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/um/os-Linux/time.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/arch/um/os-Linux/time.c
===================================================================
--- linux.orig/arch/um/os-Linux/time.c
+++ linux/arch/um/os-Linux/time.c
@@ -60,7 +60,7 @@ static inline long long timeval_to_ns(co
 long long disable_timer(void)
 {
 	struct itimerval time = ((struct itimerval) { { 0, 0 }, { 0, 0 } });
-	int remain, max = UM_NSEC_PER_SEC / UM_HZ;
+	long long remain, max = UM_NSEC_PER_SEC / UM_HZ;
 
 	if (setitimer(ITIMER_VIRTUAL, &time, &time) < 0)
 		printk(UM_KERN_ERR "disable_timer - setitimer failed, "
