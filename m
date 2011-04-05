Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752587Ab1DED7J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 23:59:09 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:47976 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752100Ab1DED7G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 23:59:06 -0400
Date: Tue, 5 Apr 2011 13:58:56 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Lameter <cl@linux.com>, Tejun Heo <tj@kernel.org>,
        Len Brown <len.brown@intel.com>
Subject: linux-next: manual merge of the tip tree with the idle-test tree
Message-Id: <20110405135856.0e1cf880.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today's linux-next merge of the tip tree got a conflict in
arch/x86/kernel/process.c between commits 68855c4b4018 ("x86 idle: move
mwait_idle_with_hints() to where it is used") and 42be29a3d2b7 ("2.6.40:
x86 idle: remove deprecated mwait_idle()") from the idle-test tree and
commit 349c004e3d31 ("x86: A fast way to check capabilities of the
current cpu") from the tip tree.

The former commits move and remove the code changed by the latter.  I
used the tip version but with this merge fix patch:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 5 Apr 2011 13:43:41 +1000
Subject: [PATCH] x86 idle: merge fix for mwait move

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/x86/kernel/acpi/cstate.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/acpi/cstate.c b/arch/x86/kernel/acpi/cstate.c
index c49281e..22de153 100644
--- a/arch/x86/kernel/acpi/cstate.c
+++ b/arch/x86/kernel/acpi/cstate.c
@@ -162,7 +162,7 @@ EXPORT_SYMBOL_GPL(acpi_processor_ffh_cstate_probe);
 static void mwait_idle_with_hints(unsigned long ax, unsigned long cx)
 {
 	if (!need_resched()) {
-		if (cpu_has(__this_cpu_ptr(&cpu_info), X86_FEATURE_CLFLUSH_MONITOR))
+		if (this_cpu_has(X86_FEATURE_CLFLUSH_MONITOR))
 			clflush((void *)&current_thread_info()->flags);
 
 		__monitor((void *)&current_thread_info()->flags, 0, 0);
-- 
1.7.4.1


-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
