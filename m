Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932221Ab2DTAY5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 20:24:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53005 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388Ab2DTAYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 20:24:55 -0400
Date: Thu, 19 Apr 2012 17:24:46 -0700
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Message-ID: <tip-46326013e34eb5c178a91f06c1f2e99e79eed924@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de
In-Reply-To: <1334794610-5546-2-git-send-email-hpa@zytor.com>
References: <1334794610-5546-2-git-send-email-hpa@zytor.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/extable] x86, nop:
  Make the ASM_NOP* macros work from assembly
Git-Commit-ID: 46326013e34eb5c178a91f06c1f2e99e79eed924
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 19 Apr 2012 17:24:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  46326013e34eb5c178a91f06c1f2e99e79eed924
Gitweb:     http://git.kernel.org/tip/46326013e34eb5c178a91f06c1f2e99e79eed924
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Wed, 18 Apr 2012 17:16:46 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 19 Apr 2012 15:07:42 -0700

x86, nop: Make the ASM_NOP* macros work from assembly

Make the ASM_NOP* macros work in actual assembly files.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Link: http://lkml.kernel.org/r/1334794610-5546-2-git-send-email-hpa@zytor.com
---
 arch/x86/include/asm/nops.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/nops.h b/arch/x86/include/asm/nops.h
index 405b403..aff2b33 100644
--- a/arch/x86/include/asm/nops.h
+++ b/arch/x86/include/asm/nops.h
@@ -87,7 +87,11 @@
 #define P6_NOP8	0x0f,0x1f,0x84,0x00,0,0,0,0
 #define P6_NOP5_ATOMIC P6_NOP5
 
+#ifdef __ASSEMBLY__
+#define _ASM_MK_NOP(x) .byte x
+#else
 #define _ASM_MK_NOP(x) ".byte " __stringify(x) "\n"
+#endif
 
 #if defined(CONFIG_MK7)
 #define ASM_NOP1 _ASM_MK_NOP(K7_NOP1)
