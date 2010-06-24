Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713Ab0FXJnR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 05:43:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:56185 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754562Ab0FXJnP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 05:43:15 -0400
Date: Thu, 24 Jun 2010 09:42:47 GMT
From: tip-bot for Andres Salomon <dilinger@queued.net>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       dilinger@queued.net, tglx@linutronix.de, hpa@linux.intel.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       dilinger@queued.net, tglx@linutronix.de, hpa@linux.intel.com,
       mingo@elte.hu
In-Reply-To: <20100618174653.7755a39a@dev.queued.net>
References: <20100618174653.7755a39a@dev.queued.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/olpc] x86, olpc: Add comment about implicit optimization barrier
Message-ID: <tip-75a9cac430a1bd2a5219c74508ca01b0ddfddc9a@git.kernel.org>
Git-Commit-ID: 75a9cac430a1bd2a5219c74508ca01b0ddfddc9a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 24 Jun 2010 09:42:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  75a9cac430a1bd2a5219c74508ca01b0ddfddc9a
Gitweb:     http://git.kernel.org/tip/75a9cac430a1bd2a5219c74508ca01b0ddfddc9a
Author:     Andres Salomon <dilinger@queued.net>
AuthorDate: Wed, 23 Jun 2010 20:27:00 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 24 Jun 2010 11:40:47 +0200

x86, olpc: Add comment about implicit optimization barrier

Signed-off-by: Andres Salomon <dilinger@queued.net>
Cc: H. Peter Anvin <hpa@linux.intel.com>
LKML-Reference: <20100618174653.7755a39a@dev.queued.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/olpc_ofw.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/olpc_ofw.c b/arch/x86/kernel/olpc_ofw.c
index 469ee43..f5d499f 100644
--- a/arch/x86/kernel/olpc_ofw.c
+++ b/arch/x86/kernel/olpc_ofw.c
@@ -35,6 +35,8 @@ void __init setup_olpc_ofw_pgd(void)
 
 	/* install OFW's PDE permanently into the kernel's pgtable */
 	set_pgd(&swapper_pg_dir[OLPC_OFW_PDE_NR], *ofw_pde);
+	/* implicit optimization barrier here due to uninline function return */
+
 	early_iounmap(base, sizeof(olpc_ofw_pgd) * PTRS_PER_PGD);
 }
 
