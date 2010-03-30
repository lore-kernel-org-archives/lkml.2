Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932411Ab0C3XxJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:53:09 -0400
Received: from kroah.org ([198.145.64.141]:45756 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932417Ab0C3XT3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:19:29 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:47:32 2010
Message-Id: <20100330224732.429575021@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:40:53 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Paul Mackerras <paulus@samba.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [019/156] hw-breakpoints: Remove stub unthrottle callback
In-Reply-To: <20100330230630.GA28824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Frederic Weisbecker <fweisbec@gmail.com>

commit 1e259e0a9982078896f3404240096cbea01daca4 upstream.

We support event unthrottling in breakpoint events. It means
that if we have more than sysctl_perf_event_sample_rate/HZ,
perf will throttle, ignoring subsequent events until the next
tick.

So if ptrace exceeds this max rate, it will omit events, which
breaks the ptrace determinism that is supposed to report every
triggered breakpoints. This is likely to happen if we set
sysctl_perf_event_sample_rate to 1.

This patch removes support for unthrottling in breakpoint
events to break throttling and restore ptrace determinism.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: K.Prasad <prasad@linux.vnet.ibm.com>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/hw_breakpoint.c |    5 -----
 kernel/hw_breakpoint.c          |    1 -
 2 files changed, 6 deletions(-)

--- a/arch/x86/kernel/hw_breakpoint.c
+++ b/arch/x86/kernel/hw_breakpoint.c
@@ -531,8 +531,3 @@ void hw_breakpoint_pmu_read(struct perf_
 {
 	/* TODO */
 }
-
-void hw_breakpoint_pmu_unthrottle(struct perf_event *bp)
-{
-	/* TODO */
-}
--- a/kernel/hw_breakpoint.c
+++ b/kernel/hw_breakpoint.c
@@ -489,5 +489,4 @@ struct pmu perf_ops_bp = {
 	.enable		= arch_install_hw_breakpoint,
 	.disable	= arch_uninstall_hw_breakpoint,
 	.read		= hw_breakpoint_pmu_read,
-	.unthrottle	= hw_breakpoint_pmu_unthrottle
 };


