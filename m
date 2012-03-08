Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751702Ab2CHKSJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 05:18:09 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50994 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272Ab2CHKSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 05:18:06 -0500
Date: Thu, 8 Mar 2012 02:17:17 -0800
From: tip-bot for Jan Beulich <JBeulich@suse.com>
Message-ID: <tip-0d2bf4899d04fcc7f3a280b0bc74c084badb4e04@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        jbeulich@suse.com, JBeulich@suse.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        JBeulich@suse.com, jbeulich@suse.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <4F58875A02000078000770E0@nat28.tlf.novell.com>
References: <4F58875A02000078000770E0@nat28.tlf.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86: Tighten dependencies of CPU_SUP_*_32
Git-Commit-ID: 0d2bf4899d04fcc7f3a280b0bc74c084badb4e04
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 08 Mar 2012 02:17:45 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0d2bf4899d04fcc7f3a280b0bc74c084badb4e04
Gitweb:     http://git.kernel.org/tip/0d2bf4899d04fcc7f3a280b0bc74c084badb4e04
Author:     Jan Beulich <JBeulich@suse.com>
AuthorDate: Thu, 8 Mar 2012 09:18:02 +0000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 8 Mar 2012 10:57:34 +0100

x86: Tighten dependencies of CPU_SUP_*_32

Building in support for either of these CPUs is pointless when
e.g. M686 was selected (since such a kernel would use cmov
instructions, which aren't available on these older CPUs).

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Link: http://lkml.kernel.org/r/4F58875A02000078000770E0@nat28.tlf.novell.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/Kconfig.cpu |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
index 6443c6f..706e12e 100644
--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -440,7 +440,7 @@ config CPU_SUP_INTEL
 config CPU_SUP_CYRIX_32
 	default y
 	bool "Support Cyrix processors" if PROCESSOR_SELECT
-	depends on !64BIT
+	depends on M386 || M486 || M586 || M586TSC || M586MMX || (EXPERT && !64BIT)
 	---help---
 	  This enables detection, tunings and quirks for Cyrix processors
 
@@ -494,7 +494,7 @@ config CPU_SUP_TRANSMETA_32
 config CPU_SUP_UMC_32
 	default y
 	bool "Support UMC processors" if PROCESSOR_SELECT
-	depends on !64BIT
+	depends on M386 || M486 || (EXPERT && !64BIT)
 	---help---
 	  This enables detection, tunings and quirks for UMC processors
 
