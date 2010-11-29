Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753580Ab0K2LuT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 06:50:19 -0500
Received: from canuck.infradead.org ([134.117.69.58]:34461 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753547Ab0K2LuR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 06:50:17 -0500
Subject: Re: Scheduler grouping failure; division by zero in
 select_task_rq_fair
From: Peter Zijlstra <peterz@infradead.org>
To: Ben Hutchings <benh@debian.org>
Cc: Frede_Feuerstein@gmx.net, Ingo Molnar <mingo@elte.hu>,
        603229@bugs.debian.org, LKML <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>
In-Reply-To: <1290975266.3292.316.camel@localhost>
References: <1290449310.3868.13.camel@localhost>
	 <1290470134.6770.929.camel@localhost>  <1290514638.3892.16.camel@localhost>
	 <1290900814.3292.84.camel@localhost> <1290920436.4255.1025.camel@localhost>
	 <1290975266.3292.316.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 29 Nov 2010 12:50:25 +0100
Message-ID: <1291031425.32004.16.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-11-28 at 20:14 +0000, Ben Hutchings wrote:

> [    0.856002] Pid: 2, comm: kthreadd Not tainted 2.6.32-5-amd64 #1 W1100z/2100z

What's in that kernel? is that simply the latest .32-stable?

> [    0.536554] CPU0 attaching sched-domain:
> [    0.540004]  domain 0: span 0-1 level MC
> [    0.548002]   groups: 0 1
> [    0.560003]   domain 1: span 0-3 level NODE
> [    0.568002]    groups:
> [    0.574179] ERROR: domain->cpu_power not set
> [    0.576002]
> [    0.580002] ERROR: groups don't span domain->span
> [    0.584004] CPU1 attaching sched-domain:
> [    0.588007]  domain 0: span 0-1 level MC
> [    0.596002]   groups: 1 0 (cpu_power = 1023)
> [    0.612002] ERROR: parent span is not a superset of domain->span
> [    0.616003]   domain 1: span 1-3 level CPU
> [    0.624002]    groups: 1 (cpu_power = 2048) 2-3 (cpu_power = 2048)
> [    0.644003]    domain 2: span 0-3 level NODE
> [    0.652004]     groups: 1-3 (cpu_power = 4096)
> [    0.668002] ERROR: domain->cpu_power not set
> [    0.672002]
> [    0.676002] ERROR: groups don't span domain->span
> [    0.680004] CPU2 attaching sched-domain:
> [    0.684003]  domain 0: span 2-3 level MC
> [    0.692003]   groups: 2 3
> [    0.704003]   domain 1: span 1-3 level CPU
> [    0.712003]    groups: 2-3 (cpu_power = 2048) 1 (cpu_power = 2048)
> [    0.736003]    domain 2: span 0-3 level NODE
> [    0.744003]     groups: 1-3 (cpu_power = 4096)
> [    0.760003] ERROR: domain->cpu_power not set
> [    0.764003]
> [    0.768003] ERROR: groups don't span domain->span
> [    0.772004] CPU3 attaching sched-domain:
> [    0.776003]  domain 0: span 2-3 level MC
> [    0.784003]   groups: 3 2
> [    0.794183]   domain 1: span 1-3 level CPU
> [    0.800003]    groups: 2-3 (cpu_power = 2048) 1 (cpu_power = 2048)
> [    0.822183]    domain 2: span 0-3 level NODE
> [    0.828003]     groups: 1-3 (cpu_power = 4096)
> [    0.842180] ERROR: domain->cpu_power not set
> [    0.844003]
> [    0.848003] ERROR: groups don't span domain->span

Hrm that smells like the architecture topology setup is wrecked, looks
like the NUMA setup is bonkers.

I really know very little about that code, I think Tejun recently poked
at that in an attempt to merge 32 and 64bit x86.

Also,  its very weird CPU0 only gets to have 2 domains, while the other
3 get 3 domains..

Ingo, who knows this stuff?
