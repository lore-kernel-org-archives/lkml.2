Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964872Ab2FHVjb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 17:39:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34942 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091Ab2FHVj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 17:39:29 -0400
Date: Fri, 8 Jun 2012 14:39:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Don Zickus <dzickus@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, nzimmer@sgi.com, joe@perches.com
Subject: Re: [PATCH v2] watchdog: Quiet down the boot messages
Message-Id: <20120608143928.f84822cc.akpm@linux-foundation.org>
In-Reply-To: <1339189389-731-1-git-send-email-dzickus@redhat.com>
References: <1339189389-731-1-git-send-email-dzickus@redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  8 Jun 2012 17:03:09 -0400
Don Zickus <dzickus@redhat.com> wrote:

> A bunch of bugzillas have complained how noisy the nmi_watchdog is during
> boot-up especially with its expected failure cases (like virt and bios
> resource contention).
> 
> This is my attempt to quiet them down and keep it less confusing for the end
> user.  What I did is print the message for cpu0 and save it for future
> comparisons.  If future cpus have an identical message as cpu0, then don't
> print the redundant info.  However, if a future cpu has a different message,
> happily print that loudly.
> 
> Before the change, you would see something like:
> 
>     ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
>     CPU0: Intel(R) Core(TM)2 Quad CPU    Q9550  @ 2.83GHz stepping 0a
>     Performance Events: PEBS fmt0+, Core2 events, Intel PMU driver.
>     ... version:                2
>     ... bit width:              40
>     ... generic registers:      2
>     ... value mask:             000000ffffffffff
>     ... max period:             000000007fffffff
>     ... fixed-purpose events:   3
>     ... event mask:             0000000700000003
>     NMI watchdog enabled, takes one hw-pmu counter.
>     Booting Node   0, Processors  #1
>     NMI watchdog enabled, takes one hw-pmu counter.
>      #2
>     NMI watchdog enabled, takes one hw-pmu counter.
>      #3 Ok.
>     NMI watchdog enabled, takes one hw-pmu counter.
>     Brought up 4 CPUs
>     Total of 4 processors activated (22607.24 BogoMIPS).
> 
> After the change, it is simplified to:
> 
>     ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
>     CPU0: Intel(R) Core(TM)2 Quad CPU    Q9550  @ 2.83GHz stepping 0a
>     Performance Events: PEBS fmt0+, Core2 events, Intel PMU driver.
>     ... version:                2
>     ... bit width:              40
>     ... generic registers:      2
>     ... value mask:             000000ffffffffff
>     ... max period:             000000007fffffff
>     ... fixed-purpose events:   3
>     ... event mask:             0000000700000003
>     NMI watchdog enabled, takes one hw-pmu counter.
>     Booting Node   0, Processors  #1 #2 #3 Ok.
>     Brought up 4 CPUs

What is the behaviour of this change at suspend/resume time?

> +		if (cpu ==0 || cpu0_err)

Please use checkpatch.  It's free!


