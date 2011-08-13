Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932Ab1HMGdN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Aug 2011 02:33:13 -0400
Received: from statler.bytemark.co.uk ([212.110.162.18]:51504 "EHLO
	statler.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519Ab1HMGdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Aug 2011 02:33:10 -0400
From: "Emilio G. Cota" <cota@braap.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Matthew Wilcox <willy@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] semaphore: remove superfluous include of ftrace.h
Date: Sat, 13 Aug 2011 02:32:53 -0400
Message-Id: <1313217173-32103-1-git-send-email-cota@braap.org>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Emilio G. Cota" <cota@braap.org>

Inspecting the semaphore code I noticed the #include of ftrace.h,
which wasn't there last time I checked (years ago). It was
added by commit "74f4e36 ftrace: stacktrace fix", which
was partially (and manually) reverted by "3e61e0c mmiotrace
broken in linux-next (8-bit writes only)".

Since 3e61e0c the include of ftrace.h has been superfluous;
remove it.

Signed-off-by: Emilio G. Cota <cota@braap.org>
---
 kernel/semaphore.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/kernel/semaphore.c b/kernel/semaphore.c
index 94a62c0..4b63e1d 100644
--- a/kernel/semaphore.c
+++ b/kernel/semaphore.c
@@ -31,7 +31,6 @@
 #include <linux/sched.h>
 #include <linux/semaphore.h>
 #include <linux/spinlock.h>
-#include <linux/ftrace.h>
 
 static noinline void __down(struct semaphore *sem);
 static noinline int __down_interruptible(struct semaphore *sem);
-- 
1.7.6

