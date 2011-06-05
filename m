Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555Ab1FEIhv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 04:37:51 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:57620 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754771Ab1FEIhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 04:37:50 -0400
X-Originating-IP: 217.70.178.136
X-Originating-IP: 50.43.15.19
Date: Sun, 5 Jun 2011 01:37:41 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Sam Ravnborg <sam@ravnborg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Unhide DEBUG_RODATA if EXPERT, even if DEBUG_KERNEL=n
Message-ID: <20110605083739.GA18560@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_DEBUG_RODATA defaults to y.  Embedded systems might want to
disable this to save space; however, disabling it requires enabling
CONFIG_DEBUG_KERNEL to see it.  Unhide it for CONFIG_EXPERT=y as well,
so it shows up as an option for embedded users without having to turn on
CONFIG_DEBUG_KERNEL.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---

On a related note, I noticed while making this patch that
DEBUG_RODATA_TEST defaults to y, as of commit
72370f2a5b227bd3817593a6b15ea3f53f51dfcb; however, the description says
"If in doubt, say N".  Should the default change, or should the
description?  DEBUG_RODATA_TEST seems like the kind of thing that should
default to n.

 arch/x86/Kconfig.debug |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index c0f8a5c..8653d8b 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -81,7 +81,7 @@ config X86_PTDUMP
 config DEBUG_RODATA
 	bool "Write protect kernel read-only data structures"
 	default y
-	depends on DEBUG_KERNEL
+	depends on DEBUG_KERNEL || EXPERT
 	---help---
 	  Mark the kernel read-only data as write-protected in the pagetables,
 	  in order to catch accidental (and incorrect) writes to such const
-- 
1.7.5.3

