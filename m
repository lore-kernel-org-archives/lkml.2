Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760254Ab2C2WtT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 18:49:19 -0400
Received: from mail1.windriver.com ([147.11.146.13]:56158 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760183Ab2C2WtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 18:49:13 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: <kgdb-bugreport@lists.sourceforge.net>
Subject: [PATCH 0/6] KGDB/KDB/KGDBTS various regression fixes for 2.6.x -> 3.4
Date: Thu, 29 Mar 2012 17:48:56 -0500
Message-ID: <1333061342-10132-1-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.7.9.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a set of accumulated regression fixes which will go to to
-stable once reviewed and merged to the mainline.

The break down looks likes this for >= kernel x.x

   3.4: Fix an an Smatch warning that appeared in the 3.4 merge window
   3.0: Fix kgdb suite with SMP for all archs without HW single stepping
2.6.36: Fix kgdb sw breakpoints with CONFIG_DEBUG_RODATA=y limitations on x86
2.6.26: Fix oops on kgdb test suite with CONFIG_DEBUG_RODATA
        Fix kgdb suite with SMP for all archs with HW single stepping

It is worth mentioning that fixing the kgdb test suite SMP problems
has shown there are some stability problems with SMP ARM kernels and
IPIs.  These problems have been there for as long as ARM has had SMP
support but there was no easy way to trigger the issue that causes a
hard lockup.  At some point I'll take a further look at this, but
anyone is free to run the tests now that they work. :-)

Cheers,
Jason.

---
Jason Wessel (6):
      kdb: Fix smatch warning on dbg_io_ops->is_console
      kgdbts: Fix kernel oops with CONFIG_DEBUG_RODATA
      kgdbts: (1 of 2) fix single step awareness to work correctly with SMP
      kgdbts: (2 of 2) fix single step awareness to work correctly with SMP
      kgdb,debug_core: pass the breakpoint struct instead of address and memory
      x86,kgdb: Fix DEBUG_RODATA limitation using text_poke()

 arch/x86/kernel/kgdb.c    |   60 +++++++++++++++
 drivers/misc/kgdbts.c     |  177 +++++++++++++++++++++++++++++++++------------
 include/linux/kgdb.h      |    7 +-
 kernel/debug/debug_core.c |   53 ++++++--------
 kernel/debug/kdb/kdb_io.c |    2 +-
 5 files changed, 221 insertions(+), 78 deletions(-)
