Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756687Ab0FQDTe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 23:19:34 -0400
Received: from LUNGE.MIT.EDU ([18.54.1.69]:39402 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751042Ab0FQDTd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 23:19:33 -0400
Date: Wed, 16 Jun 2010 23:19:28 -0400
From: Andres Salomon <dilinger@queued.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, x86@kernel.org, cjb@laptop.org, pgf@laptop.org,
       richard@laptop.org
Subject: [PATCH] x86: OLPC: use pr_debug() for EC commands
Message-ID: <20100616231928.16b539f0@dev.queued.net>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.12.12; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Unconditionally printing EC debug messages was helpful when we were actually
debugging the EC, but during normal operation it can get pretty annoying.
Using pr_debug allows us finer-grained control.

(Richard, please yell if this shouldn't be done.)

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 arch/x86/kernel/olpc.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/olpc.c b/arch/x86/kernel/olpc.c
index 1566052..f5ff390 100644
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
 
-- 
1.5.6.5


