Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932796Ab2K0ABx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 19:01:53 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44932 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932594Ab2K0ABv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 19:01:51 -0500
Date: Mon, 26 Nov 2012 16:01:38 -0800
From: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Message-ID: <tip-cb7cb2864e758a1b040040bc55e404c677c911cb@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        pbonzini@redhat.com, mtosatti@redhat.com, tglx@linutronix.de,
        hpa@linux.intel.com, melanie.blower@intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        mtosatti@redhat.com, pbonzini@redhat.com, tglx@linutronix.de,
        hpa@linux.intel.com, melanie.blower@intel.com
In-Reply-To: <B3584E72CFEBED439A3ECA9BCE67A4EF1B17AF90@FMSMSX107.amr.corp.intel.com>
References: <B3584E72CFEBED439A3ECA9BCE67A4EF1B17AF90@FMSMSX107.amr.corp.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, kvm:
  Remove incorrect redundant assembly constraint
Git-Commit-ID: cb7cb2864e758a1b040040bc55e404c677c911cb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 26 Nov 2012 16:01:44 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cb7cb2864e758a1b040040bc55e404c677c911cb
Gitweb:     http://git.kernel.org/tip/cb7cb2864e758a1b040040bc55e404c677c911cb
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Wed, 21 Nov 2012 14:41:21 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 26 Nov 2012 15:52:48 -0800

x86, kvm: Remove incorrect redundant assembly constraint

In __emulate_1op_rax_rdx, we use "+a" and "+d" which are input/output
constraints, and *then* use "a" and "d" as input constraints.  This is
incorrect, but happens to work on some versions of gcc.

However, it breaks gcc with -O0 and icc, and may break on future
versions of gcc.

Reported-and-tested-by: Melanie Blower <melanie.blower@intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Link: http://lkml.kernel.org/r/B3584E72CFEBED439A3ECA9BCE67A4EF1B17AF90@FMSMSX107.amr.corp.intel.com
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Acked-by: Marcelo Tosatti <mtosatti@redhat.com>
---
 arch/x86/kvm/emulate.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 39171cb..bba39bf 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -426,8 +426,7 @@ static void invalidate_registers(struct x86_emulate_ctxt *ctxt)
 			_ASM_EXTABLE(1b, 3b)				\
 			: "=m" ((ctxt)->eflags), "=&r" (_tmp),		\
 			  "+a" (*rax), "+d" (*rdx), "+qm"(_ex)		\
-			: "i" (EFLAGS_MASK), "m" ((ctxt)->src.val),	\
-			  "a" (*rax), "d" (*rdx));			\
+			: "i" (EFLAGS_MASK), "m" ((ctxt)->src.val));	\
 	} while (0)
 
 /* instruction has only one source operand, destination is implicit (e.g. mul, div, imul, idiv) */
