Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000Ab0GaBKF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 21:10:05 -0400
Received: from hera.kernel.org ([140.211.167.34]:41180 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752572Ab0GaBKD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 21:10:03 -0400
Date: Sat, 31 Jul 2010 01:09:43 GMT
From: tip-bot for Andres Salomon <dilinger@queued.net>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        dilinger@queued.net, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        dilinger@queued.net, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <20100616231928.16b539f0@dev.queued.net>
References: <20100616231928.16b539f0@dev.queued.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/olpc] x86, olpc: Use pr_debug() for EC commands
Message-ID: <tip-25971865d48a8d0ece5307a59dbd3f06d05a7567@git.kernel.org>
Git-Commit-ID: 25971865d48a8d0ece5307a59dbd3f06d05a7567
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 31 Jul 2010 01:09:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  25971865d48a8d0ece5307a59dbd3f06d05a7567
Gitweb:     http://git.kernel.org/tip/25971865d48a8d0ece5307a59dbd3f06d05a7567
Author:     Andres Salomon <dilinger@queued.net>
AuthorDate: Wed, 16 Jun 2010 23:19:28 -0400
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 30 Jul 2010 18:01:52 -0700

x86, olpc: Use pr_debug() for EC commands

Unconditionally printing EC debug messages was helpful when we were actually
debugging the EC, but during normal operation it can get pretty annoying.
Using pr_debug allows us finer-grained control.

Signed-off-by: Andres Salomon <dilinger@queued.net>
LKML-Reference: <20100616231928.16b539f0@dev.queued.net>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/olpc.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/olpc.c b/arch/x86/kernel/olpc.c
index 1566052..f5ff3903 100644
--- a/arch/x86/kernel/olpc.c
+++ b/arch/x86/kernel/olpc.c
@@ -142,7 +142,7 @@ restart:
 	 * The OBF flag will sometimes misbehave due to what we believe
 	 * is a hardware quirk..
 	 */
-	printk(KERN_DEBUG "olpc-ec:  running cmd 0x%x\n", cmd);
+	pr_devel("olpc-ec:  running cmd 0x%x\n", cmd);
 	outb(cmd, 0x6c);
 
 	if (wait_on_ibf(0x6c, 0)) {
@@ -159,8 +159,7 @@ restart:
 						" EC accept data!\n");
 				goto err;
 			}
-			printk(KERN_DEBUG "olpc-ec:  sending cmd arg 0x%x\n",
-					inbuf[i]);
+			pr_devel("olpc-ec:  sending cmd arg 0x%x\n", inbuf[i]);
 			outb(inbuf[i], 0x68);
 		}
 	}
@@ -173,8 +172,7 @@ restart:
 				goto restart;
 			}
 			outbuf[i] = inb(0x68);
-			printk(KERN_DEBUG "olpc-ec:  received 0x%x\n",
-					outbuf[i]);
+			pr_devel("olpc-ec:  received 0x%x\n", outbuf[i]);
 		}
 	}
 
