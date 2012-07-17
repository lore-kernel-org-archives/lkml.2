Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757237Ab2GQWFR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 18:05:17 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:39585 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757164Ab2GQWE5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 18:04:57 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Tony Lindgren <tony@atomide.com>
Subject: [PATCH 13/17] board-palmz71: remove IRQF_SAMPLE_RANDOM which is now a no-op
Date: Tue, 17 Jul 2012 17:32:32 -0400
Message-Id: <1342560756-18737-14-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.7.11.1.108.gb129051
In-Reply-To: <1342560756-18737-1-git-send-email-tytso@mit.edu>
References: <1342560756-18737-1-git-send-email-tytso@mit.edu>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the changes in the random tree, IRQF_SAMPLE_RANDOM is now a
no-op; interrupt randomness is now collected unconditionally in a very
low-overhead fashion; see commit 775f4b297b.  The IRQF_SAMPLE_RANDOM
flag was scheduled to be removed in 2009 on the
feature-removal-schedule, so this patch is preparation for the final
removal of this flag.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap1/board-palmz71.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm/mach-omap1/board-palmz71.c b/arch/arm/mach-omap1/board-palmz71.c
index 3c71c6b..efcd365 100644
--- a/arch/arm/mach-omap1/board-palmz71.c
+++ b/arch/arm/mach-omap1/board-palmz71.c
@@ -288,8 +288,7 @@ palmz71_gpio_setup(int early)
 		}
 		gpio_direction_input(PALMZ71_USBDETECT_GPIO);
 		if (request_irq(gpio_to_irq(PALMZ71_USBDETECT_GPIO),
-				palmz71_powercable, IRQF_SAMPLE_RANDOM,
-				"palmz71-cable", NULL))
+				palmz71_powercable, 0, "palmz71-cable", NULL))
 			printk(KERN_ERR
 					"IRQ request for power cable failed!\n");
 		palmz71_powercable(gpio_to_irq(PALMZ71_USBDETECT_GPIO), NULL);
-- 
1.7.11.1.108.gb129051

