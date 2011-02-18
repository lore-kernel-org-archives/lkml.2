Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752491Ab1BRFUW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 00:20:22 -0500
Received: from hera.kernel.org ([140.211.167.34]:55497 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751858Ab1BRFUO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 00:20:14 -0500
Date: Fri, 18 Feb 2011 05:19:52 GMT
From: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        castet.matthieu@free.fr, tglx@linutronix.de, sfr@canb.auug.org.au,
        hpa@linux.intel.com, rjw@sisk.pl
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        castet.matthieu@free.fr, tglx@linutronix.de, sfr@canb.auug.org.au,
        hpa@linux.intel.com, rjw@sisk.pl
In-Reply-To: <4D5DFBE4.7090104@intel.com>
References: <4D5DFBE4.7090104@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/trampoline] x86: Make the GDT_ENTRY() macro in <asm/segment.h> safe for assembly
Message-ID: <tip-014eea518af3d141e276664cf40ef3da899eba35@git.kernel.org>
Git-Commit-ID: 014eea518af3d141e276664cf40ef3da899eba35
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 18 Feb 2011 05:19:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  014eea518af3d141e276664cf40ef3da899eba35
Gitweb:     http://git.kernel.org/tip/014eea518af3d141e276664cf40ef3da899eba35
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Mon, 14 Feb 2011 18:33:55 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 17 Feb 2011 21:05:13 -0800

x86: Make the GDT_ENTRY() macro in <asm/segment.h> safe for assembly

Make the GDT_ENTRY() macro in  <asm/segment.h> safe for use in
assembly code by guarding the ULL suffixes with _AC() macros.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
LKML-Reference: <4D5DFBE4.7090104@intel.com>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Matthieu Castet <castet.matthieu@free.fr>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/x86/include/asm/segment.h |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/segment.h b/arch/x86/include/asm/segment.h
index 231f1c1..cd84f72 100644
--- a/arch/x86/include/asm/segment.h
+++ b/arch/x86/include/asm/segment.h
@@ -1,14 +1,16 @@
 #ifndef _ASM_X86_SEGMENT_H
 #define _ASM_X86_SEGMENT_H
 
+#include <linux/const.h>
+
 /* Constructor for a conventional segment GDT (or LDT) entry */
 /* This is a macro so it can be used in initializers */
 #define GDT_ENTRY(flags, base, limit)			\
-	((((base)  & 0xff000000ULL) << (56-24)) |	\
-	 (((flags) & 0x0000f0ffULL) << 40) |		\
-	 (((limit) & 0x000f0000ULL) << (48-16)) |	\
-	 (((base)  & 0x00ffffffULL) << 16) |		\
-	 (((limit) & 0x0000ffffULL)))
+	((((base)  & _AC(0xff000000,ULL)) << (56-24)) |	\
+	 (((flags) & _AC(0x0000f0ff,ULL)) << 40) |	\
+	 (((limit) & _AC(0x000f0000,ULL)) << (48-16)) |	\
+	 (((base)  & _AC(0x00ffffff,ULL)) << 16) |	\
+	 (((limit) & _AC(0x0000ffff,ULL))))
 
 /* Simple and small GDT entries for booting only */
 
