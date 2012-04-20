Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932247Ab2DTAZr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 20:25:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53047 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755871Ab2DTAZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 20:25:45 -0400
Date: Thu, 19 Apr 2012 17:25:35 -0700
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Message-ID: <tip-84f4fc524eed040660bd4ebc8cba259d8afe8461@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de
In-Reply-To: <1334794610-5546-3-git-send-email-hpa@zytor.com>
References: <1334794610-5546-3-git-send-email-hpa@zytor.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/extable] x86:
  Add symbolic constant for exceptions with error code
Git-Commit-ID: 84f4fc524eed040660bd4ebc8cba259d8afe8461
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 19 Apr 2012 17:25:41 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  84f4fc524eed040660bd4ebc8cba259d8afe8461
Gitweb:     http://git.kernel.org/tip/84f4fc524eed040660bd4ebc8cba259d8afe8461
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Wed, 18 Apr 2012 17:16:47 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 19 Apr 2012 15:07:49 -0700

x86: Add symbolic constant for exceptions with error code

Add a symbolic constant for the bitmask which states which exceptions
carry an error code.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Link: http://lkml.kernel.org/r/1334794610-5546-3-git-send-email-hpa@zytor.com
---
 arch/x86/include/asm/segment.h |    2 ++
 arch/x86/kernel/head_64.S      |    2 +-
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/segment.h b/arch/x86/include/asm/segment.h
index 1654662..58c1e6c 100644
--- a/arch/x86/include/asm/segment.h
+++ b/arch/x86/include/asm/segment.h
@@ -205,6 +205,8 @@
 
 #define IDT_ENTRIES 256
 #define NUM_EXCEPTION_VECTORS 32
+/* Bitmask of exception vectors which push an error code on the stack */
+#define EXCEPTION_ERRCODE_MASK  0x00027d00
 #define GDT_SIZE (GDT_ENTRIES * 8)
 #define GDT_ENTRY_TLS_ENTRIES 3
 #define TLS_SIZE (GDT_ENTRY_TLS_ENTRIES * 8)
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 40f4eb3..adf52e8 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -295,7 +295,7 @@ ENTRY(early_idt_handler)
 	ja 0f
 	movl $1,%eax
 	salq %cl,%rax
-	testl $0x27d00,%eax
+	testl $EXCEPTION_ERRCODE_MASK,%eax
 	je 0f
 	popq %r8		# get error code
 0:	movq 0(%rsp),%rcx	# get ip
