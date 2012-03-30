Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934035Ab2C3Ady (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 20:33:54 -0400
Received: from na3sys009aog126.obsmtp.com ([74.125.149.155]:34782 "EHLO
	na3sys009aog126.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933574Ab2C3Adt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 20:33:49 -0400
From: Kevin Hilman <khilman@ti.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linaro-sched-sig@lists.linaro.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Geoff Levand <geoff@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Ingo Molnar <mingo@kernel.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Alessio Igor Bogani <abogani@kernel.org>, Avi Kivity <avi@redhat.com>,
        Max Krasnyansky <maxk@qualcomm.com>, Zen Lin <zen@openhuawei.org>,
        Steven Rostedt <rostedt@goodmis.org>, Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH 00/32] Nohz cpusets v2 (adaptive tickless kernel)
Organization: Texas Instruments, Inc.
References: <1332338318-5958-1-git-send-email-fweisbec@gmail.com>
Date: Thu, 29 Mar 2012 17:33:46 -0700
Message-ID: <87r4wbhqqd.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker <fweisbec@gmail.com> writes:

> There are still a lot of things to handle. Especially about
> what is done by scheduler_tick() but we also need to:
>
> - completely handle cputime accounting (need to find every "reader"
> of cputime and flush cputimes for all of them).
> -handle  perf
> - handle irqtime finegrained accounting
> - handle ilb load balancing
> - etc...

  - add more arch support :)

For ARM, I've started hacking things into place and have some
preliminary patches to add ARM support for the new IPI, syscall support,
exception hooks, etc.[1]

This is enough to get some basic things running and test the nohz
cpusets functionality on ARM, and for others to start trying it out.

For anyone interested in collaborating on ARM support, my
work-in-progress branch is below[1] based on Frederic's cpuset-v2
branch.  Patches and testing welcome.

Kevin

[1] git://git.kernel.org/pub/scm/linux/kernel/git/khilman/linux.git wip/arm-nohz-cpusets
