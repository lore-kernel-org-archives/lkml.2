Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758104Ab0JLTAc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 15:00:32 -0400
Received: from smtp-out.google.com ([216.239.44.51]:48748 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757474Ab0JLTAb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 15:00:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=XH7WAL/VqsrKiSh++bgd6lG2dcbVWi49HfvTEz2KE7ei1Yjc6UfbSZEIeT6//JpjxA
         EqkD7Gc8WPUERp5HrvIQ==
MIME-Version: 1.0
In-Reply-To: <1286237003-12406-1-git-send-email-venki@google.com>
References: <1286237003-12406-1-git-send-email-venki@google.com>
Date: Tue, 12 Oct 2010 12:00:23 -0700
Message-ID: <AANLkTikPXWBbLnfUkKFRpG3bGnUi9XCEiGs55hundLff@mail.gmail.com>
Subject: Re: Proper kernel irq time accounting -v4
From: Venkatesh Pallipadi <venki@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Paul Turner <pjt@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Venkatesh Pallipadi <venki@google.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 4, 2010 at 5:03 PM, Venkatesh Pallipadi <venki@google.com> wrote:
> Previous versions:
> -v0: http://lkml.indiana.edu/hypermail//linux/kernel/1005.3/00411.html
>     lkml subject - "Finer granularity and task/cgroup irq time accounting"
>
> -v1: http://lkml.indiana.edu/hypermail//linux/kernel/1007.2/00987.html
>     lkml subject - "Finer granularity and task/cgroup irq time accounting"
>
> -v2: http://lkml.indiana.edu/hypermail//linux/kernel/1009.2/00488.html
>     lkml subject - "Proper kernel irq time accounting"
>
> -v3: http://lkml.indiana.edu/hypermail//linux/kernel/1009.3/02482.html
>     lkml subject - "Proper kernel irq time accounting -v3"
>
>
> Change from -v3:
> - Switch to using sched_clock_cpu instead of sched_clock in
>  account_system_vtime. This needed tick_check_idle to be called early in
>  irq_enter.
> - Do not account softirq time in ksoftirqd context. We want ksoftirqd to
>  continue having sched exec_runtime.
> - Add a boot option to disable tsc based irq accounting in x86.
> - Remove the patch that exported irq times in /proc/interrupts and
>  /proc/softirqs. I am relooking at other options to export that and
>  will have a replacement patch soon.
>
>

Peter,

If the patchset looks sane can you push this along to tip please.

Thanks,
Venki
