Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993Ab0FZTOE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jun 2010 15:14:04 -0400
Received: from ozlabs.org ([203.10.76.45]:49282 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753575Ab0FZTOA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jun 2010 15:14:00 -0400
Date: Sun, 27 Jun 2010 05:13:09 +1000
From: Anton Blanchard <anton@samba.org>
To: akpm@linux-foundation.org, mingo@elte.hu, arjan@linux.intel.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] Add oops end marker to lib/bug.c WARN implementation
Message-ID: <20100626191309.GB2345@kryten>
References: <20100626191059.GA2345@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100626191059.GA2345@kryten>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


We are missing the oops end marker for the exception based WARN implementation
in lib/bug.c. This is useful for logfile analysis tools.

Signed-off-by: Anton Blanchard <anton@samba.org>
---

Index: linux-2.6/include/linux/kernel.h
===================================================================
--- linux-2.6.orig/include/linux/kernel.h	2010-06-26 06:29:35.000000000 +1000
+++ linux-2.6/include/linux/kernel.h	2010-06-26 06:30:27.000000000 +1000
@@ -177,6 +177,7 @@ NORET_TYPE void panic(const char * fmt, 
 	__attribute__ ((NORET_AND format (printf, 1, 2))) __cold;
 extern void oops_enter(void);
 extern void oops_exit(void);
+void print_oops_end_marker(void);
 extern int oops_may_print(void);
 NORET_TYPE void do_exit(long error_code)
 	ATTRIB_NORET;
Index: linux-2.6/kernel/panic.c
===================================================================
--- linux-2.6.orig/kernel/panic.c	2010-06-26 06:29:35.000000000 +1000
+++ linux-2.6/kernel/panic.c	2010-06-26 06:30:05.000000000 +1000
@@ -344,7 +344,7 @@ static int init_oops_id(void)
 }
 late_initcall(init_oops_id);
 
-static void print_oops_end_marker(void)
+void print_oops_end_marker(void)
 {
 	init_oops_id();
 	printk(KERN_WARNING "---[ end trace %016llx ]---\n",
Index: linux-2.6/lib/bug.c
===================================================================
--- linux-2.6.orig/lib/bug.c	2010-06-26 06:29:35.000000000 +1000
+++ linux-2.6/lib/bug.c	2010-06-26 06:31:28.000000000 +1000
@@ -166,6 +166,7 @@ enum bug_trap_type report_bug(unsigned l
 
         	print_modules();
 		show_regs(regs);
+		print_oops_end_marker();
 		add_taint(BUG_GET_TAINT(bug));
 		return BUG_TRAP_TYPE_WARN;
 	}
