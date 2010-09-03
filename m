Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760Ab0ICNRj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 09:17:39 -0400
Received: from hera.kernel.org ([140.211.167.34]:49299 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752122Ab0ICNRi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 09:17:38 -0400
Date: Fri, 3 Sep 2010 13:15:57 GMT
From: tip-bot for Wu Fengguang <fengguang.wu@intel.com>
Cc: linux-kernel@vger.kernel.org, haicheng.li@linux.intel.com, hpa@zytor.com,
        mingo@redhat.com, peterz@infradead.org, ak@linux.intel.com,
        tglx@linutronix.de, sfr@canb.auug.org.au, fengguang.wu@intel.com,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, haicheng.li@linux.intel.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org, ak@linux.intel.com,
        tglx@linutronix.de, sfr@canb.auug.org.au, fengguang.wu@intel.com,
        mingo@elte.hu
In-Reply-To: <20100903090407.GA19771@localhost>
References: <20100903090407.GA19771@localhost>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86, mm: fix uninitialized addr in kernel_physical_mapping_init()
Message-ID: <tip-1c5f50ee347daea013671f718b70cd6bf497bef9@git.kernel.org>
Git-Commit-ID: 1c5f50ee347daea013671f718b70cd6bf497bef9
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 03 Sep 2010 13:15:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1c5f50ee347daea013671f718b70cd6bf497bef9
Gitweb:     http://git.kernel.org/tip/1c5f50ee347daea013671f718b70cd6bf497bef9
Author:     Wu Fengguang <fengguang.wu@intel.com>
AuthorDate: Fri, 3 Sep 2010 17:04:07 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 3 Sep 2010 11:40:11 +0200

x86, mm: fix uninitialized addr in kernel_physical_mapping_init()

This re-adds the lost chunk in commit 9b861528a80.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Haicheng Li <haicheng.li@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
LKML-Reference: <20100903090407.GA19771@localhost>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/mm/init_64.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 64e7bc2..74f0f35 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -570,6 +570,7 @@ kernel_physical_mapping_init(unsigned long start,
 
 	start = (unsigned long)__va(start);
 	end = (unsigned long)__va(end);
+	addr = start;
 
 	for (; start < end; start = next) {
 		pgd_t *pgd = pgd_offset_k(start);
