Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927Ab2B0MJL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 07:09:11 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45451 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541Ab2B0MJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 07:09:09 -0500
Date: Mon, 27 Feb 2012 04:08:23 -0800
From: tip-bot for Mark Wielaard <mjw@redhat.com>
Message-ID: <tip-928282e432ee584129a39da831ffa72c38e189b7@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        jbeulich@suse.com, mjw@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        mjw@redhat.com, jbeulich@suse.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1330079527-30711-1-git-send-email-mjw@redhat.com>
References: <1330079527-30711-1-git-send-email-mjw@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/debug] x86-64: Fix CFI data for common_interrupt()
Git-Commit-ID: 928282e432ee584129a39da831ffa72c38e189b7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 27 Feb 2012 04:08:51 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  928282e432ee584129a39da831ffa72c38e189b7
Gitweb:     http://git.kernel.org/tip/928282e432ee584129a39da831ffa72c38e189b7
Author:     Mark Wielaard <mjw@redhat.com>
AuthorDate: Fri, 24 Feb 2012 11:32:05 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 27 Feb 2012 10:46:14 +0100

x86-64: Fix CFI data for common_interrupt()

Commit eab9e6137f23 ("x86-64: Fix CFI data for interrupt frames")
introduced a DW_CFA_def_cfa_expression in the SAVE_ARGS_IRQ
macro. To later define the CFA using a simple register+offset
rule both register and offset need to be supplied. Just using
CFI_DEF_CFA_REGISTER leaves the offset undefined. So use
CFI_DEF_CFA with reg+off explicitly at the end of
common_interrupt.

Signed-off-by: Mark Wielaard <mjw@redhat.com>
Acked-by: Jan Beulich <jbeulich@suse.com>
Link: http://lkml.kernel.org/r/1330079527-30711-1-git-send-email-mjw@redhat.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/entry_64.S |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 3fe8239..54be36b 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -813,7 +813,7 @@ ret_from_intr:
 
 	/* Restore saved previous stack */
 	popq %rsi
-	CFI_DEF_CFA_REGISTER	rsi
+	CFI_DEF_CFA rsi,SS+8-RBP	/* reg/off reset after def_cfa_expr */
 	leaq ARGOFFSET-RBP(%rsi), %rsp
 	CFI_DEF_CFA_REGISTER	rsp
 	CFI_ADJUST_CFA_OFFSET	RBP-ARGOFFSET
