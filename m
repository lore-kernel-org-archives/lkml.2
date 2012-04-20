Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932148Ab2DTWC1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 18:02:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34111 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756033Ab2DTWCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 18:02:23 -0400
Date: Fri, 20 Apr 2012 15:02:12 -0700
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Message-ID: <tip-015e6f11a9737684469feef9d523373b1746159d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        david.daney@cavium.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        david.daney@cavium.com, tglx@linutronix.de
In-Reply-To: <CA+55aFyijf43qSu3N9nWHEBwaGbb7T2Oq9A=9EyR=Jtyqfq_cQ@mail.gmail.com>
References: <CA+55aFyijf43qSu3N9nWHEBwaGbb7T2Oq9A=9EyR=Jtyqfq_cQ@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/extable] x86, extable:
  Remove open-coded exception table entries in arch/x86/lib/csum-copy_64.S
Git-Commit-ID: 015e6f11a9737684469feef9d523373b1746159d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 20 Apr 2012 15:02:17 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  015e6f11a9737684469feef9d523373b1746159d
Gitweb:     http://git.kernel.org/tip/015e6f11a9737684469feef9d523373b1746159d
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Fri, 20 Apr 2012 12:19:51 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Fri, 20 Apr 2012 13:51:39 -0700

x86, extable: Remove open-coded exception table entries in arch/x86/lib/csum-copy_64.S

Remove open-coded exception table entries in arch/x86/lib/csum-copy_64.S,
and replace them with _ASM_EXTABLE() macros; this will allow us to
change the format and type of the exception table entries.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: David Daney <david.daney@cavium.com>
Link: http://lkml.kernel.org/r/CA%2B55aFyijf43qSu3N9nWHEBwaGbb7T2Oq9A=9EyR=Jtyqfq_cQ@mail.gmail.com
---
 arch/x86/lib/csum-copy_64.S |   16 ++++------------
 1 files changed, 4 insertions(+), 12 deletions(-)

diff --git a/arch/x86/lib/csum-copy_64.S b/arch/x86/lib/csum-copy_64.S
index fb903b7..2419d5f 100644
--- a/arch/x86/lib/csum-copy_64.S
+++ b/arch/x86/lib/csum-copy_64.S
@@ -8,6 +8,7 @@
 #include <linux/linkage.h>
 #include <asm/dwarf2.h>
 #include <asm/errno.h>
+#include <asm/asm.h>
 
 /*
  * Checksum copy with exception handling.
@@ -31,26 +32,17 @@
 
 	.macro source
 10:
-	.section __ex_table, "a"
-	.align 8
-	.quad 10b, .Lbad_source
-	.previous
+	_ASM_EXTABLE(10b, .Lbad_source)
 	.endm
 
 	.macro dest
 20:
-	.section __ex_table, "a"
-	.align 8
-	.quad 20b, .Lbad_dest
-	.previous
+	_ASM_EXTABLE(20b, .Lbad_dest)
 	.endm
 
 	.macro ignore L=.Lignore
 30:
-	.section __ex_table, "a"
-	.align 8
-	.quad 30b, \L
-	.previous
+	_ASM_EXTABLE(30b, \L)
 	.endm
 
 
