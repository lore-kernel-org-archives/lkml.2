Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754483Ab1EURUI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 13:20:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:34042 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752647Ab1EURUF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 13:20:05 -0400
Date: Sat, 21 May 2011 17:19:52 GMT
From: tip-bot for Fenghua Yu <fenghua.yu@intel.com>
Message-ID: <tip-1d487624fcc17a40aa67acaa9e8f3815fb7cd0f0@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        yinghai@kernel.org, torvalds@linux-foundation.org,
        asit.k.mallick@intel.com, fenghua.yu@intel.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, torvalds@linux-foundation.org,
        asit.k.mallick@intel.com, fenghua.yu@intel.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <1305930797-11409-1-git-send-email-fenghua.yu@intel.com>
References: <1305930797-11409-1-git-send-email-fenghua.yu@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, SMEP: Fix section mismatch warnings
Git-Commit-ID: 1d487624fcc17a40aa67acaa9e8f3815fb7cd0f0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 21 May 2011 17:19:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1d487624fcc17a40aa67acaa9e8f3815fb7cd0f0
Gitweb:     http://git.kernel.org/tip/1d487624fcc17a40aa67acaa9e8f3815fb7cd0f0
Author:     Fenghua Yu <fenghua.yu@intel.com>
AuthorDate: Fri, 20 May 2011 15:33:17 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 21 May 2011 12:46:24 +0200

x86, SMEP: Fix section mismatch warnings

Fix these kernel compilation warnings:

 WARNING: arch/x86/built-in.o(.cpuinit.text+0x1e07): Section mismatch ...
 WARNING: arch/x86/built-in.o(.cpuinit.text+0x1b10): Section mismatch ...

introduced by:

  de5397ad5b9a: x86, cpu: Enable/disable Supervisor Mode Execution Protection

Change disable_smep from __initdata to __cpuinitdata.
Change setup_smep() from __init to __cpuinit.

Reported-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Cc: Asit K Mallick <asit.k.mallick@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1305930797-11409-1-git-send-email-fenghua.yu@intel.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/common.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index cbc70a2..c8b4162 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -254,7 +254,7 @@ static inline void squash_the_stupid_serial_number(struct cpuinfo_x86 *c)
 }
 #endif
 
-static int disable_smep __initdata;
+static int disable_smep __cpuinitdata;
 static __init int setup_disable_smep(char *arg)
 {
 	disable_smep = 1;
@@ -262,7 +262,7 @@ static __init int setup_disable_smep(char *arg)
 }
 __setup("nosmep", setup_disable_smep);
 
-static __init void setup_smep(struct cpuinfo_x86 *c)
+static __cpuinit void setup_smep(struct cpuinfo_x86 *c)
 {
 	if (cpu_has(c, X86_FEATURE_SMEP)) {
 		if (unlikely(disable_smep)) {
