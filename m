Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575Ab2BHDXA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 22:23:00 -0500
Received: from merlin.infradead.org ([205.233.59.134]:37779 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010Ab2BHDW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 22:22:57 -0500
Subject: Re: [PATCH 0/4] CPU hotplug, cpusets: Fix CPU online handling
 related to cpusets
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: paul@paulmenage.org, mingo@elte.hu, rjw@sisk.pl, tj@kernel.org,
        frank.rowand@am.sony.com, pjt@google.com, tglx@linutronix.de,
        lizf@cn.fujitsu.com, prashanth@linux.vnet.ibm.com,
        paulmck@linux.vnet.ibm.com, vatsa@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
In-Reply-To: <20120207185411.7482.43576.stgit@srivatsabhat.in.ibm.com>
References: <20120207185411.7482.43576.stgit@srivatsabhat.in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 08 Feb 2012 04:22:15 +0100
Message-ID: <1328671335.2482.72.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-02-08 at 00:25 +0530, Srivatsa S. Bhat wrote:
> There is a very long standing issue related to how cpusets handle CPU
> hotplug events. The problem is that when a CPU goes offline, it is removed
> from all cpusets. However, when that CPU comes back online, it is added
> *only* to the root cpuset. Which means, any task attached to a cpuset lower
> in the hierarchy will have one CPU less in its cpuset, though it had this
> CPU in its cpuset before the CPU went offline.

Yeah so? That's known behaviour..

> The issue gets enormously aggravated in the case of suspend/resume.

Why does suspend resume does this anyway? hotunplug is terribly
expensive, surely not doing it would make suspend ever so much faster?

>  During
> suspend, all non-boot CPUs are taken offline. Which means, all those CPUs
> get removed from all the cpusets. When the system resumes, all CPUs are
> brought back online; however, the newly onlined CPUs get added only to the
> root cpuset - and all other cpusets have cpuset.cpus = 0 (boot cpu alone)!
> This means, (as is obvious), all those tasks attached to non-root cpusets
> will be constrained to run only on one single cpu!
> 
> So, imagine the amount of performance degradation after suspend/resume!!
> 
> In particular, libvirt is one of the active users of cpusets. And apparently,
> people hit this problem long ago:
> https://bugzilla.redhat.com/show_bug.cgi?id=714271
> 
> But unfortunately this never got resolved since people probably thought that
> the bug was in libvirt... and all this time the kernel was the culprit!

/me boggles, why do you use cpusets on a system small enough to suspend,
and I'm so not going to ask about libvirt because I know I'll just get
sad.



