Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753970Ab1KLWSp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Nov 2011 17:18:45 -0500
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:54874 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925Ab1KLWSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Nov 2011 17:18:44 -0500
Subject: [PATCH] score: Kconfig: drop nine selects and one entry
From: Paul Bolle <pebolle@tiscali.nl>
To: Chen Liqin <liqin.chen@sunplusct.com>, Lennox Wu <lennox.wu@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 12 Nov 2011 23:18:17 +0100
Message-ID: <1321136297.20271.15.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The config entries in the "System type" choice each use the same three
select statements. The Kconfig symbol SYS_SUPPORTS_32BIT_KERNEL is only
used by mips. The Kconfig symbol CPU_SCORE7 is used once, in an (almost)
empty Kconfig entry, and there are no uses of CONFIG_CPU_SCORE7. (This
means that the CPU_SCORE7 entry can also be dropped.) And
GENERIC_HAS_IOMAP is a typo. It should have been GENERIC_IOMAP. But
there's an entry for GENERIC_IOMAP that defaults to y, so no one
noticed.

So all selects from the config entries in this choice can be dropped.
And so can the CPU_SCORE7 config entry.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) git grep tested only.

1) Please note that ARCH_SCORE7, MACH_SPCT6600, and SCORE_SIM aren't
used anywhere else. There are also no uses of CONFIG_ARCH_SCORE7,
CONFIG_MACH_SPCT6600, and CONFIG_SCORE_SIM macros. Perhaps the entire
"System type" choice can be dropped.

 arch/score/Kconfig |   13 +------------
 1 files changed, 1 insertions(+), 12 deletions(-)

diff --git a/arch/score/Kconfig b/arch/score/Kconfig
index df169e8..4390afc 100644
--- a/arch/score/Kconfig
+++ b/arch/score/Kconfig
@@ -11,28 +11,17 @@ choice
 
 config ARCH_SCORE7
 	bool "SCORE7 processor"
-	select SYS_SUPPORTS_32BIT_KERNEL
-	select CPU_SCORE7
-	select GENERIC_HAS_IOMAP
 
 config MACH_SPCT6600
 	bool "SPCT6600 series based machines"
-	select SYS_SUPPORTS_32BIT_KERNEL
-	select CPU_SCORE7
-	select GENERIC_HAS_IOMAP
 
 config SCORE_SIM
 	bool "Score simulator"
-	select SYS_SUPPORTS_32BIT_KERNEL
-	select CPU_SCORE7
-	select GENERIC_HAS_IOMAP
+
 endchoice
 
 endmenu
 
-config CPU_SCORE7
-	bool
-
 config GENERIC_IOMAP
 	def_bool y
 
-- 
1.7.4.4



