Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756058Ab2FTJiH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 05:38:07 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:37571 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150Ab2FTJiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 05:38:01 -0400
Message-ID: <4FE199B6.2050803@linux.vnet.ibm.com>
Date: Wed, 20 Jun 2012 15:06:54 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120424 Thunderbird/12.0
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>, mingo@kernel.org,
        pjt@google.com, paul@paulmenage.org, akpm@linux-foundation.org,
        rjw@sisk.pl, nacc@us.ibm.com, rientjes@google.com,
        paulmck@linux.vnet.ibm.com, tglx@linutronix.de,
        seto.hidetoshi@jp.fujitsu.com, tj@kernel.org, mschmidt@redhat.com,
        berrange@redhat.com, nikunj@linux.vnet.ibm.com,
        vatsa@linux.vnet.ibm.com, liuj97@gmail.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH v6 0/4] CPU hotplug, cpusets, suspend/resume: Fixes, cleanups
 and optimizations
References: <20120524141510.3692.64549.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20120524141510.3692.64549.stgit@srivatsabhat.in.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12062009-3864-0000-0000-0000036996B1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/24/2012 07:46 PM, Srivatsa S. Bhat wrote:

> Currently the kernel doesn't handle cpusets properly during suspend/resume.
> After a resume, all non-root cpusets end up having only 1 cpu (the boot cpu),
> causing massive performance degradation of workloads. One major user of cpusets
> is libvirt, which means that after a suspend/hibernation cycle, all VMs
> suddenly end up running terribly slow!
> 
> Also, the kernel moves the tasks from one cpuset to another during CPU hotplug
> in the suspend/resume path, leading to a task-management nightmare after
> resume.
> 
> Patch 1 fixes this by keeping cpusets unmodified in the suspend/resume path.
> But to ensure we don't trip over, it keeps the sched domains updated during
> every CPU hotplug in the s/r path.
> This is a long standing issue and we need to fix up stable kernels too.
> 
> The rest of the patches in the series are mostly cleanups/optimizations.
> 


Hi Peter,

Would you be taking these patches through -tip for 3.6?
 
Regards,
Srivatsa S. Bhat

