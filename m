Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751957Ab0JPPY0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 11:24:26 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:55110 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751027Ab0JPPYZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 11:24:25 -0400
/m: 
From: Richard Weinberger <richard@nod.at>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, jdike@addtoit.com,
        user-mode-linux-devel@lists.sourceforge.net, arjan@linux.intel.com,
        penberg@cs.helsinki.fi, peterz@infradead.org,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 1/1] um: fix global timer issue when using CONFIG_NO_HZ
Date: Sat, 16 Oct 2010 17:23:58 +0200
Message-Id: <1287242638-20968-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes a issue which was introduced by fe2cc53e.
timeval_to_ns() returns long long and not int.
Due to that UML's timer did not work proper and caused timer freezes.

LKML-Reference: <AANLkTik5_TCXeGzTWBZzE8F0Cb2bQq-D228xDXk87rhP () mail ! gmail ! com>
Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/um/os-Linux/time.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/um/os-Linux/time.c b/arch/um/os-Linux/time.c
index dec5678..6e3359d 100644
--- a/arch/um/os-Linux/time.c
+++ b/arch/um/os-Linux/time.c
@@ -60,7 +60,7 @@ static inline long long timeval_to_ns(const struct timeval *tv)
 long long disable_timer(void)
 {
 	struct itimerval time = ((struct itimerval) { { 0, 0 }, { 0, 0 } });
-	int remain, max = UM_NSEC_PER_SEC / UM_HZ;
+	long long remain, max = UM_NSEC_PER_SEC / UM_HZ;
 
 	if (setitimer(ITIMER_VIRTUAL, &time, &time) < 0)
 		printk(UM_KERN_ERR "disable_timer - setitimer failed, "
-- 
1.6.6.1

