Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757836Ab2EUR0B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 13:26:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42776 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754093Ab2EURZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 13:25:59 -0400
Date: Mon, 21 May 2012 10:25:47 -0700
From: tip-bot for Sasha Levin <levinsasha928@gmail.com>
Message-ID: <tip-29d679ffd850ea37a303bb930142be14982611e4@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, levinsasha928@gmail.com, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, levinsasha928@gmail.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de
In-Reply-To: <1336492573-17530-3-git-send-email-levinsasha928@gmail.com>
References: <1336492573-17530-3-git-send-email-levinsasha928@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, printk:
  Add missing KERN_CONT to NMI selftest
Git-Commit-ID: 29d679ffd850ea37a303bb930142be14982611e4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 21 May 2012 10:25:52 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  29d679ffd850ea37a303bb930142be14982611e4
Gitweb:     http://git.kernel.org/tip/29d679ffd850ea37a303bb930142be14982611e4
Author:     Sasha Levin <levinsasha928@gmail.com>
AuthorDate: Tue, 8 May 2012 17:56:12 +0200
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Mon, 21 May 2012 10:13:04 -0700

x86, printk: Add missing KERN_CONT to NMI selftest

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
Link: http://lkml.kernel.org/r/1336492573-17530-3-git-send-email-levinsasha928@gmail.com
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/nmi_selftest.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/nmi_selftest.c b/arch/x86/kernel/nmi_selftest.c
index 2c39dcd..9f11dd3 100644
--- a/arch/x86/kernel/nmi_selftest.c
+++ b/arch/x86/kernel/nmi_selftest.c
@@ -117,15 +117,15 @@ static void __init dotest(void (*testcase_fn)(void), int expected)
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
 
@@ -150,10 +150,10 @@ void __init nmi_selftest(void)
 
 	print_testname("remote IPI");
 	dotest(remote_ipi, SUCCESS);
-	printk("\n");
+	printk(KERN_CONT "\n");
 	print_testname("local IPI");
 	dotest(local_ipi, SUCCESS);
-	printk("\n");
+	printk(KERN_CONT "\n");
 
 	cleanup_nmi_testsuite();
 
