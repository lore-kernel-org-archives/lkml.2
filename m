Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758440Ab2IEKzk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 06:55:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56227 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008Ab2IEKzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 06:55:39 -0400
Date: Wed, 5 Sep 2012 03:55:25 -0700
From: tip-bot for Mathias Krause <minipli@googlemail.com>
Message-ID: <tip-3d1334064fb365ea8f299874c2b4c46de2bee74d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        minipli@googlemail.com, tglx@linutronix.de, luto@MIT.EDU
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        minipli@googlemail.com, tglx@linutronix.de, luto@MIT.EDU
In-Reply-To: <1346621506-30857-3-git-send-email-minipli@googlemail.com>
References: <1346621506-30857-3-git-send-email-minipli@googlemail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/debug] x86/vdso: Add __user annotation to VDSO32_SYMBOL
Git-Commit-ID: 3d1334064fb365ea8f299874c2b4c46de2bee74d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 05 Sep 2012 03:55:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3d1334064fb365ea8f299874c2b4c46de2bee74d
Gitweb:     http://git.kernel.org/tip/3d1334064fb365ea8f299874c2b4c46de2bee74d
Author:     Mathias Krause <minipli@googlemail.com>
AuthorDate: Sun, 2 Sep 2012 23:31:41 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 5 Sep 2012 10:52:23 +0200

x86/vdso: Add __user annotation to VDSO32_SYMBOL

The address calculated by VDSO32_SYMBOL() is a pointer into
userland. Add the __user annotation to fix related sparse
warnings in its users.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Cc: Andy Lutomirski <luto@MIT.EDU>
Link: http://lkml.kernel.org/r/1346621506-30857-3-git-send-email-minipli@googlemail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/vdso.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/vdso.h b/arch/x86/include/asm/vdso.h
index bb05228..fddb53d 100644
--- a/arch/x86/include/asm/vdso.h
+++ b/arch/x86/include/asm/vdso.h
@@ -11,7 +11,8 @@ extern const char VDSO32_PRELINK[];
 #define VDSO32_SYMBOL(base, name)					\
 ({									\
 	extern const char VDSO32_##name[];				\
-	(void *)(VDSO32_##name - VDSO32_PRELINK + (unsigned long)(base)); \
+	(void __user *)(VDSO32_##name - VDSO32_PRELINK +		\
+			(unsigned long)(base));				\
 })
 #endif
 
