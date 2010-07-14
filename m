Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755146Ab0GNAzT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 20:55:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:60869 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753168Ab0GNAzR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 20:55:17 -0400
Date: Wed, 14 Jul 2010 00:54:59 GMT
From: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        yinhai@kernel.org, suresh.b.siddha@intel.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinhai@kernel.org, suresh.b.siddha@intel.com, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <tip-df378ccfc4dd04e263426ad805516915874774aa@git.kernel.org>
References: <tip-df378ccfc4dd04e263426ad805516915874774aa@git.kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/alternatives] x86, alternatives: BUG on encountering an invalid CPU feature number
Message-ID: <tip-3b770a2128423a687e6e9c57184a584fb4ba4c77@git.kernel.org>
Git-Commit-ID: 3b770a2128423a687e6e9c57184a584fb4ba4c77
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 14 Jul 2010 00:55:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3b770a2128423a687e6e9c57184a584fb4ba4c77
Gitweb:     http://git.kernel.org/tip/3b770a2128423a687e6e9c57184a584fb4ba4c77
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Tue, 13 Jul 2010 14:57:50 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 13 Jul 2010 14:57:50 -0700

x86, alternatives: BUG on encountering an invalid CPU feature number

Make the alternatives-patching code BUG on encountering an invalid CPU
feature number.  Should have done this a long time ago.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: Yinghai Lu <yinhai@kernel.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
LKML-Reference: <tip-df378ccfc4dd04e263426ad805516915874774aa@git.kernel.org>
---
 arch/x86/kernel/alternative.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 7023773..f65ab8b 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -214,6 +214,7 @@ void __init_or_module apply_alternatives(struct alt_instr *start,
 		u8 *instr = a->instr;
 		BUG_ON(a->replacementlen > a->instrlen);
 		BUG_ON(a->instrlen > sizeof(insnbuf));
+		BUG_ON(a->cpuid >= NCAPINTS*32);
 		if (!boot_cpu_has(a->cpuid))
 			continue;
 #ifdef CONFIG_X86_64
