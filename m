Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760508Ab2EWQHq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 12:07:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41771 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754851Ab2EWQHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 12:07:44 -0400
Date: Wed, 23 May 2012 09:07:26 -0700
From: tip-bot for Borislav Petkov <borislav.petkov@amd.com>
Message-ID: <tip-e8f380e00840f694599e6ab42806639f7de26f11@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, frank.arnold@amd.com, tglx@linutronix.de,
        borislav.petkov@amd.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        frank.arnold@amd.com, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, borislav.petkov@amd.com
In-Reply-To: <1337684026-19740-1-git-send-email-bp@amd64.org>
References: <1337684026-19740-1-git-send-email-bp@amd64.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mce] x86/bitops: Move BIT_64() for a wider use
Git-Commit-ID: e8f380e00840f694599e6ab42806639f7de26f11
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 23 May 2012 09:07:32 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e8f380e00840f694599e6ab42806639f7de26f11
Gitweb:     http://git.kernel.org/tip/e8f380e00840f694599e6ab42806639f7de26f11
Author:     Borislav Petkov <borislav.petkov@amd.com>
AuthorDate: Tue, 22 May 2012 12:53:45 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 23 May 2012 17:16:42 +0200

x86/bitops: Move BIT_64() for a wider use

Needed for shifting 64-bit values on 32-bit, like MSR values,
for example.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frank Arnold <frank.arnold@amd.com>
Link: http://lkml.kernel.org/r/1337684026-19740-1-git-send-email-bp@amd64.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/bitops.h |    2 ++
 drivers/edac/mce_amd.h        |    2 --
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/bitops.h b/arch/x86/include/asm/bitops.h
index b97596e..a6983b2 100644
--- a/arch/x86/include/asm/bitops.h
+++ b/arch/x86/include/asm/bitops.h
@@ -15,6 +15,8 @@
 #include <linux/compiler.h>
 #include <asm/alternative.h>
 
+#define BIT_64(n)			(U64_C(1) << (n))
+
 /*
  * These have to be done with inline assembly: that way the bit-setting
  * is guaranteed to be atomic. All bit operations return 0 if the bit
diff --git a/drivers/edac/mce_amd.h b/drivers/edac/mce_amd.h
index c6074c5..8c87a5e 100644
--- a/drivers/edac/mce_amd.h
+++ b/drivers/edac/mce_amd.h
@@ -5,8 +5,6 @@
 
 #include <asm/mce.h>
 
-#define BIT_64(n)			(U64_C(1) << (n))
-
 #define EC(x)				((x) & 0xffff)
 #define XEC(x, mask)			(((x) >> 16) & mask)
 
