Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758202Ab0GTHzv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 03:55:51 -0400
Received: from mtagate7.de.ibm.com ([195.212.17.167]:37184 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754629Ab0GTHzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 03:55:49 -0400
Date: Tue, 20 Jul 2010 09:55:46 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Venkatesh Pallipadi <venki@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Paul Menage <menage@google.com>, linux-kernel@vger.kernel.org,
        Paul Turner <pjt@google.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Paul Mackerras <paulus@samba.org>, Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH 0/4] Finer granularity and task/cgroup irq time
 accounting
Message-ID: <20100720095546.2f899e04@mschwide.boeblingen.de.ibm.com>
In-Reply-To: <1279583835-22854-1-git-send-email-venki@google.com>
References: <1279583835-22854-1-git-send-email-venki@google.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Jul 2010 16:57:11 -0700
Venkatesh Pallipadi <venki@google.com> wrote:

> Currently, the softirq and hardirq time reporting is only done at the
> CPU level. There are usecases where reporting this time against task
> or task groups or cgroups will be useful for user/administrator
> in terms of resource planning and utilization charging. Also, as the
> accoounting is already done at the CPU level, reporting the same at
> the task level does not add any significant computational overhead
> other than task level storage (patch 1).

I never understood why the softirq and hardirq time gets accounted to a
task at all. Why is it that the poor task that is running gets charged
with the cpu time of an interrupt that has nothing to do with the task?
I consider this to be a bug, and now this gets formalized in the
taskstats interface? Imho not a good idea.

> The softirq/hardirq statistics commonly done based on tick based sampling.
> Though some archs have CONFIG_VIRT_CPU_ACCOUNTING based fine granularity
> accounting. Having similar mechanism to get fine granularity accounting
> on x86 will be a major challenge, given the state of TSC reliability
> on various platforms and also the overhead it may add in common paths
> like syscall entry exit.
> 
> An alternative is to have a generic (sched_clock based) and configurable
> fine-granularity accounting of si and hi time which can be reported
> over the /proc/<pid>/stat API (patch 2).

To get fine granular accounting for interrupts you need to do a
sched_clock call on irq entry and another one on irq exit. Isn't that
too expensive on a x86 system? (I do think this is a good idea but
still there is the worry about the overhead).

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

