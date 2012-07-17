Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756888Ab2GQVkF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 17:40:05 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:39563 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755382Ab2GQVkD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 17:40:03 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 17/17] random: final removal of IRQF_SAMPLE_RANDOM
Date: Tue, 17 Jul 2012 17:32:36 -0400
Message-Id: <1342560756-18737-18-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.7.11.1.108.gb129051
In-Reply-To: <1342560756-18737-1-git-send-email-tytso@mit.edu>
References: <1342560756-18737-1-git-send-email-tytso@mit.edu>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The IRQF_SAMPLE_RANDOM flag is finally gone from the kernel tree, only
three years late.  :-)

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 Documentation/feature-removal-schedule.txt | 14 --------------
 include/linux/interrupt.h                  |  2 --
 2 files changed, 16 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 56000b3..27f39cf 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -70,20 +70,6 @@ Who:	Luis R. Rodriguez <lrodriguez@atheros.com>
 
 ---------------------------
 
-What:	IRQF_SAMPLE_RANDOM
-Check:	IRQF_SAMPLE_RANDOM
-When:	July 2009
-
-Why:	Many of IRQF_SAMPLE_RANDOM users are technically bogus as entropy
-	sources in the kernel's current entropy model. To resolve this, every
-	input point to the kernel's entropy pool needs to better document the
-	type of entropy source it actually is. This will be replaced with
-	additional add_*_randomness functions in drivers/char/random.c
-
-Who:	Robin Getz <rgetz@blackfin.uclinux.org> & Matt Mackall <mpm@selenic.com>
-
----------------------------
-
 What:	The ieee80211_regdom module parameter
 When:	March 2010 / desktop catchup
 
diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index e68a8e5..c5f856a 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -42,7 +42,6 @@
  *
  * IRQF_DISABLED - keep irqs disabled when calling the action handler.
  *                 DEPRECATED. This flag is a NOOP and scheduled to be removed
- * IRQF_SAMPLE_RANDOM - irq is used to feed the random generator
  * IRQF_SHARED - allow sharing the irq among several devices
  * IRQF_PROBE_SHARED - set by callers when they expect sharing mismatches to occur
  * IRQF_TIMER - Flag to mark this interrupt as timer interrupt
@@ -61,7 +60,6 @@
  *                resume time.
  */
 #define IRQF_DISABLED		0x00000020
-#define IRQF_SAMPLE_RANDOM	0x00000040
 #define IRQF_SHARED		0x00000080
 #define IRQF_PROBE_SHARED	0x00000100
 #define __IRQF_TIMER		0x00000200
-- 
1.7.11.1.108.gb129051

