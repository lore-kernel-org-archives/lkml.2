Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933741Ab2EWQIf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 12:08:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41783 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932077Ab2EWQId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 12:08:33 -0400
Date: Wed, 23 May 2012 09:08:17 -0700
From: tip-bot for Borislav Petkov <borislav.petkov@amd.com>
Message-ID: <tip-80f033610fb968e75f5d470233d8d0260d7a72ed@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        frank.arnold@amd.com, akpm@linux-foundation.org, tglx@linutronix.de,
        borislav.petkov@amd.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, frank.arnold@amd.com,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, borislav.petkov@amd.com
In-Reply-To: <1337684026-19740-2-git-send-email-bp@amd64.org>
References: <1337684026-19740-2-git-send-email-bp@amd64.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mce] x86/mce: Fix 32-bit build
Git-Commit-ID: 80f033610fb968e75f5d470233d8d0260d7a72ed
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 23 May 2012 09:08:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  80f033610fb968e75f5d470233d8d0260d7a72ed
Gitweb:     http://git.kernel.org/tip/80f033610fb968e75f5d470233d8d0260d7a72ed
Author:     Borislav Petkov <borislav.petkov@amd.com>
AuthorDate: Tue, 22 May 2012 12:53:46 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 23 May 2012 17:16:43 +0200

x86/mce: Fix 32-bit build

Got bitten again by the BIT() macro:

 arch/x86/kernel/cpu/mcheck/mce.c: In function '__mcheck_cpu_apply_quirks':
 arch/x86/kernel/cpu/mcheck/mce.c:1453:6: warning: left shift
 count >= width of type arch/x86/kernel/cpu/mcheck/mce.c:1454:7: warning: left shift count >= width of type

Fix it already.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Cc: Frank Arnold <frank.arnold@amd.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1337684026-19740-2-git-send-email-bp@amd64.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/mcheck/mce.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 888fbf9..0456b9a 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1450,9 +1450,9 @@ static int __cpuinit __mcheck_cpu_apply_quirks(struct cpuinfo_x86 *c)
 				 rdmsrl(msrs[i], val);
 
 				 /* CntP bit set? */
-				 if (val & BIT(62)) {
-					 val &= ~BIT(62);
-					 wrmsrl(msrs[i], val);
+				 if (val & BIT_64(62)) {
+					val &= ~BIT_64(62);
+					wrmsrl(msrs[i], val);
 				 }
 			 }
 
