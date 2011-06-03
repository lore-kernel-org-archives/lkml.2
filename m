Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261Ab1FCVyz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 17:54:55 -0400
Received: from aspirin.dii.utk.edu ([160.36.0.81]:49759 "EHLO
	aspirin.dii.utk.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247Ab1FCVyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 17:54:53 -0400
Date: Fri, 3 Jun 2011 17:54:40 -0400 (EDT)
From: Vince Weaver <vweaver1@eecs.utk.edu>
To: Ingo Molnar <mingo@elte.hu>
cc: David Ahern <dsahern@gmail.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com
Subject: [patch] perf - comment /proc/sys/kernel/perf_event_paranoid to be
 part of user ABI 
In-Reply-To: <20110524212925.GL27634@elte.hu>
Message-ID: <alpine.DEB.2.00.1106031751170.29381@cl320.eecs.utk.edu>
References: <alpine.DEB.2.00.1105240955050.9203@cl320.eecs.utk.edu> <1306246306.18455.36.camel@twins> <alpine.DEB.2.00.1105241341160.24062@cl320.eecs.utk.edu> <20110524194810.GB27634@elte.hu> <alpine.DEB.2.00.1105241610390.24062@cl320.eecs.utk.edu>
 <4DDC1BB2.4090503@gmail.com> <20110524212925.GL27634@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 May 2011, Ingo Molnar wrote:

> I agree with Vince that as far as shell scripts are concerned, checking 
> /proc/sys/kernel/perf_event_paranoid would work best - and it works better than 
> having to check the perf syscall.
> 
> Vince: mind sending a patch that adds a comment to perf_event_paranoid that 
> userspace relies on the existence of that file as a feature check? Having such 
> reminders in the code works even better than frequent testing ;-)

Such a patch is included below.  Not sure if this is exactly what you 
meant.

> As far as the actual PAPI library goes i really hope it checks the syscall 
> itself: that's much faster and more robust than an 
> access("/proc/sys/kernel/perf_event_paranoid") call ...

For PAPI itself we decide with substrate to use at compile time.
This casme up because one of the vendors who ships PAPI on various kernel 
revisions had a script to choose the right package to install, and as of 
2.6.37 this broke due to /sys/devices/system/cpu/perf_events going away.

Thanks,

Vince
vweaver1@eecs.utk.edu

Signed-off-by: Vince Weaver <vweaver1@eecs.utk.edu>

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 4fc9244..cbdc7bc 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -938,6 +938,8 @@ static struct ctl_table kern_table[] = {
 	},
 #endif
 #ifdef CONFIG_PERF_EVENTS
+	/* Userspace relies on this file existing as a check for */
+	/* perf_events being enabled.  Do not remove!            */
 	{
 		.procname	= "perf_event_paranoid",
 		.data		= &sysctl_perf_event_paranoid,
