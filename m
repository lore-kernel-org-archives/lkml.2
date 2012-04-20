Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932129Ab2DTV76 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 17:59:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34048 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752970Ab2DTV7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 17:59:52 -0400
Date: Fri, 20 Apr 2012 14:59:41 -0700
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Message-ID: <tip-5f2e8a84f07bb43f9c0ce317d7e0c5e541db00e3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        david.daney@cavium.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        david.daney@cavium.com, tglx@linutronix.de
In-Reply-To: <CA+55aFyijf43qSu3N9nWHEBwaGbb7T2Oq9A=9EyR=Jtyqfq_cQ@mail.gmail.com>
References: <CA+55aFyijf43qSu3N9nWHEBwaGbb7T2Oq9A=9EyR=Jtyqfq_cQ@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/extable] x86, extable:
  Remove open-coded exception table entries in arch/x86/lib/checksum_32.S
Git-Commit-ID: 5f2e8a84f07bb43f9c0ce317d7e0c5e541db00e3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 20 Apr 2012 14:59:46 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5f2e8a84f07bb43f9c0ce317d7e0c5e541db00e3
Gitweb:     http://git.kernel.org/tip/5f2e8a84f07bb43f9c0ce317d7e0c5e541db00e3
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Fri, 20 Apr 2012 12:19:50 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Fri, 20 Apr 2012 13:51:38 -0700

x86, extable: Remove open-coded exception table entries in arch/x86/lib/checksum_32.S

Remove open-coded exception table entries in arch/x86/lib/checksum_32.S,
and replace them with _ASM_EXTABLE() macros; this will allow us to
change the format and type of the exception table entries.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: David Daney <david.daney@cavium.com>
Link: http://lkml.kernel.org/r/CA%2B55aFyijf43qSu3N9nWHEBwaGbb7T2Oq9A=9EyR=Jtyqfq_cQ@mail.gmail.com
---
 arch/x86/lib/checksum_32.S |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/x86/lib/checksum_32.S b/arch/x86/lib/checksum_32.S
index 78d16a5..2af5df3 100644
--- a/arch/x86/lib/checksum_32.S
+++ b/arch/x86/lib/checksum_32.S
@@ -28,6 +28,7 @@
 #include <linux/linkage.h>
 #include <asm/dwarf2.h>
 #include <asm/errno.h>
+#include <asm/asm.h>
 				
 /*
  * computes a partial checksum, e.g. for TCP/UDP fragments
@@ -282,15 +283,11 @@ unsigned int csum_partial_copy_generic (const char *src, char *dst,
 
 #define SRC(y...)			\
 	9999: y;			\
-	.section __ex_table, "a";	\
-	.long 9999b, 6001f	;	\
-	.previous
+	_ASM_EXTABLE(9999b, 6001f)
 
 #define DST(y...)			\
 	9999: y;			\
-	.section __ex_table, "a";	\
-	.long 9999b, 6002f	;	\
-	.previous
+	_ASM_EXTABLE(9999b, 6002f)
 
 #ifndef CONFIG_X86_USE_PPRO_CHECKSUM
 
