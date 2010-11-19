Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758309Ab0KSWF1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 17:05:27 -0500
Received: from kroah.org ([198.145.64.141]:53135 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758251Ab0KSWEi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 17:04:38 -0500
X-Mailbox-Line: From gregkh@clark.site Fri Nov 19 14:01:27 2010
Message-Id: <20101119220127.449781867@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 19 Nov 2010 14:01:35 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Rabin Vincent <rabin@rab.in>,
        Jason Wessel <jason.wessel@windriver.com>
Subject: [64/66] kgdb,arm: fix register dump
In-Reply-To: <20101119220309.GA15562@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Rabin Vincent <rabin@rab.in>

commit 834b2964b7ab047610da038e42d61dc8dac6339a upstream.

DBG_MAX_REG_NUM incorrectly had the number of indices in the GDB regs
array rather than the number of registers, leading to an oops when the
"rd" command is used in KDB.

Signed-off-by: Rabin Vincent <rabin@rab.in>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/arm/include/asm/kgdb.h |    5 +++--
 arch/arm/kernel/kgdb.c      |    2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)

--- a/arch/arm/include/asm/kgdb.h
+++ b/arch/arm/include/asm/kgdb.h
@@ -70,7 +70,8 @@ extern int kgdb_fault_expected;
 #define _GP_REGS		16
 #define _FP_REGS		8
 #define _EXTRA_REGS		2
-#define DBG_MAX_REG_NUM		(_GP_REGS + (_FP_REGS * 3) + _EXTRA_REGS)
+#define GDB_MAX_REGS		(_GP_REGS + (_FP_REGS * 3) + _EXTRA_REGS)
+#define DBG_MAX_REG_NUM		(_GP_REGS + _FP_REGS + _EXTRA_REGS)
 
 #define KGDB_MAX_NO_CPUS	1
 #define BUFMAX			400
@@ -93,7 +94,7 @@ extern int kgdb_fault_expected;
 #define _SPT			13
 #define _LR			14
 #define _PC			15
-#define _CPSR			(DBG_MAX_REG_NUM - 1)
+#define _CPSR			(GDB_MAX_REGS - 1)
 
 /*
  * So that we can denote the end of a frame for tracing,
--- a/arch/arm/kernel/kgdb.c
+++ b/arch/arm/kernel/kgdb.c
@@ -79,7 +79,7 @@ sleeping_thread_to_gdb_regs(unsigned lon
 		return;
 
 	/* Initialize to zero */
-	for (regno = 0; regno < DBG_MAX_REG_NUM; regno++)
+	for (regno = 0; regno < GDB_MAX_REGS; regno++)
 		gdb_regs[regno] = 0;
 
 	/* Otherwise, we have only some registers from switch_to() */


