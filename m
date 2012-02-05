Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754914Ab2BEWdu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 17:33:50 -0500
Received: from 1wt.eu ([62.212.114.60]:62124 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754386Ab2BEW1D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 17:27:03 -0500
Message-Id: <20120205220953.088725541@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Sun, 05 Feb 2012 23:11:14 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jim Bos <jim876@xs4all.nl>, Andi Kleen <andi@firstfloor.org>,
        Andreas Schwab <schwab@linux-m68k.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH 85/91] i8k: Tell gcc that *regs gets clobbered
In-Reply-To: <0635750f5f06ed2ca212b91fcb5c4483@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-longterm review patch.  If anyone has any objections, please let us know.

------------------

commit 6b4e81db2552bad04100e7d5ddeed7e848f53b48 upstream.

More recent GCC caused the i8k driver to stop working, on Slackware
compiler was upgraded from gcc-4.4.4 to gcc-4.5.1 after which it didn't
work anymore, meaning the driver didn't load or gave total nonsensical
output.

As it turned out the asm(..) statement forgot to mention it modifies the
*regs variable.

Credits to Andi Kleen and Andreas Schwab for providing the fix.

Signed-off-by: Jim Bos <jim876@xs4all.nl>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Andreas Schwab <schwab@linux-m68k.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/i8k.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

Index: longterm-2.6.27/drivers/char/i8k.c
===================================================================
--- longterm-2.6.27.orig/drivers/char/i8k.c	2012-02-05 22:34:32.409914870 +0100
+++ longterm-2.6.27/drivers/char/i8k.c	2012-02-05 22:34:47.002916726 +0100
@@ -141,7 +141,7 @@
 		"lahf\n\t"
 		"shrl $8,%%eax\n\t"
 		"andl $1,%%eax\n"
-		:"=a"(rc)
+		:"=a"(rc), "+m" (*regs)
 		:    "a"(regs)
 		:    "%ebx", "%ecx", "%edx", "%esi", "%edi", "memory");
 #else
@@ -166,7 +166,8 @@
 	    "movl %%edx,0(%%eax)\n\t"
 	    "lahf\n\t"
 	    "shrl $8,%%eax\n\t"
-	    "andl $1,%%eax\n":"=a"(rc)
+	    "andl $1,%%eax\n"
+	    :"=a"(rc), "+m" (*regs)
 	    :    "a"(regs)
 	    :    "%ebx", "%ecx", "%edx", "%esi", "%edi", "memory");
 #endif


