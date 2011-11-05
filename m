Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214Ab1KELR7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Nov 2011 07:17:59 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:42193 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752835Ab1KELR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Nov 2011 07:17:58 -0400
Message-ID: <4EB51B5A.9020300@linux.vnet.ibm.com>
Date: Sat, 05 Nov 2011 16:47:46 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Fenghua Yu <fenghua.yu@intel.com>
CC: Thomas Gleixner <tglx@linutronix.de>, H Peter Anvin <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>,
        Suresh B Siddha <suresh.b.siddha@intel.com>,
        Len Brown <len.brown@intel.com>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>
Subject: Re: [PATCH 0/9] BSP or CPU0 online/offline
References: <1320444241-834-1-git-send-email-fenghua.yu@intel.com>
In-Reply-To: <1320444241-834-1-git-send-email-fenghua.yu@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 11110501-5140-0000-0000-00000029FF01
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/2011 03:33 AM, Fenghua Yu wrote:
> From: Fenghua Yu <fenghua.yu@intel.com>
> 
> BSP or CPU0 has been the last obstacle to CPU hotplug on x86. This patch set
> implements BSP online and offline and removes this obstacle to CPU hotplug.
> 
> RAS needs the feature. If socket0 needs to be hotplugged for any reason (any
> thread on socket0 is bad, shared cache issue, uncore issue, etc), CPU0 is
> required to be offline or hot replaced to keep the system run.
> 
> Fenghua Yu (9):
>   include/linux/cpu.h: Define architecture dependent cpu map update and
>     state check functions
>   kernel/cpu.c: Add arch dependent cpu map update functions
>   x86/i387.c: Thread xstate is initialized only on BSP once
>   x86/common.c: Init BSP data during BSP online
>   x86/mtrr/main.c: Ask the first online CPU to save mtrr
>   kernel/power/suspend.c,hibernate.c: Don't hibernate/suspend if CPU0
>     is offline
>   x86/topology.c: Support functions for BSP online/offline
>   x86/smpboot.c: Don't offline BSP if any irq can not be migrated out
>     of it
>   Documentations/cpu-hotplug.tx, kernel-parameters.txt: Add x86 CPU0
>     online/offline feature
> 

The norm usually followed is to update the version number of the patch
or patchset at each iteration and mention the significant changes between
the versions in the changelog/cover-letter (and possibly give links to older
versions). This would make reviewing patches much more easier.

>  Documentation/cpu-hotplug.txt       |   19 +++++++++++++++
>  Documentation/kernel-parameters.txt |   13 ++++++++++
>  arch/x86/include/asm/processor.h    |    1 +
>  arch/x86/kernel/cpu/common.c        |   13 ++++++++--
>  arch/x86/kernel/cpu/mtrr/main.c     |    9 +++++-
>  arch/x86/kernel/i387.c              |    9 ++++++-
>  arch/x86/kernel/smpboot.c           |   43 ++++++++++++++++++++++++++++-----
>  arch/x86/kernel/topology.c          |   44 +++++++++++++++++++++++++++++-----
>  include/linux/cpu.h                 |    6 ++++
>  kernel/cpu.c                        |   12 +++++++++
>  kernel/power/hibernate.c            |    5 ++++
>  kernel/power/main.c                 |    5 ++++
>  kernel/power/suspend.c              |    4 +++
>  13 files changed, 163 insertions(+), 20 deletions(-)
> 

Thanks,
Srivatsa S. Bhat

