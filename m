Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752034Ab1HJIc2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 04:32:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:40057 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751528Ab1HJIc0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 04:32:26 -0400
Date: Wed, 10 Aug 2011 08:32:08 GMT
From: tip-bot for Stephen Rothwell <sfr@canb.auug.org.au>
Message-ID: <tip-5cdd174feab1b4a74afc494c447906274aed4a20@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        peterz@infradead.org, tglx@linutronix.de, sfr@canb.auug.org.au,
        mingo@elte.hu, borislav.petkov@amd.com, paul.gortmaker@windriver.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, sfr@canb.auug.org.au,
        paul.gortmaker@windriver.com, mingo@elte.hu, borislav.petkov@amd.com
In-Reply-To: <20110810114956.238d66772883636e3040d29f@canb.auug.org.au>
References: <20110810114956.238d66772883636e3040d29f@canb.auug.org.au>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86, amd: Include elf.h explicitly, prepare the code for the module.h split
Git-Commit-ID: 5cdd174feab1b4a74afc494c447906274aed4a20
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 10 Aug 2011 08:32:09 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5cdd174feab1b4a74afc494c447906274aed4a20
Gitweb:     http://git.kernel.org/tip/5cdd174feab1b4a74afc494c447906274aed4a20
Author:     Stephen Rothwell <sfr@canb.auug.org.au>
AuthorDate: Wed, 10 Aug 2011 11:49:56 +1000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 10 Aug 2011 10:14:09 +0200

x86, amd: Include elf.h explicitly, prepare the code for the module.h split

When the moduleu.h splitting tree is merged to the latest
tip:x86/cpu tree, the x86_64 allmodconfig build fails like this:

 arch/x86/kernel/cpu/amd.c: In function 'bsp_init_amd':
 arch/x86/kernel/cpu/amd.c:437:3: error: 'va_align' undeclared (first use in this function)
 arch/x86/kernel/cpu/amd.c:438:23: error: 'ALIGN_VA_32' undeclared (first use in this function)
 arch/x86/kernel/cpu/amd.c:438:37: error: 'ALIGN_VA_64' undeclared (first use in this function)

This is caused by the module.h split up intreacting with commit
dfb09f9b7ab0 ("x86, amd: Avoid cache aliasing penalties on AMD
family 15h") from the tip:x86/cpu tree.

I have added the following patch for today (this, or something
similar, could be applied to the tip tree directly - the
export.h include below was added by the module.h splitup).

So include elf.h to use va_align and remove this implicit
dependency on module.h doing it for us.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Borislav Petkov <borislav.petkov@amd.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Link: http://lkml.kernel.org/r/20110810114956.238d66772883636e3040d29f@canb.auug.org.au
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/amd.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index b6e3e87..13c6ec8 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -1,5 +1,6 @@
 #include <linux/init.h>
 #include <linux/bitops.h>
+#include <linux/elf.h>
 #include <linux/mm.h>
 
 #include <linux/io.h>
