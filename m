Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751249Ab1AECyY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 21:54:24 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:39931 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751141Ab1AECyX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 21:54:23 -0500
Date: Wed, 5 Jan 2011 13:54:16 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
        Christoph Lameter <cl@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Renninger <trenn@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: linux-next: manual merge of the percpu tree with the tip tree
Message-Id: <20110105135416.e87b4c26.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today's linux-next merge of the percpu tree got a conflict in
arch/x86/kernel/process.c between commit
25e41933b58777f2d020c3b0186b430ea004ec28 ("perf: Clean up power events by
introducing new, more generic ones") from the tip tree and commit
7b543a5334ff4ea2e3ad3b777fc23cdb8072a988 ("x86: Replace uses of
current_cpu_data with this_cpu ops") from the percpu tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/x86/kernel/process.c
index c852041,dae1c07..0000000
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@@ -444,9 -444,8 +444,9 @@@ EXPORT_SYMBOL_GPL(cpu_idle_wait)
  void mwait_idle_with_hints(unsigned long ax, unsigned long cx)
  {
  	trace_power_start(POWER_CSTATE, (ax>>4)+1, smp_processor_id());
 +	trace_cpu_idle((ax>>4)+1, smp_processor_id());
  	if (!need_resched()) {
- 		if (cpu_has(&current_cpu_data, X86_FEATURE_CLFLUSH_MONITOR))
+ 		if (cpu_has(__this_cpu_ptr(&cpu_info), X86_FEATURE_CLFLUSH_MONITOR))
  			clflush((void *)&current_thread_info()->flags);
  
  		__monitor((void *)&current_thread_info()->flags, 0, 0);
@@@ -461,8 -460,7 +461,8 @@@ static void mwait_idle(void
  {
  	if (!need_resched()) {
  		trace_power_start(POWER_CSTATE, 1, smp_processor_id());
 +		trace_cpu_idle(1, smp_processor_id());
- 		if (cpu_has(&current_cpu_data, X86_FEATURE_CLFLUSH_MONITOR))
+ 		if (cpu_has(__this_cpu_ptr(&cpu_info), X86_FEATURE_CLFLUSH_MONITOR))
  			clflush((void *)&current_thread_info()->flags);
  
  		__monitor((void *)&current_thread_info()->flags, 0, 0);
