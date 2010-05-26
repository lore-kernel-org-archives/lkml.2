Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755180Ab0EZNoU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 09:44:20 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:65184 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755037Ab0EZNoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 09:44:18 -0400
Date: Wed, 26 May 2010 15:44:15 +0200
From: Christoph Egger <siccegge@cs.fau.de>
To: Thomas Gleixner <tglx@linutronix.de>, Ralf Baechle <ralf@linux-mips.org>,
       Linus Walleij <linus.walleij@stericsson.com>,
       Jon Hunter <jon-hunter@ti.com>, linux-kernel@vger.kernel.org
Cc: vamos@i4.informatik.uni-erlangen.de
Subject: [PATCH] transitional config CONFIG_GENERIC_CLOCKEVENTS
Message-ID: <20100526134415.GD7508@faui49.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all!

	As part of the VAMOS[0] research project at the University of
Erlangen we are looking at multiple integrity errors in linux'
configuration system.

	This was an aid for a transition finished 2007 so not
necessary for some time now, ready for removal.

	Please keep me informed of this patch getting confirmed /
merged so we can keep track of it.

Regards

	Christoph Egger

[0] http://vamos1.informatik.uni-erlangen.de/

----
>From c8092c26246db170d509dd3424e65e87e67c5a8a Mon Sep 17 00:00:00 2001
From: Christoph Egger <siccegge@cs.fau.de>
Date: Fri, 21 May 2010 17:24:01 +0200
Subject: [PATCH 1/2] Remove transitional, dead GENERIC_CLOCKEVENTS_MIGR

GENERIC_CLOCKEVENTS_MIGR was introduced to facilate transition to the
new codebase which was finished 2007 with
b8ce33590687888ebb900d09557b8807c4539022. However the config Item and
a tiny bit of code wasn't removed back then which is adressed by this
patch.

One might consider getting rid of GENERIC_CLOCKEVENTS_BUILD
alltogether however this patch is limited to changes to affecting the
actual build process in any way.

Signed-off-by: Christoph Egger <siccegge@cs.fau.de>
---
 include/linux/clockchips.h |    4 ----
 kernel/time/Kconfig        |    2 +-
 2 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/include/linux/clockchips.h b/include/linux/clockchips.h
index fc53492..3ad8331 100644
--- a/include/linux/clockchips.h
+++ b/include/linux/clockchips.h
@@ -139,11 +139,7 @@ clockevents_calc_mult_shift(struct clock_event_device *ce, u32 freq, u32 minsec)
 				      freq, minsec);
 }
 
-#ifdef CONFIG_GENERIC_CLOCKEVENTS
 extern void clockevents_notify(unsigned long reason, void *arg);
-#else
-# define clockevents_notify(reason, arg) do { } while (0)
-#endif
 
 #else /* CONFIG_GENERIC_CLOCKEVENTS_BUILD */
 
diff --git a/kernel/time/Kconfig b/kernel/time/Kconfig
index 95ed429..18ed376 100644
--- a/kernel/time/Kconfig
+++ b/kernel/time/Kconfig
@@ -25,5 +25,5 @@ config HIGH_RES_TIMERS
 config GENERIC_CLOCKEVENTS_BUILD
 	bool
 	default y
-	depends on GENERIC_CLOCKEVENTS || GENERIC_CLOCKEVENTS_MIGR
+	depends on GENERIC_CLOCKEVENTS
 
-- 
1.6.3.3









