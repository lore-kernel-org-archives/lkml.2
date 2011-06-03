Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945Ab1FCPUk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 11:20:40 -0400
Received: from mx4-phx2.redhat.com ([209.132.183.25]:59341 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751391Ab1FCPUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 11:20:39 -0400
Date: Fri, 3 Jun 2011 11:20:23 -0400 (EDT)
From: Dave Anderson <anderson@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, andi@firstfloor.org, jstancek@redhat.com,
        anderson@redhat.com
Message-ID: <2060873692.1232.1307114423575.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
In-Reply-To: <313387488.1201.1307114323524.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
Subject: [PATCH] x86-64: Prevent gcc from optimizing away venosys_1()
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.5.72]
X-Mailer: Zimbra 6.0.9_GA_2686 (ZimbraWebClient - FF3.0 (Linux)/6.0.9_GA_2686)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One of the changes in commit a4928cffe6435caf427ae673131a633c1329dbf3 
made the venosys_1() system call static, which causes it to be 
optimized out of the kernel:

  Author: Ingo Molnar <mingo@elte.hu>
  Date:   Wed Apr 23 13:20:56 2008 +0200

  "make namespacecheck" fixes

  Signed-off-by: Ingo Molnar <mingo@elte.hu>

Commit 2e8ad43ec07545780ce7992cb18e2d82c7abd24c had originally
changed all vsyscalls from being static for the same reason:

  Author: Andi Kleen <ak@suse.de>
  Date:   Mon Sep 12 18:49:24 2005 +0200

  [PATCH] x86-64: Prevent gcc 4 from optimizing away vsyscalls
    
  They were previously static.
    
  Signed-off-by: Andi Kleen <ak@suse.de>
  Signed-off-by: Linus Torvalds <torvalds@osdl.org>

Reported-by: Jan Stancek <jstancek@redhat.com>
Signed-off-by: Dave Anderson <anderson@redhat.com>

---

diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index 3e68218..60a34af 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -222,7 +222,7 @@ vgetcpu(unsigned *cpu, unsigned *node, struct getcpu_cache *tcache)
 	return 0;
 }
 
-static long __vsyscall(3) venosys_1(void)
+long __vsyscall(3) venosys_1(void)
 {
 	return -ENOSYS;
 }
