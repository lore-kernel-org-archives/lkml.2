Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798Ab0LUXjp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 18:39:45 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:55159 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799Ab0LUXjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 18:39:44 -0500
Date: Tue, 21 Dec 2010 16:39:43 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] Prevent users from disabling tickless
Message-ID: <20101221233942.GL1263@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Disabling NO_HZ has a serious negative effect on performance -- an extra
70us per I/O.  Prevent users from deselecting it.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>

diff --git a/kernel/time/Kconfig b/kernel/time/Kconfig
index f06a8a3..55b9a04 100644
--- a/kernel/time/Kconfig
+++ b/kernel/time/Kconfig
@@ -5,13 +5,9 @@ config TICK_ONESHOT
 	bool
 
 config NO_HZ
-	bool "Tickless System (Dynamic Ticks)"
+	def_bool y
 	depends on !ARCH_USES_GETTIMEOFFSET && GENERIC_CLOCKEVENTS
 	select TICK_ONESHOT
-	help
-	  This option enables a tickless system: timer interrupts will
-	  only trigger on an as-needed basis both when the system is
-	  busy and when the system is idle.
 
 config HIGH_RES_TIMERS
 	bool "High Resolution Timer Support"

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
