Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756431Ab2FTLqA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 07:46:00 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:61168 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756255Ab2FTLp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 07:45:57 -0400
Date: Wed, 20 Jun 2012 13:39:17 +0200
From: Ingo Molnar <mingo@kernel.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, pjt@google.com,
        paul@paulmenage.org, akpm@linux-foundation.org, rjw@sisk.pl,
        nacc@us.ibm.com, rientjes@google.com, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de, seto.hidetoshi@jp.fujitsu.com, tj@kernel.org,
        mschmidt@redhat.com, berrange@redhat.com, nikunj@linux.vnet.ibm.com,
        vatsa@linux.vnet.ibm.com, liuj97@gmail.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH v6 0/4] CPU hotplug, cpusets, suspend/resume: Fixes,
 cleanups and optimizations
Message-ID: <20120620113917.GA1925@gmail.com>
References: <20120524141510.3692.64549.stgit@srivatsabhat.in.ibm.com>
 <4FE199B6.2050803@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FE199B6.2050803@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com> wrote:

> On 05/24/2012 07:46 PM, Srivatsa S. Bhat wrote:
> 
> > Currently the kernel doesn't handle cpusets properly during 
> > suspend/resume. After a resume, all non-root cpusets end up 
> > having only 1 cpu (the boot cpu), causing massive 
> > performance degradation of workloads. One major user of 
> > cpusets is libvirt, which means that after a 
> > suspend/hibernation cycle, all VMs suddenly end up running 
> > terribly slow!
> > 
> > Also, the kernel moves the tasks from one cpuset to another 
> > during CPU hotplug in the suspend/resume path, leading to a 
> > task-management nightmare after resume.
> > 
> > Patch 1 fixes this by keeping cpusets unmodified in the 
> > suspend/resume path. But to ensure we don't trip over, it 
> > keeps the sched domains updated during every CPU hotplug in 
> > the s/r path. This is a long standing issue and we need to 
> > fix up stable kernels too.
> > 
> > The rest of the patches in the series are mostly 
> > cleanups/optimizations.
> 
> Hi Peter,
> 
> Would you be taking these patches through -tip for 3.6?

They are now in tip:sched/core.

Note that I removed the Cc:stable tag - it's not a regression 
fix and such it is not eligible for immediate -stable backports.

( Once they are upstream and have been problem-free upstream for
  several weeks then *maybe* we could forward the first commit
  to -stable, as a super special exception. )

Thanks,

	Ingo
