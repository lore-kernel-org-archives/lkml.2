Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475Ab0JSExe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 00:53:34 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:55030 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744Ab0JSExc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 00:53:32 -0400
Date: Tue, 19 Oct 2010 10:22:56 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Ranjit Manomohan <ranjitm@google.com>
Cc: linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
        Nikhil Rao <ncrao@google.com>, Salman Qazi <sqazi@google.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Venkatesh Pallipadi <venki@google.com>, Paul Turner <pjt@google.com>
Subject: Re: [ANNOUNCE] Linsched for 2.6.35 released
Message-ID: <20101019045256.GA20232@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
References: <AANLkTinQAwEMGADYXX=2Rt3RUoMozDReNdpo9NtV1OO7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <AANLkTinQAwEMGADYXX=2Rt3RUoMozDReNdpo9NtV1OO7@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ranjit Manomohan <ranjitm@google.com> [2010-10-12 10:29:54]:

> Hi,
>   I would like to announce the availability of the Linux Scheduler Simulator
> (Linsched) for 2.6.35.
> 
> Originally developed at the University of North Carolina, LinSched is a
> user-space program that hosts the Linux scheduling subsystem.
> Its purpose is to provide a tool for observing and modifying the behavior
> of the Linux scheduler. This makes it a valuable tool in prototyping new
> Linux scheduling policies in a way that may be easier (or otherwise
> less painful or time-consuming) to many developers when compared
> to working with real hardware.

The idea and framework looks very interesting.  I tried it out in
order to understand the workload model and verification model and it
worked fine for the test cases that you have provided.

> Since Linsched allows arbitrary hardware topologies to be modeled,
> it enables testing of scheduler changes on hardware that may not be
> easily accessible to the developer. For example, most developers don't
> have access to a quad-core quad-socket box, but they can use LinSched
> to see how their changes affect the scheduler on such boxes.

I am interested in trying this simulator in order to
design/study/verify task placement logic within the SMP loadbalancer.
Basically the effects of SD_POWERSAVINGS_BALANCE, SD_PREFER_SIBLING,
etc in various topologies.

The current interface and verification mechanism is to create tasks
and observe the runtime received by each task.  In an ideal
loadbalancer situation, all tasks should have received runtime
proportional to their priority.

Can you help me figure out how to get to kstat_cpu() or per-cpu
kernel_stat accounting/utilisation metrics within the simulation?

Thanks for sharing the framework.

--Vaidy

