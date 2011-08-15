Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753035Ab1HOXkQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 19:40:16 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63938 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270Ab1HOXkO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 19:40:14 -0400
MIME-Version: 1.0
Date: Mon, 15 Aug 2011 20:40:13 -0300
Message-ID: <CAELBVzAXXjfHDkUxSVM39coDC1QyNBtDc-gW27a-yascs2nVuA@mail.gmail.com>
Subject: =?windows-1252?Q?warning=3A_=91x86=5Fget=5Fevent=5Fconstraints=92_defined_but?=
	=?windows-1252?Q?_not_used?=
From: Kevin Winchester <kjwinchester@gmail.com>
To: acme@ghostprotocols.net, mingo@elte.hu, a.p.zijlstra@chello.nl
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

From:

    gcc (GCC) 4.6.1

I get the following warning:

    arch/x86/kernel/cpu/perf_event.c:1444:1: warning:
‘x86_get_event_constraints’ defined but not used [-Wunused-function]

It appears that function is only called in some of the C files that
are included into perf_event.c, namely perf_event_intel.c,
perf_event_p4.c and perf_event_p6.c.  Each of those files is
completely dependent on CONFIG_CPU_SUP_INTEL, which I obviously do not
have enabled.

At the moment, I have eliminated the warning with the patch below, but
I do not consider that to be optimal.  Is there are reason why those C
files are included directly in another C file rather than being linked
together?  Or is there some other way the code could be improved and
also remove the warning at the same time?

I do not mind doing some coding here to make this happen.  I am very
close to a warning-free build, so I would definitely like to take care
of this one.

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 4ee3abf..a37e7e9 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1440,6 +1440,7 @@ static __read_mostly struct notifier_block
perf_event_nmi_notifier = {
 static struct event_constraint unconstrained;
 static struct event_constraint emptyconstraint;

+#ifdef CONFIG_CPU_SUP_INTEL
 static struct event_constraint *
 x86_get_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *event)
 {
@@ -1454,6 +1455,7 @@ x86_get_event_constraints(struct cpu_hw_events
*cpuc, struct perf_event *event)

        return &unconstrained;
 }
+#endif

 #include "perf_event_amd.c"
 #include "perf_event_p6.c"


Thanks,

-- 
Kevin Winchester
