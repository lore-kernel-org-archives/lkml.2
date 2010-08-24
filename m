Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972Ab0HXA4t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 20:56:49 -0400
Received: from smtp-out.google.com ([216.239.44.51]:62809 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753187Ab0HXA4p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 20:56:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=hxD+pIEj44TTX1ywIUEsv7hbXkkytzX8Kby7qNJNuuvRB5csJot1hb9YGKaj7dIrYS
         rhfGHtU7W0lme3lu5ZbA==
MIME-Version: 1.0
In-Reply-To: <1279583835-22854-1-git-send-email-venki@google.com>
References: <1279583835-22854-1-git-send-email-venki@google.com>
Date: Mon, 23 Aug 2010 17:56:42 -0700
Message-ID: <AANLkTikt7=Leo1xnf81QGmWdrmZA3dbPOxrCMmH9AQ=5@mail.gmail.com>
Subject: Re: [PATCH 0/4] Finer granularity and task/cgroup irq time accounting
From: Venkatesh Pallipadi <venki@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter,

Ping.
Does the patchset look sane.

Thanks,
Venki


On Mon, Jul 19, 2010 at 4:57 PM, Venkatesh Pallipadi <venki@google.com> wrote:
>
> Earlier version of this patchset here -
> lkml subject:
> "[RFC PATCH 0/4] Finer granularity and task/cgroup irq time accounting"
> http://marc.info/?l=linux-kernel&m=127474630527689&w=2
>
> Currently, the softirq and hardirq time reporting is only done at the
> CPU level. There are usecases where reporting this time against task
> or task groups or cgroups will be useful for user/administrator
> in terms of resource planning and utilization charging. Also, as the
> accoounting is already done at the CPU level, reporting the same at
> the task level does not add any significant computational overhead
> other than task level storage (patch 1).
>
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
>
> Patch 3 and 4 are exporting this info at the cgroup level.
>
> Changes since the original RFC -
> * General code cleanup and documentation for new APIs added.
> * Handle notsc option by having a runtime flag sched_clock_irqtime, along
>  with the original CONFIG_IRQ_TIME_ACCOUNTING option.
>  Peter Zijlstra suggested the use of alternate instruction kind of mechanism
>  here. But, that is mostly x86 specific and not generic. The irq time
>  accounting code is mostly generic.
> * Did performance runs with various systems with tsc based sched_clock -
>  both with and without sched_clock_stable - running tbench, dbench, SPECjbb
>  and did not notice any measurable slowness when this option is enabled.
> Todo -
> * Peter Zijlstra suggested modifying scale_rt_power to account for
>  irq time. I have a patch for that and have been testing that right now.
>  But, that change is not very pretty as yet and also will need some more
>  testing. Feels better to make that a separate change. Will follow up
>  on that soon.
>
> Thanks,
> Venki
>
>
