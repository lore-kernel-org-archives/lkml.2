Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755119Ab1GFRlh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 13:41:37 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:43159 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752870Ab1GFRlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 13:41:35 -0400
Date: Wed, 6 Jul 2011 21:41:32 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Don Zickus <dzickus@redhat.com>, Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip/perf/core] perf, x86: P4 PMU - Drop redundant
 WARN_ON_ONCE
Message-ID: <20110706174131.GK5485@sun>
References: <20110706172454.GJ5485@sun>
 <1309973921.26417.188.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309973921.26417.188.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 06, 2011 at 01:38:41PM -0400, Steven Rostedt wrote:
> On Wed, 2011-07-06 at 21:24 +0400, Cyrill Gorcunov wrote:
> > This WARN_ON_ONCE triggers a false alarm on SMP because
> > nmi-watchdog uses a single global 'wd_hw_attr' variable
> > to serve perf event attributes and once p4_hw_watchdog_set_attr
> > has modified it subsequent calls on the rest cpus trigger
> > the warning.
> > 
> > It is safe to simply drop it since we know the caller may
> > pass already altered type and config.
> > 
> > Repoted-by: Steven Rostedt <rostedt@goodmis.org>
> 
> Repoted? Hmm, maybe symbolically I put this code in a different pot.
> 
> Reported-and-tested-by: Steven Rostedt <rostedt@goodmis.org>
> 

Oh, really sorry, Steven :/ Fingers... Just to have all in place.
---
perf, x86: P4 PMU - Drop redundant WARN_ON_ONCE

This WARN_ON_ONCE triggers a false alarm on SMP because
nmi-watchdog uses a single global 'wd_hw_attr' variable
to serve perf event attributes and once p4_hw_watchdog_set_attr
has modified it subsequent calls on the rest cpus trigger
the warning.

It is safe to simply drop it since we know the caller may
pass already altered type and config.

Reported-and-tested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 arch/x86/kernel/cpu/perf_event_p4.c |    3 ---
 1 file changed, 3 deletions(-)

Index: linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/cpu/perf_event_p4.c
+++ linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
@@ -726,9 +726,6 @@ static void p4_hw_watchdog_set_attr(stru
 	 * that named "non-sleeping" ticks as recommended
 	 * by Intel SDM Vol3b.
 	 */
-	WARN_ON_ONCE(wd_attr->type	!= PERF_TYPE_HARDWARE ||
-		     wd_attr->config	!= PERF_COUNT_HW_CPU_CYCLES);
-
 	wd_attr->type	= PERF_TYPE_RAW;
 	wd_attr->config	=
 		p4_config_pack_escr(P4_ESCR_EVENT(P4_EVENT_EXECUTION_EVENT)		|
