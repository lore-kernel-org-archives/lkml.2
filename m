Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873Ab2DTWGh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 18:06:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34179 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753631Ab2DTWGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 18:06:35 -0400
Date: Fri, 20 Apr 2012 15:06:21 -0700
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Message-ID: <tip-8f6380b9ec1cc4bed9b38144f739b87dd2cddb1d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, jeremy@goop.org, hpa@zytor.com,
        mingo@kernel.org, konrad.wilk@oracle.com, david.daney@cavium.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, jeremy@goop.org,
        linux-kernel@vger.kernel.org, konrad.wilk@oracle.com,
        david.daney@cavium.com, tglx@linutronix.de
In-Reply-To: <CA+55aFyijf43qSu3N9nWHEBwaGbb7T2Oq9A=9EyR=Jtyqfq_cQ@mail.gmail.com>
References: <CA+55aFyijf43qSu3N9nWHEBwaGbb7T2Oq9A=9EyR=Jtyqfq_cQ@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/extable] x86, extable:
  Remove open-coded exception table entries in arch/x86/xen/xen-asm_32.S
Git-Commit-ID: 8f6380b9ec1cc4bed9b38144f739b87dd2cddb1d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 20 Apr 2012 15:06:27 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8f6380b9ec1cc4bed9b38144f739b87dd2cddb1d
Gitweb:     http://git.kernel.org/tip/8f6380b9ec1cc4bed9b38144f739b87dd2cddb1d
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Fri, 20 Apr 2012 12:19:52 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Fri, 20 Apr 2012 13:51:39 -0700

x86, extable: Remove open-coded exception table entries in arch/x86/xen/xen-asm_32.S

Remove open-coded exception table entries in arch/x86/xen/xen-asm_32.S,
and replace them with _ASM_EXTABLE() macros; this will allow us to
change the format and type of the exception table entries.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: David Daney <david.daney@cavium.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Link: http://lkml.kernel.org/r/CA%2B55aFyijf43qSu3N9nWHEBwaGbb7T2Oq9A=9EyR=Jtyqfq_cQ@mail.gmail.com
---
 arch/x86/xen/xen-asm_32.S |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/xen/xen-asm_32.S b/arch/x86/xen/xen-asm_32.S
index b040b0e..f9643fc 100644
--- a/arch/x86/xen/xen-asm_32.S
+++ b/arch/x86/xen/xen-asm_32.S
@@ -14,6 +14,7 @@
 #include <asm/thread_info.h>
 #include <asm/processor-flags.h>
 #include <asm/segment.h>
+#include <asm/asm.h>
 
 #include <xen/interface/xen.h>
 
@@ -137,10 +138,7 @@ iret_restore_end:
 
 1:	iret
 xen_iret_end_crit:
-.section __ex_table, "a"
-	.align 4
-	.long 1b, iret_exc
-.previous
+	_ASM_EXTABLE(1b, iret_exc)
 
 hyper_iret:
 	/* put this out of line since its very rarely used */
