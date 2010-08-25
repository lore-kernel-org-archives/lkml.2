Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752495Ab0HYHOp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 03:14:45 -0400
Received: from hera.kernel.org ([140.211.167.34]:59653 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752267Ab0HYHOk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 03:14:40 -0400
Date: Wed, 25 Aug 2010 07:13:06 GMT
From: tip-bot for Hugh Dickins <hughd@google.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        hughd@google.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hughd@google.com
In-Reply-To: <alpine.LSU.2.00.1008242235120.2515@sister.anvils>
References: <alpine.LSU.2.00.1008242235120.2515@sister.anvils>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, mm: Fix CONFIG_VMSPLIT_1G and 2G_OPT trampoline
Message-ID: <tip-b7d460897739e02f186425b7276e3fdb1595cea7@git.kernel.org>
Git-Commit-ID: b7d460897739e02f186425b7276e3fdb1595cea7
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 25 Aug 2010 07:13:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b7d460897739e02f186425b7276e3fdb1595cea7
Gitweb:     http://git.kernel.org/tip/b7d460897739e02f186425b7276e3fdb1595cea7
Author:     Hugh Dickins <hughd@google.com>
AuthorDate: Tue, 24 Aug 2010 22:44:12 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 24 Aug 2010 23:05:17 -0700

x86, mm: Fix CONFIG_VMSPLIT_1G and 2G_OPT trampoline

rc2 kernel crashes when booting second cpu on this CONFIG_VMSPLIT_2G_OPT
laptop: whereas cloning from kernel to low mappings pgd range does need
to limit by both KERNEL_PGD_PTRS and KERNEL_PGD_BOUNDARY, cloning kernel
pgd range itself must not be limited by the smaller KERNEL_PGD_BOUNDARY.

Signed-off-by: Hugh Dickins <hughd@google.com>
LKML-Reference: <alpine.LSU.2.00.1008242235120.2515@sister.anvils>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/trampoline.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/trampoline.c b/arch/x86/kernel/trampoline.c
index a874495..e2a5952 100644
--- a/arch/x86/kernel/trampoline.c
+++ b/arch/x86/kernel/trampoline.c
@@ -45,8 +45,7 @@ void __init setup_trampoline_page_table(void)
 	/* Copy kernel address range */
 	clone_pgd_range(trampoline_pg_dir + KERNEL_PGD_BOUNDARY,
 			swapper_pg_dir + KERNEL_PGD_BOUNDARY,
-			min_t(unsigned long, KERNEL_PGD_PTRS,
-			      KERNEL_PGD_BOUNDARY));
+			KERNEL_PGD_PTRS);
 
 	/* Initialize low mappings */
 	clone_pgd_range(trampoline_pg_dir,
