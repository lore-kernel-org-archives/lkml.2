Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752917Ab2BTASt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 19:18:49 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57338 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760Ab2BTASs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 19:18:48 -0500
From: "H. Peter Anvin" <hpa@zytor.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: mingo@kernel.org, tglx@linutronix.de, hpa@zytor.com,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        hjl.tools@gmail.com
Subject: [PATCH 22/30] x32: Add struct ucontext_x32
Date: Sun, 19 Feb 2012 16:08:00 -0800
Message-Id: <1329696488-16970-23-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1329696488-16970-1-git-send-email-hpa@zytor.com>
References: <1329696488-16970-1-git-send-email-hpa@zytor.com>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sun, 19 Feb 2012 16:18:43 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. J. Lu" <hjl.tools@gmail.com>

Add a definition for struct ucontext_x32; this is inherently a mix of
the 32- and 64-bit versions.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/ia32.h |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/ia32.h b/arch/x86/include/asm/ia32.h
index 1f7e625..c6435ab 100644
--- a/arch/x86/include/asm/ia32.h
+++ b/arch/x86/include/asm/ia32.h
@@ -43,6 +43,15 @@ struct ucontext_ia32 {
 	compat_sigset_t	  uc_sigmask;	/* mask last for extensibility */
 };
 
+struct ucontext_x32 {
+	unsigned int	  uc_flags;
+	unsigned int 	  uc_link;
+	stack_ia32_t	  uc_stack;
+	unsigned int	  uc__pad0;     /* needed for alignment */
+	struct sigcontext uc_mcontext;  /* the 64-bit sigcontext type */
+	compat_sigset_t	  uc_sigmask;	/* mask last for extensibility */
+};
+
 /* This matches struct stat64 in glibc2.2, hence the absolutely
  * insane amounts of padding around dev_t's.
  */
-- 
1.7.6.5

