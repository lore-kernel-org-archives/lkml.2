Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415Ab1FEIcr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 04:32:47 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:49092 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754824Ab1FEIcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 04:32:45 -0400
X-Originating-IP: 217.70.178.137
X-Originating-IP: 50.43.15.19
Date: Sun, 5 Jun 2011 01:32:32 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Ingo Molnar <mingo@elte.hu>, Sam Ravnborg <sam@ravnborg.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Unhide DEBUG_BUGVERBOSE when EXPERT=y, even if DEBUG_KERNEL=n
Message-ID: <20110605083230.GA18260@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_DEBUG_BUGVERBOSE defaults to y.  Embedded systems might want to
disable this to save space; however, disabling it requires enabling
CONFIG_DEBUG_KERNEL to see it.  Unhide it for CONFIG_EXPERT=y as well,
so it shows up as an option for embedded users without having to turn on
CONFIG_DEBUG_KERNEL.

Also make the option show up if CONFIG_DEBUG_KERNEL=y and
CONFIG_EXPERT=n, which seems sensible for a debug feature.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---

To me, it seemed highly counterintuitive to have to enable
CONFIG_DEBUG_KERNEL in order to *disable* debugging features; hence this
patch to expose one of the two that defaults to y.

 lib/Kconfig.debug |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index dd373c8..1edc75d 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -694,7 +694,7 @@ config DEBUG_HIGHMEM
 	  Disable for production systems.
 
 config DEBUG_BUGVERBOSE
-	bool "Verbose BUG() reporting (adds 70K)" if DEBUG_KERNEL && EXPERT
+	bool "Verbose BUG() reporting (adds 70K)" if DEBUG_KERNEL || EXPERT
 	depends on BUG
 	depends on ARM || AVR32 || M32R || M68K || SPARC32 || SPARC64 || \
 		   FRV || SUPERH || GENERIC_BUG || BLACKFIN || MN10300 || TILE
-- 
1.7.5.3

