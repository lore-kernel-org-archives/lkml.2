Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757100Ab2EHPzg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 11:55:36 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57569 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757049Ab2EHPzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 11:55:32 -0400
From: Sasha Levin <levinsasha928@gmail.com>
To: kay@vrfy.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        isdn@linux-pingi.de, akpm@linux-foundation.org
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Sasha Levin <levinsasha928@gmail.com>
Subject: [PATCH 3/4] x86, NMI: add missing KERN_CONT to NMI selftest
Date: Tue,  8 May 2012 17:56:12 +0200
Message-Id: <1336492573-17530-3-git-send-email-levinsasha928@gmail.com>
X-Mailer: git-send-email 1.7.8.5
In-Reply-To: <1336492573-17530-1-git-send-email-levinsasha928@gmail.com>
References: <1336492573-17530-1-git-send-email-levinsasha928@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix this behaviour:

----------------
| NMI testsuite:
--------------------
  remote IPI:
  ok  |

   local IPI:
  ok  |

Revealed due to a new modification to printk().

Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
---
 arch/x86/kernel/nmi_selftest.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/nmi_selftest.c b/arch/x86/kernel/nmi_selftest.c
index ff36986..e31bf8d 100644
--- a/arch/x86/kernel/nmi_selftest.c
+++ b/arch/x86/kernel/nmi_selftest.c
@@ -118,15 +118,15 @@ static void __init dotest(void (*testcase_fn)(void), int expected)
 		unexpected_testcase_failures++;
 
 		if (nmi_fail == FAILURE)
-			printk("FAILED |");
+			printk(KERN_CONT "FAILED |");
 		else if (nmi_fail == TIMEOUT)
-			printk("TIMEOUT|");
+			printk(KERN_CONT "TIMEOUT|");
 		else
-			printk("ERROR  |");
+			printk(KERN_CONT "ERROR  |");
 		dump_stack();
 	} else {
 		testcase_successes++;
-		printk("  ok  |");
+		printk(KERN_CONT "  ok  |");
 	}
 	testcase_total++;
 
@@ -151,10 +151,10 @@ void __init nmi_selftest(void)
 
 	print_testname("remote IPI");
 	dotest(remote_ipi, SUCCESS);
-	printk("\n");
+	printk(KERN_CONT "\n");
 	print_testname("local IPI");
 	dotest(local_ipi, SUCCESS);
-	printk("\n");
+	printk(KERN_CONT "\n");
 
 	cleanup_nmi_testsuite();
 
-- 
1.7.8.5

