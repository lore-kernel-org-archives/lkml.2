Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755880Ab1HEIa4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 04:30:56 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46384 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758Ab1HEIax convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 04:30:53 -0400
Subject: Re: [RFT][patch 17/18] sched: use jump labels to reduce overhead
 when bandwidth control is inactive
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jason Baron <jbaron@redhat.com>
Cc: Paul Turner <pjt@google.com>, linux-kernel@vger.kernel.org,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
        rth@redhat.com
Date: Fri, 05 Aug 2011 10:30:36 +0200
In-Reply-To: <20110727215816.GA2515@redhat.com>
References: <20110722003211.GA2807@redhat.com>
	 <CAPM31R+UWijCCna5zYfn875h+KPmS4H0Lk8jW6+8JP-oDb72DA@mail.gmail.com>
	 <20110722011747.GB2807@redhat.com>
	 <CAPM31RKW+do-U8G8uL-y53BVWvr4oQbSf456A9u-SUV06tSfeg@mail.gmail.com>
	 <20110727215816.GA2515@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1312533036.10852.34.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-07-27 at 17:58 -0400, Jason Baron wrote:
> Ok, I think I finally tracked this down. It may seem a bit crazy, but
> when we are getting down to cycle counting like this, it seems that the
> link order in the kernel/Makefile can make difference. I had the
> jump_label.o listed after the core files, whereas all the code in
> jump_label.o is really slow path code (used when toggling branch
> values). As follows:
> 
> 
> --- a/kernel/Makefile
> +++ b/kernel/Makefile
> @@ -10,7 +10,7 @@ obj-y     = sched.o fork.o exec_domain.o panic.o printk.o \
>             kthread.o wait.o kfifo.o sys_ni.o posix-cpu-timers.o mutex.o \
>             hrtimer.o rwsem.o nsproxy.o srcu.o semaphore.o \
>             notifier.o ksysfs.o pm_qos_params.o sched_clock.o cred.o \
> -           async.o range.o jump_label.o
> +           async.o range.o
>  obj-y += groups.o
>  
>  ifdef CONFIG_FUNCTION_TRACER
> @@ -107,6 +107,7 @@ obj-$(CONFIG_PERF_EVENTS) += events/
>  obj-$(CONFIG_USER_RETURN_NOTIFIER) += user-return-notifier.o
>  obj-$(CONFIG_PADATA) += padata.o
>  obj-$(CONFIG_CRASH_DUMP) += crash_dump.o
> +obj-$(CONFIG_JUMP_LABEL) += jump_label.o 


OK, so _WHY_ does that make a difference and will a next version of
gnu-binutils not mess that up?
